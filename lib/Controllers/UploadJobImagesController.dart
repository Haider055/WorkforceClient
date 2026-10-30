import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p;

class UploadJobImagesController extends GetxController {
  // The stored values run opposite to the on-screen order. Pinned here as
  // the single source of truth so the screen and the controller can never
  // disagree about which string means "yes" — getting this backwards is
  // what hid the picked photos before.
  static const String yesValue = "2"; // yes, share photos
  static const String noValue = "1"; // no / maybe later

  RxString? selectedValue = yesValue.obs;

  final ImagePicker picker = ImagePicker();
  final RxList<File> selectedImages = <File>[].obs;
  static const int maxFiles = 15;
  RxBool isChecked = false.obs;

  // One onInit — you had two after pasting, which will not compile.
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(milliseconds: 150), () {
      Constants.descTVFocus.value = true;
    });

    _restoreImages();
  }

  /// The binding runs Get.put() every time this route is pushed, so stepping
  /// back to the description screen and forward again builds a brand new
  /// controller and the picked photos were lost. Constants.selectedImages
  /// survives that, so read them back here.
  void _restoreImages() {
    if (Constants.selectedImages.isEmpty) return;

    // Copy the elements — never hold a reference to the same list object.
    selectedImages.addAll(List<File>.from(Constants.selectedImages));

    // Was "1" here, which is "no / maybe later": the photos came back but
    // the radio said No, so the whole picker section stayed hidden while
    // the images were still in the list.
    selectedValue?.value = yesValue;
    isChecked.value = true; // they already consented to get this far
  }

  /// Mirrors the current picks into Constants so they survive leaving this
  /// screen in either direction. Only photos the user actually agreed to
  /// share are kept.
  void stashImages() {
    final sharing = selectedValue?.value == yesValue;

    // Snapshot BEFORE clearing. Constants.selectedImages used to be assigned
    // the controller's own list, so a clear() on one emptied the other and
    // took the photos with it.
    final keep = (sharing && selectedImages.isNotEmpty && isChecked.value)
        ? List<File>.from(selectedImages)
        : <File>[];

    Constants.selectedImages
      ..clear()
      ..addAll(keep);
  }

  Future<File?> compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

    final XFile? compressedXFile =
        await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: 1024,
      minHeight: 1024,
      quality: 75,
      format: CompressFormat.jpeg,
    );

    if (compressedXFile == null) return null;
    return File(compressedXFile.path);
  }

  Future<void> pickImage() async {
    // The unused dir/targetPath that were here are gone — compressImage
    // builds its own path.
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    // An empty list means the user backed out of the gallery. That is not an
    // error, so no toast.
    if (pickedFiles.isEmpty) return;

    int availableSlots = maxFiles - selectedImages.length;

    if (availableSlots <= 0) {
      Fluttertoast.showToast(
          msg:
              "${Strings.youCanOnlyUploadUpTo(Get.context!)} $maxFiles ${Strings.ximages(Get.context!)}");
      return;
    }

    List<File> validFiles = [];
    int rejected = 0;

    for (var pickedFile in pickedFiles) {
      File imageFile = File(pickedFile.path);
      final int sizeInBytes = await imageFile.length();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 2) {
        File? compressedFile = await compressImage(imageFile);
        if (compressedFile != null) {
          imageFile = compressedFile;
          sizeInMb = await imageFile.length() / (1024 * 1024);
        }
      }

      if (sizeInMb <= 2) {
        validFiles.add(imageFile);
      } else {
        // Previously dropped in silence — the user saw nothing happen.
        rejected++;
      }
    }

    if (rejected > 0) {
      Fluttertoast.showToast(
          msg: Strings.somethingWentWrongPickingImage(Get.context!));
    }

    if (validFiles.isEmpty) return;

    if (validFiles.length > availableSlots) {
      Fluttertoast.showToast(
          msg:
              "${Strings.onlyInfoText(Get.context!)} $availableSlots ${Strings.imagesCanBeAddMoreText(Get.context!)}");
    }

    selectedImages.addAll(validFiles.take(availableSlots));
    Constants.selectedImages = selectedImages;
  }
}
