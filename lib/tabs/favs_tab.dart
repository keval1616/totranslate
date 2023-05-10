import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:totranslate/model/history_model.dart';
import 'package:totranslate/services/db_service.dart';
import 'package:totranslate/shared/height_spacer.dart';

class FavsTab extends StatefulWidget {
  const FavsTab({super.key});

  @override
  State<FavsTab> createState() => _FavsTabState();
}

class _FavsTabState extends State<FavsTab> {
  List<HistoryModel> list = [];

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  getHistory() async {
    List<HistoryModel> temp = await DbService.instance.getFavs();
    if (temp.isNotEmpty) {
      setState(() {
        list = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Container(
                width: width,
                margin: const EdgeInsets.only(bottom: 20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.8), width: 1.0),
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
                            isFav: 0);
                        await DbService.instance.updateHistory(model);
                        setState(() {
                          list.remove(list[index]);
                        });
                      },
                      child: Icon(
                        list[index].isFav == 0 ? LineIcons.star : Icons.star,
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
