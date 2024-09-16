import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetbot_app/ad/admob_service.dart';

class RewardedScreen extends StatefulWidget {
  final Function onEarnedReward;
  final Function onFailedReward;

  const RewardedScreen({
    super.key,
    required this.onEarnedReward,
    required this.onFailedReward,
  });

  @override
  RewardedScreenState createState() => RewardedScreenState();
}

class RewardedScreenState extends State<RewardedScreen> {
  var _showLoader = true;

  final String _adUnitId = AdMobService.rewardAdUnitId;

  @override
  void initState() {
    _loadAd();
    super.initState();
  }

  void _loadAd() async {
    try {
      await RewardedAd.load(
          adUnitId: _adUnitId,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdImpression: (ad) {},
                onAdFailedToShowFullScreenContent: (ad, err) {
                  log('onAdFailedToShowFullScreenContent: $ad \\ $err');

                  ad.dispose();
                  widget.onFailedReward();
                },
                onAdDismissedFullScreenContent: (ad) {
                  log('onAdDismissedFullScreenContent: $ad');

                  ad.dispose();
                  widget.onFailedReward();
                },
                onAdClicked: (ad) {});

            ad.show(
                onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              widget.onEarnedReward();
              ad.dispose();
            });
          }, onAdFailedToLoad: (LoadAdError error) {
            log('AdScreen: $error');
            widget.onFailedReward();
          }));
      widget.onEarnedReward();
    } catch (ex) {
      log('Error during AdMob loading: $ex');
      widget.onFailedReward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _showLoader,
      child: const SpinKitChasingDots(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
