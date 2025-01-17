// controllers/basic_profile_info_controller.dart

import 'dart:developer';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Basic_Info/models/basic_model.dart';
import 'package:intl/intl.dart';

class BasicProfileInfoController extends GetxController {
  final ApiService apiService = ApiService();
  RxBool isLoading = true.obs;
  Rx<BasicProfileInfoModel?> userProfile = Rx<BasicProfileInfoModel?>(null);

  TextEditingController fullNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  RxList<Map<String, String>> socialLinks = <Map<String, String>>[].obs;
  Rx<File?> imageFile = Rx<File?>(null);
  RxString profileImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchBasicInfo();
  }

  Future<void> fetchBasicInfo() async {
    isLoading.value = true;
    try {
      final response = await apiService.fetchBasicInfo();
      userProfile.value = response;
      if (userProfile.value != null) {
        updateTextFields();
        updateSocialLinks();
        profileImageUrl.value = userProfile.value?.data.profilePic ?? '';
      }
    } catch (e) {
      log("Error fetching basic info: $e");
      Get.snackbar('Error', 'Failed to load basic info: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void updateTextFields() {
    try {
      final data = userProfile.value?.data;
      if (data != null) {
        fullNameController.text = '${data.firstName} ${data.lastName}'.trim();
        displayNameController.text = data.displayName;
        bioController.text = data.bio;
        dateOfBirthController.text =
            DateFormat('dd/MM/yyyy').format(data.dateOfBirth);
        genderController.text = data.gender;
      }
    } catch (e) {
      log("Error updating text fields: $e");
    }
  }

  void updateSocialLinks() {
    try {
      socialLinks.clear();
      final data = userProfile.value?.data;
      if (data != null) {
        socialLinks.addAll(data.socialLinks.map((link) {
          String platformName = link.name;

          // Transform platform name
          if (platformName.toLowerCase() == 'twitter') {
            platformName = 'Twitter (now X)';
          } else {
            platformName = platformName
                .split(' ')
                .map((word) => word.isEmpty
                    ? ''
                    : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
                .join(' ');
          }

          return {
            'platform': platformName,
            'link': link.link,
          };
        }));
      }
    } catch (e) {
      log("Error updating social links: $e");
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
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedFile != null) {
          imageFile.value = File(croppedFile.path);
        }
      }
    } catch (e) {
      log("Image picking/cropping error: $e");
      Get.snackbar('Error', 'Failed to process image: ${e.toString()}');
    }
  }

  final Logger _logger = Logger();

  Future<void> saveProfileInfo() async {
    try {
      final names = fullNameController.text.split(' ');
      final data = {
        "firstName": names.first.trim(),
        "lastName": names.length > 1 ? names.last.trim() : "",
        "displayName": displayNameController.text.trim(),
        "bio": bioController.text.trim(),
        "dateOfBirth": DateFormat('yyyy-MM-dd').format(
            DateFormat('dd/MM/yyyy').parse(dateOfBirthController.text.trim())),
        "gender": genderController.text.toLowerCase().trim(),
        "socialLinks": socialLinks
            .map((link) => {
                  "name": link['platform']
                      ?.toLowerCase()
                      .replaceAll(' (now x)', ''),
                  "link": link['link'],
                })
            .toList(),
      };

      _logger.i('Sending Profile Info: $data');

      await apiService.postBasicInfo(data, imageFile.value);

      Get.back();
      Get.snackbar('Success', 'Profile information saved successfully');
    } catch (e, stacktrace) {
      _logger.e('Exception occurred: $e');
      Get.snackbar(
          'Error', 'Failed to save profile information: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    displayNameController.dispose();
    bioController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    super.dispose();
  }
}
