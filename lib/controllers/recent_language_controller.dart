import 'package:get/get.dart';
import 'package:totranslate/model/language_model.dart';
import 'package:totranslate/services/db_service.dart';

class RecentLanguageController extends GetxController {
  var recentList = <LanguageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRecents();
  }

  Future<void> getRecents() async {
    List<LanguageModel> temp = await DbService.instance.getRecentLanguages();
    if (temp.isNotEmpty) {
      recentList.value = temp;
    }
  }
}
