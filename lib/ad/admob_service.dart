import 'dart:io';

class AdMobService {
  static String get rewardAdUnitId {
    if (Platform.isAndroid) {
       return 'ca-app-pub-5894728656146604/2697284949'; 
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; //test IOS
    } else {
      return 'ca-app-pub-3940256099942544/5224354917'; //test Android
    }
  }
}
