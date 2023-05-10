// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_icons/line_icons.dart';
import 'package:totranslate/controllers/connection_controller.dart';
import 'package:totranslate/controllers/convs_controller.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/model/conversation_model.dart';
import 'package:totranslate/pages/drawer_page.dart';
import 'package:totranslate/services/db_service.dart';
import 'package:totranslate/shared/height_spacer.dart';
import 'package:totranslate/tabs/conversation_tab.dart';
import 'package:totranslate/tabs/favs_tab.dart';
import 'package:totranslate/tabs/history_tab.dart';
import 'package:totranslate/tabs/home_tab.dart';
import 'package:totranslate/tabs/voice_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int index = 0;
  late final ConvsController controller;
  final textController = TextEditingController();

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConvsController());
    Get.put(ConnectionController());
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
      if (_tabController.index == 1) {
        _createInterstitialAd();
      }
    });
    listenIndexChnage();
  }

  listenIndexChnage() {
    controller.index.listen((value) async {
      _tabController.index = value;
    });
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-9682832451392291/5921183234',
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

  showSave(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 200.0,
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      ),
                    ),
                    const HeightSpacer(height: 30.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                              width: 1.0, color: Colors.grey.withOpacity(0.9))),
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Conversation Name'),
                      ),
                    ),
                    const HeightSpacer(height: 10.0),
                    GestureDetector(
                      onTap: () async {
                        if (textController.text.isNotEmpty) {
                          for (var element in controller.convList) {
                            if (element.lable.isNotEmpty) {
                              //update
                              ConversationModel model = ConversationModel(
                                  id: element.id,
                                  sourceCode: element.sourceCode,
                                  targetCode: element.targetCode,
                                  source: element.source,
                                  target: element.target,
                                  side: element.side,
                                  date: element.date,
                                  lable: textController.text);

                              await DbService.instance
                                  .updateConversation(model);
                            } else {
                              ConversationModel model = ConversationModel(
                                  sourceCode: element.sourceCode,
                                  targetCode: element.targetCode,
                                  source: element.source,
                                  target: element.target,
                                  side: element.side,
                                  date: element.date,
                                  lable: textController.text);
                              await DbService.instance
                                  .createConversationEntity(model);
                            }
                          }
                          controller.convList.clear();
                          Fluttertoast.showToast(
                              msg: "Saved Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Lang.themeColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Name Required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Lang.themeColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 200.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: const BoxDecoration(
                            color: Lang.themeColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ]),
            );
          },
        ),
      ),
    );
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
      appBar: AppBar(
        title: Text(
          'Translate',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Lang.themeColor,
          ),
        ),
        backgroundColor: Get.isDarkMode ? Lang.themeColor : Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const ImageIcon(AssetImage('assets/images/menus.png')),
            color: Get.isDarkMode ? Colors.white : Lang.themeColor,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Visibility(
            visible: index == 1,
            child: GestureDetector(
              onTap: () async {
                if (controller.convList.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Nothing to save",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Lang.themeColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return showSave(context);
                      });
                }
              },
              child: Icon(Icons.save_sharp,
                  color: Get.isDarkMode ? Colors.white : Lang.themeColor),
            ),
          ),
          const SizedBox(
            width: 10.0,
          )
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      drawer: const Drawer(
        child: MyDrawer(),
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            decoration: const BoxDecoration(
              color: Lang.themeColor,
            ),
            child: TabBar(
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3.0, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 5.0)),
              controller: _tabController,
              tabs: const [
                Tab(child: Icon(LineIcons.home)),
                Tab(child: Icon(LineIcons.microphone)),
                Tab(child: Icon(Icons.chat_bubble_outline_sharp)),
                Tab(child: Icon(LineIcons.history)),
                Tab(child: Icon(LineIcons.bookmark)),
              ],
            ),
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: const [
            HomeTap(),
            VoiceTab(),
            CoversationTab(),
            HistoryTab(),
            FavsTab(),
          ])),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 55.0,
            child: getAd(),
          )
        ],
      ),
    );
  }
}
