import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_icons/line_icons.dart';
import 'package:totranslate/controllers/connection_controller.dart';
import 'package:totranslate/model/history_model.dart';
import 'package:totranslate/services/db_service.dart';
import 'package:totranslate/shared/height_spacer.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<HistoryModel> list = [];
  final ConnectionController connectionController = Get.find();

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  getHistory() async {
    List<HistoryModel> temp = await DbService.instance.getHistory();
    if (temp.isNotEmpty) {
      setState(() {
        list = temp;
      });
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
    final double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              width: width,
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.withOpacity(0.8), width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 25.0),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '(${list[index].langOneCode})',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              SizedBox(
                                width: width * 0.6,
                                child: Text(
                                  list[index].origianlText,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          const HeightSpacer(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '(${list[index].langTwoCode})',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              SizedBox(
                                width: width * 0.6,
                                child: Text(
                                  list[index].translatedText,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      HistoryModel model = HistoryModel(
                          id: list[index].id,
                          langOnename: list[index].langOnename,
                          langOneCode: list[index].langOneCode,
                          langTwoName: list[index].langTwoName,
                          langTwoCode: list[index].langTwoCode,
                          origianlText: list[index].origianlText,
                          translatedText: list[index].translatedText,
                          date: list[index].date,
                          isFav: list[index].isFav == 1 ? 0 : 1);
                      await DbService.instance.updateHistory(model);
                      setState(() {
                        list[index] = model;
                      });
                    },
                    child: Icon(
                      list[index].isFav == 0 ? LineIcons.star : Icons.star,
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            int i = index % 4;
            if (i == 3 && connectionController.isConnected.value) {
              return SizedBox(height: 60.0, child: getAd());
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
