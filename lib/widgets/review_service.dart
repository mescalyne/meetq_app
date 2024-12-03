import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:meetbot_app/main.dart';
import 'package:meetbot_app/widgets/dialog_popup.dart';
import 'package:meetbot_app/widgets/localization.dart';

void showAskReviewPopup() async {
  showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return DialogPopup(
        onTap: () async {
          await launchUrl(
            Uri.parse(
              Platform.isAndroid
                  ? 'https://play.google.com/store/apps/details?id=com.meetbot_app.meetbot_app'
                  : '', //TODO
            ),
          );
        },
        description: context.localize('enjoyApp'),
        title: context.localize('enjoyAppDescription'),
      );
    },
  );
}

abstract class ReviewService {
  static const reviewKey = 'DATE_OF_ASK_REVIEW';

  static bool isDayToday({required DateTime date}) {
    final today = DateTime.now();

    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }

  static Future<void> setNextDateOfAskReview({
    required DateTime nextDate,
  }) async {
    const flutterSecureStorage = FlutterSecureStorage();

    await flutterSecureStorage.write(
        key: reviewKey, value: nextDate.toString());
  }

  static Future<DateTime> getNextDateOfAskReview() async {
    const flutterSecureStorage = FlutterSecureStorage();

    final nextDateStr = await flutterSecureStorage.read(key: reviewKey);
    DateTime nextDate;
    if (nextDateStr != null) {
      DateTime? result = DateTime.tryParse(nextDateStr);
      if (result == null) {
        nextDate = DateTime.now().add(const Duration(days: 3));
        setNextDateOfAskReview(nextDate: nextDate);
      } else {
        final today = DateTime.now();
        DateTime startOfToday = DateTime(today.year, today.month, today.day);
        nextDate = result;

        if (nextDate.millisecondsSinceEpoch <
            startOfToday.millisecondsSinceEpoch) {
          nextDate = DateTime.now();
        }
      }
    } else {
      nextDate = DateTime.now().add(const Duration(days: 3));
      setNextDateOfAskReview(nextDate: nextDate);
    }
    return nextDate;
  }
}
