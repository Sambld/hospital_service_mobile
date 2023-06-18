import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class NavigationDrawerController extends GetxController {

  var selectedIndex = 0.obs;
  var selectedLanguage = 'en'.obs;
  final  languages = ['en','fr', 'ar'];

  @override
  Future<void> onInit() async {
    if (await GetStorage().read('language') != null) {
      selectedLanguage.value = await GetStorage().read('language');
    }else{
      selectedLanguage.value = 'en';
    }
    // TODO: implement onInit
    super.onInit();
  }

  void changeIndex(int index) {
    selectedIndex = index.obs ;
  }

}