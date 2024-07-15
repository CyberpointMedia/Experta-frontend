import 'dart:io';
import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/presentation/Basic_Info/models/basic_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class BasicProfileInfoController extends GetxController {
  final ApiService apiService = ApiService();
  RxBool isLoading = true.obs;
  Rx<BasicProfileInfoModel> basicInfoModelObj = BasicProfileInfoModel(
    id: '',
    firstName: '',
    lastName: '',
    posts: [],
    rating: 0,
    createdAt: '',
    updatedAt: '',
    bio: '',
    displayName: '',
    facebook: '',
    instagram: '',
    linkedin: '',
    twitter: '',
    profilePic: '',
  ).obs;
  TextEditingController textField1 = TextEditingController();
  TextEditingController textField2 = TextEditingController();
  TextEditingController textField3 = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();

  RxList<String> socialLinks = <String>[].obs;
  Rx<File?> imageFile = Rx<File?>(null);
  RxString profileImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchBasicInfo();
  }

  Future<void> fetchBasicInfo() async {
    try {
      final basicInfoJson = await apiService.fetchBasicInfo();
      if (basicInfoJson != null) {
        basicInfoModelObj.value = BasicProfileInfoModel.fromJson(basicInfoJson);
        updateTextFields();
        updateSocialLinks();
        profileImageUrl.value = basicInfoModelObj.value.profilePic;
      } else {
        Get.snackbar('Error', 'Failed to load basic info: Data is null');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load basic info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateTextFields() {
    textField1.text =
        '${basicInfoModelObj.value.firstName ?? ''} ${basicInfoModelObj.value.lastName ?? ''}'
            .trim();
    textField2.text = basicInfoModelObj.value.displayName ?? '';
    textField3.text = basicInfoModelObj.value.bio ?? '';
  }

  void updateSocialLinks() {
    socialLinks.clear();
    if (basicInfoModelObj.value.facebook.isNotEmpty) {
      socialLinks.add(basicInfoModelObj.value.facebook);
    }
    if (basicInfoModelObj.value.instagram.isNotEmpty) {
      socialLinks.add(basicInfoModelObj.value.instagram);
    }
    if (basicInfoModelObj.value.linkedin.isNotEmpty) {
      socialLinks.add(basicInfoModelObj.value.linkedin);
    }
    if (basicInfoModelObj.value.twitter.isNotEmpty) {
      socialLinks.add(basicInfoModelObj.value.twitter);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          compressFormat: ImageCompressFormat.png,
          compressQuality: 90,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: theme.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop Image',
              // aspectRatioPresets: [
              //   CropAspectRatioPreset.original,
              //   CropAspectRatioPreset.square,
              // ],
            ),
          ],
        );
        if (croppedFile != null) {
          imageFile.value = File(croppedFile.path);
        } else {
          Get.snackbar('Error', 'Image cropping was cancelled or failed');
        }
      } else {
        Get.snackbar('Error', 'Image picking was cancelled or failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while picking the image: $e');
    }
  }

  Future<void> saveProfileInfo() async {
    try {
      final data = {
        "firstName": textField1.text.split(' ').first.trim(),
        "lastName": textField1.text.split(' ').last.trim(),
        "displayName": textField2.text.trim(),
        "bio": textField3.text.trim(),
        "facebook": socialLinks.firstWhere(
            (link) => link.contains('facebook.com'),
            orElse: () => ''),
        "instagram": socialLinks.firstWhere(
            (link) => link.contains('instagram.com'),
            orElse: () => ''),
        "linkedin": socialLinks.firstWhere(
            (link) => link.contains('linkedin.com'),
            orElse: () => ''),
        "twitter": socialLinks.firstWhere(
            (link) => link.contains('twitter.com'),
            orElse: () => ''),
      };

      await apiService.postBasicInfo(data, imageFile.value);
      Get.snackbar('Success', 'Profile information saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile information: $e');
    }
  }

  @override
  void dispose() {
    textField1.dispose();
    textField2.dispose();
    textField3.dispose();
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    super.dispose();
  }
}
