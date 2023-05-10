import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/pages/home_page.dart';
import 'package:totranslate/pages/intro_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = _getController();
  final pref = GetStorage();

  AnimationController _getController() {
    return _controller = AnimationController(vsync: this);
  }

  AppOpenAd? appOpenAd;

  Future<void> loadAd() async {
    await AppOpenAd.load(
        adUnitId: 'ca-app-pub-9682832451392291/4919092757',
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
          debugPrint('ad loaded');
          appOpenAd = ad;
          appOpenAd!.show();
        }, onAdFailedToLoad: (error) {
          debugPrint('ad failed to load $error');
        }),
        orientation: AppOpenAd.orientationPortrait);
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  _loadAd() async {
    await loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/lottie/splash.json', onLoaded: (value) {
          _controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              int? newUser = pref.read('isNew');
              if (newUser == 1) {
                //old user
                Route route =
                    MaterialPageRoute(builder: (context) => const HomePage());
                Navigator.pushReplacement(context, route);
              } else {
                //new user..show intro screen
                pref.write('isNew', 1);
                pref.write('counter', 0);
                pref.write(Lang.flangName, 'English');
                pref.write(Lang.flangCode, 'en');
                pref.write(Lang.slangName, 'Spanish');
                pref.write(Lang.slangCode, 'es');
                Route route =
                    MaterialPageRoute(builder: (context) => const IntroPage());
                Navigator.pushReplacement(context, route);
              }
            }
          });
          _controller
            ..duration = value.duration
            ..forward();
        }),
      ),
    );
  }
}
