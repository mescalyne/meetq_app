import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetbot_app/ad/ad_screen.dart';
import 'package:meetbot_app/widgets/language_changer.dart';
import 'package:meetbot_app/widgets/localization.dart';
import 'package:meetbot_app/widgets/review_service.dart';

void main() async {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'EN');

  @override
  void initState() {
    super.initState();
    LocaleManager.getCurrent(context: context)
        .then((value) => setState(() => _locale = value.toLocale()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      locale: _locale,
      navigatorKey: navigatorKey,
      supportedLocales: LocaleType.getLocales(),
      localizationsDelegates: <LocalizationsDelegate>[
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: 'assets/json',
          ),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'zametka',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> questions = [];
  List<int> previousIndex = [];
  int currIndex = -1;
  bool isText = false;
  String currText = '';

  InitializationStatus? mobileAds;

  final storage = const FlutterSecureStorage();
  final advStorageKey = 'ADV_STORAGE_KEY';

  Future<List<String>> loadQuestions() async {
    final jsonName = await LocaleManager.getCurrent(context: context);
    final String jsonString =
        await rootBundle.loadString('assets/json/$jsonName.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> questionsJson = jsonMap['questions'];
    final List<String> questions =
        questionsJson.map((question) => question as String).toList();

    return questions;
  }

  void load() async {
    questions = await loadQuestions();
    getNewQuestion();
  }

  void getNewQuestion() async {
    isText = false;
    currText = '';
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    final rand = Random();
    if (questions.length * 0.7 < previousIndex.length) {
      previousIndex = [];
    }
    int num = -1;
    do {
      num = rand.nextInt(questions.length);
    } while (previousIndex.contains(num));

    setState(() {
      currIndex = num;
      previousIndex.add(currIndex);
      isText = questions.isNotEmpty && currIndex != -1;
      currText = isText ? questions[currIndex] : '';
    });
  }

  void loadAd() async {
    mobileAds = await MobileAds.instance.initialize();
  }

  @override
  void initState() {
    load();
    loadAd();
    super.initState();
  }

  Future<bool> showAdScreen(BuildContext context) async {
    final completer = Completer<bool>();
    showDialog(
      useSafeArea: false,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return RewardedScreen(
          onEarnedReward: () {
            completer.complete(true);
            Navigator.pop(context);
          },
          onFailedReward: () {
            completer.complete(false);
            Navigator.pop(context);
          },
        );
      },
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final buttonDebouncer = AsyncCache(const Duration(seconds: 1));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFDC325),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () => buttonDebouncer.fetch(
              () async {
                showGeneralDialog(
                  context: context,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: LanguageChanger(
                        currentLocale: FlutterI18n.currentLocale(context) ??
                            const Locale('en', 'US'),
                        onChange: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              settings: const RouteSettings(name: 'settings'),
                              builder: (context) => const MyHomePage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                context.localize('name'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff171717),
                  fontFamily: 'zametka',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xffFDC325),
              alignment: Alignment.centerLeft,
              child: AnimatedTextKit(
                key: ValueKey<bool>(isText),
                totalRepeatCount: isText ? 1 : 1000,
                animatedTexts: [
                  TypewriterAnimatedText(
                    currText,
                    textStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff171717),
                      fontFamily: 'zametka',
                    ),
                    cursor: '|',
                    speed: Duration(milliseconds: isText ? 50 : 400),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (questions.isNotEmpty) {
                buttonDebouncer.fetch(
                  () async {
                    final result = await storage.read(key: advStorageKey);
                    int count = int.tryParse(result ?? '0') ?? 0;
                    bool newQuestion = true;
                    if (count == 4) {
                      await storage.write(key: advStorageKey, value: '0');
                      if (mobileAds != null) {
                        // ignore: use_build_context_synchronously
                        newQuestion = await showAdScreen(context);
                      }
                    } else {
                      count++;
                      await storage.write(key: advStorageKey, value: '$count');

                      final nextDate =
                          await ReviewService.getNextDateOfAskReview();
                      if (ReviewService.isDayToday(date: nextDate)) {
                        ReviewService.setNextDateOfAskReview(
                            nextDate: nextDate.add(const Duration(days: 7)));
                        await Future.delayed(const Duration(seconds: 3));
                        showAskReviewPopup();
                      }
                    }

                    if (newQuestion) {
                      getNewQuestion();
                    }
                  },
                );
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              height: 100 + MediaQuery.of(context).padding.bottom,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xff171717),
              child: Center(
                child: Text(
                  context.localize('changeQuestion'),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xffFFFFFF),
                    fontFamily: 'zametka',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
