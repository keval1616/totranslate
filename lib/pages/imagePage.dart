// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/languages.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  var perf = GetStorage();
  File file = File('path');
  final picker = ImagePicker();
  String originalText = '';
  String translatedText = '';
  bool imagePicked = false;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  String texts = '';

  Future getImage(ImageSource source) async {
    if (await Permission.storage.request().isGranted) {
      var image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          imagePicked = true;
          file = File(image.path);
        });
        final inputImage = InputImage.fromFile(file);
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        String finalText = await translate(recognizedText.text);
        setState(() {
          texts = finalText;
        });
      }
    }
  }

  Future<String> translate(String t) async {
    var source = GetLanguages.getLang(perf.read(Lang.flangName) == 'Auto'
        ? 'English'
        : perf.read(Lang.flangName));
    var target = GetLanguages.getLang(perf.read(Lang.slangName));
    late final onDeviceTranslator =
        OnDeviceTranslator(sourceLanguage: source, targetLanguage: target);

    final String response = await onDeviceTranslator.translateText(t);
    return response;
  }

  Widget emptyBlock() {
    return const Center(
      child: Text('No Image Fount'),
    );
  }

  Widget mainBlock() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //     image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
      child: Container(
          padding: const EdgeInsets.all(10.0),
          //decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          child: Text(
            texts,
            style: const TextStyle(fontSize: 15.0),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(perf.read(Lang.flangName) == 'Auto'
                ? 'English'
                : perf.read(Lang.flangName)),
            const SizedBox(
              width: 10.0,
            ),
            const ImageIcon(AssetImage('assets/images/exchange.png')),
            const SizedBox(
              width: 10.0,
            ),
            Text(perf.read(Lang.slangName)),
          ],
        ),
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 14,
            child: imagePicked ? mainBlock() : emptyBlock(),
          ),
          Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width,
                  height: 50.0,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: const BoxDecoration(color: Lang.themeColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: const Icon(
                          LineIcons.image,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage(ImageSource.camera);
                        },
                        child: const Icon(
                          LineIcons.camera,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: texts));
                          Fluttertoast.showToast(
                              msg: "Text copied successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: const Icon(
                          LineIcons.copy,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
