import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class UploadJobImagesController extends GetxController {
  RxString? selectedValue = "2".obs;

  final ImagePicker picker = ImagePicker();
  final RxList<File> selectedImages = <File>[].obs;
  static const int maxFiles = 15;
  RxBool isChecked = false.obs;

  Future<void> pickImage() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isEmpty) {
      Fluttertoast.showToast(
          msg: Strings.somethingWentWrongPickingImage(Get.context!));
      return;
    }

    List<XFile> validFiles = [];

    for (var file in pickedFiles) {
      final File imageFile = File(file.path);
      final int sizeInBytes = await imageFile.length();
      final double sizeInMb = sizeInBytes / (1024 * 1024);
      print("Image size: ${sizeInMb.toStringAsFixed(2)} MB");

      if (sizeInMb <= 2) {
        validFiles.add(file);
      }
    }

    // if (validFiles.isEmpty) return;

    if (validFiles.length < pickedFiles.length) {
      Fluttertoast.showToast(msg: "Files more than 2MB are Skipped");
    }

    int availableSlots = maxFiles - selectedImages.length;

    if (availableSlots <= 0) {
      Fluttertoast.showToast(msg: "You can only upload up to $maxFiles images");
      return;
    }

    if (validFiles.length > availableSlots) {
      Fluttertoast.showToast(
          msg: "Only $availableSlots images can be added more.");
    }

    List<File> newImages =
        validFiles.take(availableSlots).map((file) => File(file.path)).toList();

    selectedImages.addAll(newImages);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
