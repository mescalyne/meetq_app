import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetbot_app/widgets/localization.dart';

class LanguageChanger extends StatefulWidget {
  final Locale currentLocale;
  final Function? onChange;

  const LanguageChanger({
    this.onChange,
    super.key,
    required this.currentLocale,
  });

  @override
  State<LanguageChanger> createState() => _LanguageChangerState();
}

class _LanguageChangerState extends State<LanguageChanger> {
  List<LocaleType> locales = [];
  int localeIndx = 0;

  @override
  void initState() {
    locales = LocaleType.values;
    localeIndx =
        locales.indexWhere((e) => e.toLocale() == widget.currentLocale);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff171717),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      if (localeIndx - 1 < 0) {
                        localeIndx = locales.length - 1;
                      } else {
                        localeIndx--;
                      }
                    }),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(20),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white, //TODO
                        size: 28,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      locales[localeIndx].getTitle(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      if (localeIndx + 1 == locales.length) {
                        localeIndx = 0;
                      } else {
                        localeIndx++;
                      }
                    }),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(20),
                      child: const RotatedBox(
                        quarterTurns: 90,
                        child: Icon(
                          CupertinoIcons.back,
                          color: Color(0xffFFFFFF),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await LocaleManager.setLocale(
                  localeType: locales[localeIndx],
                  context: context,
                );
                if (result) {
                  Navigator.pop(context);
                  widget.onChange?.call();
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff171717),
                ),
                child: Text(
                  context.localize('accept'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
