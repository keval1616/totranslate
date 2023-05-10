import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/languages.dart';
import 'package:totranslate/model/language_model.dart';
import 'package:totranslate/services/db_service.dart';

class SelectLanguagePage extends StatefulWidget {
  final String selected;
  final int position;
  const SelectLanguagePage(
      {super.key, required this.selected, required this.position});

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  List<LanguageModel> recents = [];
  List<LanguageModel> all = [];
  List<LanguageModel> temp2 = [];
  List<LanguageModel> recentsPermanent = [];
  var pref = GetStorage();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getrecents();
    temp2 = GetLanguages.langList;
    controller.addListener(listenController);
  }

  listenController() async {
    String temp = controller.text;
    List<LanguageModel> tempList = [];

    if (temp.isNotEmpty) {
      for (var element in temp2) {
        if (partialRatio(temp, element.langName) > 60) {
          tempList.add(element);
        }
      }
      setState(() {
        recents.clear();
        all = tempList;
      });
    } else {
      setState(() {
        all = GetLanguages.langList;
      });
      List<LanguageModel> temp = await DbService.instance.getRecentLanguages();
      if (temp.isNotEmpty) {
        setState(() {
          recents = temp;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getrecents() async {
    setState(() {
      all = GetLanguages.langList;
    });
    List<LanguageModel> temp = await DbService.instance.getRecentLanguages();
    if (temp.isNotEmpty) {
      recentsPermanent = temp;
      setState(() {
        recents = temp;
      });
    }
  }

  Widget autoSelectTab() {
    return GestureDetector(
      onTap: () {
        pref.write(Lang.flangCode, 'auto');
        pref.write(Lang.flangName, 'Auto');
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Lang.themeColor.withOpacity(0.5),
        ),
        child: const Center(
          child: Text(
            'Audo Detect',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  Widget recentBlock() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Lang.themeColor.withOpacity(0.5),
            ),
            child: const Text(
              'Recently Used',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0),
            ),
          ),
          ListView.builder(
              itemCount: recents.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () async {
                      switch (widget.position) {
                        case 1:
                          pref.write(Lang.flangName, recents[index].langName);
                          pref.write(Lang.flangCode, recents[index].langCode);
                          break;
                        case 2:
                          pref.write(Lang.slangName, recents[index].langName);
                          pref.write(Lang.slangCode, recents[index].langCode);
                          break;
                      }
                      bool found = false;
                      for (var element in recentsPermanent) {
                        if (element.langName == recents[index].langName) {
                          found = true;
                        }
                      }
                      if (!found) {
                        await DbService.instance
                            .createRecentLanguage(all[index]);
                      }
                      Get.back();
                    },
                    child: rowCard(recents[index]));
              })
        ],
      ),
    );
  }

  Widget rowCard(LanguageModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    model.langName,
                    style: TextStyle(
                        color: widget.selected == model.langName
                            ? Colors.red
                            : Get.isDarkMode
                                ? Colors.white
                                : Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Text(model.localName,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: widget.selected == model.langName
                          ? Colors.red
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.grey,
                    )),
              ],
            ),
          ),
          widget.selected == model.langName
              ? const Icon(
                  Icons.star,
                  color: Colors.red,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.withOpacity(0.9)),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: 'Search Language'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Lang.themeColor : Colors.white,
        elevation: 0.0,
        title: Text(
          'Select Language',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Lang.themeColor,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Lang.themeColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(),
            if (widget.position == 1) autoSelectTab(),
            if (recents.isNotEmpty) recentBlock(),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Lang.themeColor.withOpacity(0.5),
              ),
              child: const Text(
                'All Languages',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0),
              ),
            ),
            ListView.builder(
              itemCount: all.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    switch (widget.position) {
                      case 1:
                        pref.write(Lang.flangName, all[index].langName);
                        pref.write(Lang.flangCode, all[index].langCode);
                        break;
                      case 2:
                        pref.write(Lang.slangName, all[index].langName);
                        pref.write(Lang.slangCode, all[index].langCode);
                        break;
                    }
                    bool found = false;
                    for (var element in recentsPermanent) {
                      if (element.langName == all[index].langName) {
                        found = true;
                      }
                    }
                    //print('found ${recentsPermanent.length}');

                    if (!found) {
                      await DbService.instance.createRecentLanguage(all[index]);
                    }
                    Get.back();
                  },
                  child: rowCard(all[index]),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
