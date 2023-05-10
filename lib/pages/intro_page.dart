import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/pages/home_page.dart';
import 'package:totranslate/shared/height_spacer.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Lottie.asset('assets/lottie/intro.json')),
            const HeightSpacer(height: 30.0),
            const Text(
              'Translate In Conversations',
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  color: Lang.themeColor),
            ),
            const HeightSpacer(height: 40.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Lorem Ipsum is simply dummy text of the printing ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const HeightSpacer(height: 30.0),
            GestureDetector(
              onTap: () {
                Route route =
                    MaterialPageRoute(builder: (context) => const HomePage());
                Navigator.pushReplacement(context, route);
              },
              child: DelayedDisplay(
                delay: const Duration(seconds: 1),
                slidingBeginOffset: const Offset(0.0, 0.55),
                slidingCurve: Curves.easeIn,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15.0),
                  decoration: const BoxDecoration(
                      color: Lang.themeColor,
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  child: const DelayedDisplay(
                    delay: Duration(seconds: 2),
                    slidingBeginOffset: Offset(0.0, 0.55),
                    slidingCurve: Curves.easeIn,
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
