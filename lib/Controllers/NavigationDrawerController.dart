import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class NavigationDrawerController extends GetxController {

  var selectedIndex = 0.obs;
  var selectedLanguage = 'EN'.obs;
  final  languages = ['EN','FR', 'AR'];

  @override
  Future<void> onInit() async {
    if (await GetStorage().read('language') != null) {
      selectedLanguage.value = GetStorage().read('language');
    }else{
      selectedLanguage.value = 'EN';
    }
    // TODO: implement onInit
    super.onInit();
  }

  void changeIndex(int index) {
    selectedIndex = index.obs ;
  }

}