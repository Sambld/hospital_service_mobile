import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infectious_diseases_service/Utils/ResponsiveFontSizes.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../Constants/Constants.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/Observation/ObservationController.dart';
import '../../Models/Image.dart' as image_model;

class ObservationScreen extends StatefulWidget {
  const ObservationScreen({Key? key}) : super(key: key);

  @override
  State<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends State<ObservationScreen> {
  final _controller = Get.put(ObservationController());
  final _authController = Get.find<AuthController>();
  final String _storageUrl = '${apiUrl}/storage/images/';
  // final String _storageUrl = 'http://10.0.2.2:8000/storage/images/';
  //
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // add images floating action button
        floatingActionButton:
        !_controller.OC.medicalRecord.value.isClosed() && _controller.OC.medicalRecord.value.userId ==  _authController.user['id'] ? SpeedDial(
          overlayOpacity: 0.2,
          animatedIcon: AnimatedIcons.list_view,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.photo_library),
              label: "Add photo from gallery".tr,
              onTap: () async {
                await _controller.uploadMultipleImages();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.camera_alt),
              label: "Add photo from camera".tr,
              onTap: () async {
                await _controller.uploadCameraImage();
              },
            ),
          ],
        ) : null,
        // and expandable floating action button that contain add photo from gallery and add photo from camera


        appBar: AppBar(
          flexibleSpace: kAppBarColor,
          title: Text("Observation #${_controller.observation.value.id.toString()}"),
        ),
        body: _controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoCard([
                      Row(
                        // mainAxisSize: MainAxisSize.values[0],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:  [
                          Expanded(
                            child: Text(
                              _controller.observation.value.name ?? '',
                              style:  TextStyle(fontSize: ResponsiveFontSize.large()),


                            ),
                          ),
                          // edit icon button
                          !_controller.OC.medicalRecord.value.isClosed() && _controller.OC.medicalRecord.value.userId ==  _authController.user['id'] ? IconButton(
                            icon: const Icon(Icons.edit , color: Colors.green,),
                            onPressed: () {
                              Get.defaultDialog(

                                title: "Edit Observation Name".tr,

                                titleStyle: const TextStyle(fontSize: 16),
                                content: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextFormField(
                                    controller: _controller.editNameController,
                                    decoration: const InputDecoration(
                                      hintText: "Enter new name",
                                    ),
                                  ),
                                ),
                                textConfirm: "Save",
                                buttonColor: Colors.green,
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  _controller.updateObservationName();
                                  _controller.editNameController.clear();
                                  Get.back();
                                },
                              );
                            },
                          ): const SizedBox(),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Text('${"Date".tr} : ${DateFormat('dd/MM/yyyy').format(_controller.observation.value.createdAt!)}')


                    ], Colors.green),
                    const SizedBox(height: 16),
                     Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        // rounded corners
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green,
                        ),
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 40,
                        child: Text(
                          '${"Photos".tr}:',
                          style: TextStyle(fontSize: ResponsiveFontSize.xLarge() , color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(builder: (context, constrains) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller
                            .observation.value.images?.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constrains.maxWidth > 600 ? 4 : 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final image_model.Image? image = _controller
                              .observation.value.images?[index];
                          return LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return GestureDetector(
                                onTap: () {
                                  _currentPhotoIndex = index;
                                  showDialog(
                                    context: context,
                                    builder: (_) => Scaffold(
                                      appBar: AppBar(
                                        backgroundColor: Colors.black,

                                        actions:  [
                                          !_controller.OC.medicalRecord.value.isClosed() && _controller.OC.medicalRecord.value.userId ==  _authController.user['id'] ? Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                                size: 30,
                                              ), onPressed: () {
                                                // show Get. confirmation dialog
                                                Get.defaultDialog(
                                                  title: "Delete".tr,
                                                  middleText: "Are you sure you want to delete this image?".tr,
                                                  textConfirm: "Yes".tr,
                                                  textCancel: "No".tr,
                                                  confirmTextColor: Colors.white,
                                                  cancelTextColor: Colors.redAccent,
                                                  buttonColor: Colors.red,
                                                  onConfirm: () async {
                                                    await _controller.deleteImage(image.id!);
                                                    Get.back();
                                                    Get.back();
                                                  },
                                                  onCancel: () {

                                                  },
                                                );


                                            },
                                            ),
                                          ) : const SizedBox(),
                                        ],
                                      ),


                                      body: SafeArea(
                                        child: Container(
                                          constraints: const BoxConstraints.expand(),
                                          child: PhotoViewGallery.builder(
                                            itemCount: _controller
                                                .observation
                                                .value
                                                .images
                                                ?.length,
                                            builder: (BuildContext context,
                                                int index) {
                                              final image_model.Image? image =
                                                  _controller
                                                      .observation
                                                      .value
                                                      .images?[index];
                                              return PhotoViewGalleryPageOptions(

                                                imageProvider:
                                                    CachedNetworkImageProvider(
                                                        _storageUrl +
                                                            image!.path! ),
                                              );
                                            },
                                            pageController: PageController(
                                                initialPage:
                                                    _currentPhotoIndex),
                                            onPageChanged: (int index) {
                                              setState(() {
                                                _currentPhotoIndex = index;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: _storageUrl + image!.path!,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }

  Card infoCard(children, color, {vMargin = 12.0}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: vMargin),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: color,
                width: 4.0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children ?? [],
          ),
        ),
      ),
    );
  }
}
