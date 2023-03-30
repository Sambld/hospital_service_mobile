import 'package:get/get.dart';



class NavigationDrawerController extends GetxController {

  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex = index.obs ;
    print("inded changed to $index");
  }

}