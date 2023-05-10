import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/languages.dart';
import 'package:totranslate/model/history_model.dart';
import 'package:totranslate/pages/imagePage.dart';
import 'package:totranslate/pages/select_language.dart';
import 'package:totranslate/services/db_service.dart';
import 'package:totranslate/shared/height_spacer.dart';
import 'package:translator/translator.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String firstlanguage = '';
  String secondLanguage = '';
  String firstLanguageCode = '';
  String secondLanguageCode = '';
  bool isForward = false;
  bool showToBlock = false;
  bool isLoadin = false;
  final _from = TextEditingController();
  final _to = TextEditingController();
  var box = GetStorage();
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  TextToSpeech tts = TextToSpeech();
  final translator = GoogleTranslator();

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    getLanguageData();
    _initSpeech();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-9682832451392291/1492705833',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  getLanguageData() {
    firstLanguageCode = box.read(Lang.flangCode);
    secondLanguageCode = box.read(Lang.slangCode);
    setState(() {
      firstlanguage = box.read(Lang.flangName);
      secondLanguage = box.read(Lang.slangName);
    });
  }

  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
  }

  void _startListening() async {
    await speechToText.listen(
      localeId: box.read(Lang.flangCode),
      onResult: _onSpeechResult,
    );
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _from.text = result.recognizedWords;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  void translate() async {
    var source = GetLanguages.getLang(box.read(Lang.flangName));
    var target = GetLanguages.getLang(box.read(Lang.slangName));
    late final onDeviceTranslator =
        OnDeviceTranslator(sourceLanguage: source, targetLanguage: target);
    setState(() {
      isLoadin = true;
    });
    final String response = await onDeviceTranslator.translateText(_from.text);
    _to.text = response;
    setState(() {
      showToBlock = true;
      isLoadin = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    HistoryModel model = HistoryModel(
        langOnename: firstlanguage,
        langOneCode: box.read(Lang.flangCode),
        langTwoName: secondLanguage,
        langTwoCode: box.read(Lang.slangCode),
        origianlText: _from.text,
        translatedText: _to.text,
        date: DateTime.now().toString(),
        isFav: 0);
    await DbService.instance.createHistory(model);
  }

  Widget translateButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: isLoadin ? Colors.red : Lang.themeColor,
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLoadin)
            Container(
                width: 20.0,
                height: 20.0,
                margin: const EdgeInsets.only(right: 10.0),
                child: Lottie.asset('assets/lottie/loading.json')),
          const SizedBox(),
          const Text(
            'Translate',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  Widget selectLanguage() {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.withOpacity(0.9)),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              Get.to(() =>
                      SelectLanguagePage(selected: firstlanguage, position: 1))!
                  .then((value) {
                getLanguageData();
              });
            },
            child: Text(
              firstlanguage,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
          RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
              child: GestureDetector(
                  onTap: () {
                    String temp = firstlanguage;
                    String textTemp = _from.text;
                    String prefTempLanguageName = box.read(Lang.flangName);
                    String prefTempLanguageCode = box.read(Lang.flangCode);
                    if (isForward) {
                      _controller.reset();
                      _controller.forward();
                    } else {
                      _controller.forward();
                      isForward = true;
                    }
                    _from.text = _to.text;
                    _to.text = textTemp;
                    box.write(Lang.flangName, box.read(Lang.slangName));
                    box.write(Lang.slangName, prefTempLanguageName);
                    box.write(Lang.flangCode, box.read(Lang.slangCode));
                    box.write(Lang.slangCode, prefTempLanguageCode);
                    setState(() {
                      firstlanguage = secondLanguage;
                      secondLanguage = temp;
                    });
                  },
                  child: const ImageIcon(
                      AssetImage('assets/images/exchange.png')))),
          GestureDetector(
            onTap: () {
              Get.to(() => SelectLanguagePage(
                      selected: secondLanguage, position: 2))!
                  .then((value) {
                getLanguageData();
              });
            },
            child: Text(
              secondLanguage,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget header(String title, String language) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15.0),
        ),
        Text(
          language,
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget transLateFrom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header('Translate from', firstlanguage),
        const HeightSpacer(height: 5.0),
        Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.grey.withOpacity(0.9), width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _from,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _startListening();
                    },
                    child: Icon(
                      LineIcons.microphone,
                      color: speechToText.isListening
                          ? Colors.red
                          : Lang.themeColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      speak(_from.text, firstLanguageCode);
                    },
                    child: const Icon(LineIcons.volumeUp),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const ImagePage());
                    },
                    child: const Icon(LineIcons.camera),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (firstlanguage == 'Auto') {
                          translateAuto();
                        } else {
                          translate();
                        }
                        int counter = box.read('counter') ?? 0;
                        counter++;
                        box.write('counter', counter);
                        if (counter % 5 == 0) {
                          _createInterstitialAd();
                        }
                      },
                      child: translateButton()),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget transLateTo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header('Translate to', secondLanguage),
        const HeightSpacer(height: 5.0),
        Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.grey.withOpacity(0.9), width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _to,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _to.text));
                      Fluttertoast.showToast(
                          msg: "Text copied successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: const Icon(LineIcons.copy),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      speak(_to.text, secondLanguageCode);
                    },
                    child: const Icon(LineIcons.volumeUp),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  void speak(String text, String languageCode) {
    tts.setLanguage(languageCode);
    tts.speak(text);
  }

  void translateAuto() async {
    //detect the language first

    Translation translation = await translator.translate(_from.text);
    String codee = translation.sourceLanguage.code;
    //update the properties

    String languageName = '';

    if (codee == 'auto') {
      setState(() {
        firstlanguage = 'English';
      });
      languageName = 'English';
    } else {
      for (var element in GetLanguages.langList) {
        if (element.langCode == codee) {
          languageName = element.langName;
        }
      }
    }
    if (languageName.isNotEmpty) {
      box.write(Lang.flangCode, codee == 'auto' ? 'en' : codee);
      box.write(Lang.flangName, languageName);

      getLanguageData();
      //submit the data to translate();
      translate();
    } else {
      Fluttertoast.showToast(
          msg: "Lanugae is not supported",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget getAd() {
    BannerAdListener bannerAdListener =
        BannerAdListener(onAdWillDismissScreen: (ad) {
      ad.dispose();
    }, onAdClosed: (ad) {
      debugPrint('Ad closed');
    }, onAdLoaded: (ad) {
      debugPrint('Ad loaded');
    });

    BannerAd bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: 'ca-app-pub-9682832451392291/8081314859',
        listener: bannerAdListener,
        request: const AdRequest());
    bannerAd.load();
    return AdWidget(ad: bannerAd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeightSpacer(height: 10.0),
              selectLanguage(),
              const HeightSpacer(height: 30.0),
              transLateFrom(),
              const HeightSpacer(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                child: getAd(),
              ),
              if (showToBlock)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpacer(height: 10.0),
                    transLateTo(),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
