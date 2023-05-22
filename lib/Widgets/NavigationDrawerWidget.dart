import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infectious_diseases_service/Controllers/NavigationDrawerController.dart';
import '../Controllers/AuthController.dart';
import '../Services/Api.dart';
import '../Utils/ResponsiveFontSizes.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final NavigationDrawerController _controller = Get.find();
  final authController = Get.find<AuthController>();
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  final selectedLanguage = 'en'.obs;

  @override
  Widget build(BuildContext context) {
    final name =
        '${authController.user['first_name']} ${authController.user['last_name']}';
    final role = authController.user['role'];

    return Drawer(
      // backgroundColor: Colors.blueGrey,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: <Widget>[
                  buildHeader(
                    name: name,
                    role: role,
                    onClicked: () => print('Header'),
                  ),
                  Container(
                    padding: padding,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        // buildSearchField(),
                        const SizedBox(height: 24),
                        buildMenuItem(
                          text: 'Dashboard'.tr,
                          icon: Icons.dashboard_customize_outlined,
                          onClicked: () => selectedItem(context, 0),
                        ),
                        const SizedBox(height: 16),
                        $(buildMenuItem(
                          text: 'Patients'.tr,
                          icon: Icons.people,
                          onClicked: () => selectedItem(context, 1),
                        )),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'Medical Records'.tr,
                          icon: Icons.medical_services,
                          onClicked: () => selectedItem(context, 2),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 24),
                        buildMenuItem(
                          text: 'Sign Out'.tr,
                          icon: Icons.logout,
                          onClicked: () => selectedItem(context, 5),
                        ),

                        // language changer
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DropdownButton(
                                value: _controller.selectedLanguage.value,
                                items: _controller.languages
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style:
                                                const TextStyle(color: Colors.black , fontSize: 16),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) async {
                                  await GetStorage().write('language', value);
                                  Get.updateLocale(Locale(value.toString()));
                                  _controller.selectedLanguage.value =
                                      value.toString();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget $(child) {

    if (authController.isNurse()) {
      return Container();
    } else {
      return child;
    }

  }

  Widget buildHeader({
    required String name,
    required String role,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              ImageIcon(
                authController.user['role'] == 'doctor' ? const AssetImage('assets/images/doctor.png') : const AssetImage('assets/images/nurse.png'),
                size: 50,
                color: Colors.blueAccent,),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(fontSize: ResponsiveFontSize.xLarge()),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    role,
                    style: const TextStyle(fontSize: 14),
                  ),

                  // two icon buttons to change language English and French
                ],
              ),
              // Spacer(),
              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              //   child: Icon(Icons.add_comment_outlined, color: Colors.white),
              // )
            ],
          ),
        ),
      );

  // Widget buildSearchField() {
  //   final color = Colors.white;
  //
  //   return TextField(
  //     style: TextStyle(color: color),
  //     decoration: InputDecoration(
  //       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //       hintText: 'Search',
  //       hintStyle: TextStyle(color: color),
  //       prefixIcon: Icon(Icons.search, color: color),
  //       filled: true,
  //       fillColor: Colors.white12,
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(5),
  //         borderSide: BorderSide(color: color.withOpacity(0.7)),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(5),
  //         borderSide: BorderSide(color: color.withOpacity(0.7)),
  //       ),
  //     ),
  //   );
  // }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon , color: Colors.black87),
      title: Text(text, style: const TextStyle(fontSize: 16 ,fontWeight: FontWeight.w400 , color: Colors.black87)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    switch (index) {
      case 0:
        if (authController.user.value['role'] == 'doctor'){
          Get.offNamed('/doctor-dashboard');
        } else {
          Get.offNamed('/nurse-dashboard');
        }
        break;
      case 1:
        Get.offNamed('/patients');
        break;
      case 2:
        Get.offNamed('/medical-records');
        break;
      case 5:
        Api.logout();
        break;
    }
  }
}
