import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:totranslate/controllers/convs_controller.dart';
import 'package:totranslate/lang.dart';
import 'package:totranslate/model/conversation_model.dart';
import 'package:totranslate/services/db_service.dart';
import 'package:totranslate/shared/height_spacer.dart';

class CoversationTab extends StatefulWidget {
  const CoversationTab({super.key});

  @override
  State<CoversationTab> createState() => _CoversationTabState();
}

class _CoversationTabState extends State<CoversationTab> {
  List<String> names = [];
  List<ConversationModel> list = [];
  final ConvsController controller = Get.find();

  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() async {
    List<ConversationModel> temp = [];
    temp = await DbService.instance.getConvs();
    if (temp.isNotEmpty) {
      list = temp;
      for (var element in list) {
        if (!names.contains(element.lable)) {
          setState(() {
            names.add(element.lable);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: names.isEmpty
            ? const Center(
                child: Text(
                  'No record found',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: names.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  int count = 0;
                  for (var e in list) {
                    if (e.lable == names[index]) {
                      count++;
                    }
                  }
                  return GestureDetector(
                    onTap: () {
                      controller.convList.clear();
                      for (var e in list) {
                        if (e.lable == names[index]) {
                          controller.convList.add(e);
                        }
                      }
                      controller.index.value = 1;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                          color: Lang.themeColor.withOpacity(0.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                names[index],
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              const HeightSpacer(height: 10.0),
                              Text(
                                'Total entry: $count',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Lang.themeColor),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              for (var item in list) {
                                if (item.lable == names[index]) {
                                  await DbService.instance.deleteConvs(item.id);
                                }
                              }
                              controller.convList.clear();
                              setState(() {
                                names.remove(names[index]);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
