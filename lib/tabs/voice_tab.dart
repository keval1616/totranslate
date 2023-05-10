import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:totranslate/controllers/convs_controller.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/languages.dart';
import 'package:totranslate/model/conversation_model.dart';
import 'package:totranslate/shared/height_spacer.dart';
import 'package:translator/translator.dart';

class VoiceTab extends StatefulWidget {
  const VoiceTab({super.key});

  @override
  State<VoiceTab> createState() => _VoiceTabState();
}

class _VoiceTabState extends State<VoiceTab> {
  var pref = GetStorage();
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  TextToSpeech tts = TextToSpeech();
  String sourceText = '';
  String targetText = '';
  String sourceName = '';
  String targetName = '';
  String sourceCode = '';
  String targetCode = '';
  int side = 0;
  final translator = GoogleTranslator();
  String firstLanuage = '';
  final ConvsController controller = Get.find();
  int falg = 0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    getLang();
  }

  getLang() {
    setState(() {
      firstLanuage = pref.read(Lang.flangName);
    });
  }

  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
  }

  void _startListening(String code) async {
    await speechToText.listen(
      localeId: code,
      onResult: _onSpeechResult,
    );
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (speechToText.isNotListening) {
      firstLanuage == 'Auto'
          ? translateAuto(result.recognizedWords)
          : translate(result.recognizedWords);
    }
  }

  void speak(String text, String source) {
    tts.setLanguage(targetCode);
    tts.speak(text);
    ConversationModel model = ConversationModel(
        sourceCode: sourceCode,
        targetCode: targetCode,
        source: source,
        target: text,
        side: side,
        date: DateTime.now().toString(),
        lable: '');
    controller.convList.insert(0, model);
  }

  Widget optionBlock(String name, int i) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          border: Border.all(color: Colors.grey.withOpacity(0.9), width: 1.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Icon(
            LineIcons.microphone,
            color: i == falg && speechToText.isListening
                ? Colors.red
                : Lang.themeColor,
          ),
        ],
      ),
    );
  }

  void translateAuto(String text) async {
    Translation translation = await translator.translate(text);
    String codee = translation.sourceLanguage.code;
    //update the properties

    String languageName = '';

    if (codee == 'auto') {
      setState(() {
        firstLanuage = 'English';
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
      pref.write(Lang.flangCode, codee == 'auto' ? 'en' : codee);
      pref.write(Lang.flangName, languageName);

      getLang();
      //submit the data to translate();
      translate(text);
    } else {
      Fluttertoast.showToast(
          msg: "Lanugae is not supported",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Lang.themeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void translate(String text) async {
    var source = GetLanguages.getLang(sourceName);
    var target = GetLanguages.getLang(targetName);
    late final onDeviceTranslator =
        OnDeviceTranslator(sourceLanguage: source, targetLanguage: target);

    final String response = await onDeviceTranslator.translateText(text);
    setState(() {
      sourceText = text;
      targetText = response;
    });
    if (!speechToText.isListening) {
      speak(response, text);
    }
  }

  Widget emptyBlock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200.0,
          height: 200.0,
          child: Lottie.asset('assets/lottie/convs.json'),
        ),
        const HeightSpacer(height: 10.0),
        const Text(
          'Start Conversation',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget convsBlock() {
    final double width = MediaQuery.of(context).size.width - 20;
    return SizedBox(
      width: width,
      child: Obx((() => ListView.builder(
          itemCount: controller.convList.length,
          shrinkWrap: true,
          reverse: true,
          itemBuilder: (context, index) {
            return Align(
              alignment: controller.convList[index].side == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: 10.0,
                    right:
                        controller.convList[index].side == 0 ? width * 0.2 : 0,
                    left:
                        controller.convList[index].side == 1 ? width * 0.2 : 0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(244, 180, 117, 1),
                          Color.fromRGBO(99, 85, 162, 1)
                        ],
                        begin: FractionalOffset(0.0, 0.5),
                        end: FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                    borderRadius: controller.convList[index].side == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0))
                        : const BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0))),
                child: Column(
                  mainAxisAlignment: controller.convList[index].side == 0
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.convList[index].source,
                      textAlign: controller.convList[index].side == 0
                          ? TextAlign.start
                          : TextAlign.end,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    const HeightSpacer(height: 10.0),
                    Text(
                      controller.convList[index].target,
                      textAlign: controller.convList[index].side == 0
                          ? TextAlign.start
                          : TextAlign.end,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            );
          }))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: controller.convList.isEmpty ? emptyBlock() : convsBlock(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        sourceName = pref.read(Lang.flangName);
                        targetName = pref.read(Lang.slangName);
                        sourceCode = pref.read(Lang.flangCode);
                        targetCode = pref.read(Lang.slangCode);
                        side = 0;
                        falg = 1;
                        _startListening(pref.read(Lang.flangCode));
                      },
                      child: optionBlock(firstLanuage, 1)),
                  GestureDetector(
                      onTap: () {
                        sourceName = pref.read(Lang.slangName);
                        targetName = pref.read(Lang.flangName);
                        sourceCode = pref.read(Lang.slangCode);
                        targetCode = pref.read(Lang.flangCode);
                        side = 1;
                        falg = 2;
                        _startListening(pref.read(Lang.slangCode));
                      },
                      child: optionBlock(pref.read(Lang.slangName), 2)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
