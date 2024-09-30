import 'dart:developer';
import 'dart:io';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Basic_Info/models/basic_model.dart';

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
  TextEditingController textField4 = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  FocusNode focus4 = FocusNode();

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
      basicInfoModelObj.value = BasicProfileInfoModel.fromJson(basicInfoJson);
      updateTextFields();
      updateSocialLinks();
      profileImageUrl.value = basicInfoModelObj.value.profilePic;
    } catch (e) {
      log("the error log is $e");
      Get.snackbar('Error', 'Failed to load basic info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateTextFields() {
    textField1.text =
        '${basicInfoModelObj.value.firstName} ${basicInfoModelObj.value.lastName}'
            .trim();
    textField2.text = basicInfoModelObj.value.displayName;
    textField3.text = basicInfoModelObj.value.bio;
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
        // Log the picked file path
        log("Picked file path: ${pickedFile.path}");

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
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );
        if (croppedFile != null) {
          // Log the cropped file path
          log("Cropped file path: ${croppedFile.path}");

          imageFile.value = File(croppedFile.path);
        } else {
          Get.snackbar('Error', 'Image cropping was cancelled or failed');
        }
      } else {
        Get.snackbar('Error', 'Image picking was cancelled or failed');
      }
    } catch (e) {
      log("Image picking/cropping error: $e");
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
        "Social Links": textField4.text.trim(),
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

      Get.back();
      Get.snackbar('Success', 'Profile information saved successfully');

      // Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile information: $e');
    }
  }

  @override
  void dispose() {
    textField1.clear();
    textField2.clear();
    textField3.clear();
    textField4.clear();
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    super.dispose();
  }
}
