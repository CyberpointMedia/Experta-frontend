import 'dart:developer';
import 'dart:io';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Basic_Info/models/basic_model.dart';
import 'package:intl/intl.dart';

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
    dateOfBirth: '',
    gender: '',
  ).obs;
  TextEditingController textField1 = TextEditingController();
  TextEditingController textField2 = TextEditingController();
  TextEditingController textField3 = TextEditingController();
  TextEditingController textField4 = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController genderController = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  FocusNode focus4 = FocusNode();

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
    log(basicInfoModelObj.value.gender);
    textField1.text =
        '${basicInfoModelObj.value.firstName} ${basicInfoModelObj.value.lastName}'
            .trim();
    textField2.text = basicInfoModelObj.value.displayName;
    textField3.text = basicInfoModelObj.value.bio;
    log(basicInfoModelObj.value.dateOfBirth);
    DateTime parsedDate = DateTime.parse(basicInfoModelObj.value.dateOfBirth);
    dateOfBirth.text =
        "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year.toString()}";

    log("Received gender: ${basicInfoModelObj.value.gender}");
    genderController.text = basicInfoModelObj.value.gender;
  }

  void updateSocialLinks() {
    socialLinks.clear();
    if (basicInfoModelObj.value.facebook.isNotEmpty) {
      socialLinks.add(
          {'platform': 'Facebook', 'link': basicInfoModelObj.value.facebook});
    }
    if (basicInfoModelObj.value.instagram.isNotEmpty) {
      socialLinks.add(
          {'platform': 'Instagram', 'link': basicInfoModelObj.value.instagram});
    }
    if (basicInfoModelObj.value.linkedin.isNotEmpty) {
      socialLinks.add(
          {'platform': 'LinkedIn', 'link': basicInfoModelObj.value.linkedin});
    }
    if (basicInfoModelObj.value.twitter.isNotEmpty) {
      socialLinks.add({
        'platform': 'Twitter (now X)',
        'link': basicInfoModelObj.value.twitter
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
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
      String formatDate(String date) {
        try {
          final originalFormat = RegExp(r'^\d{4}-\d{2}-\d{2}$');
          if (originalFormat.hasMatch(date)) {
            return date;
          }
          DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
          return DateFormat('yyyy-MM-dd').format(parsedDate);
        } catch (e) {
          log("date parsing failed");
          return date;
        }
      }

      // Create a map to store all social links
      Map<String, String> socialLinksMap = {};

      // Extract specific platform links for the API
      String facebook = '';
      String instagram = '';
      String linkedin = '';
      String twitter = '';

      // Process each social link
      for (var link in socialLinks) {
        String platform = link['platform'] ?? '';
        String url = link['link'] ?? '';

        // Map to specific platform variables for API compatibility
        switch (platform) {
          case 'Facebook':
            facebook = url;
            break;
          case 'Instagram':
            instagram = url;
            break;
          case 'LinkedIn':
            linkedin = url;
            break;
          case 'Twitter (now X)':
            twitter = url;
            break;
          default:
            // Store other platforms in the general map
            socialLinksMap[platform] = url;
        }
      }

      final data = {
        "firstName": textField1.text.split(' ').first.trim(),
        "lastName": textField1.text.split(' ').last.trim(),
        "displayName": textField2.text.trim(),
        "bio": textField3.text.trim(),
        "facebook": facebook,
        "instagram": instagram,
        "linkedin": linkedin,
        "twitter": twitter,
        "socialLinks": socialLinksMap, 
        "dateOfBirth": formatDate(dateOfBirth.text.trim()),
        "gender": genderController.text.toLowerCase().trim(),
      };

      await apiService.postBasicInfo(data, imageFile.value);

      Get.back();
      Get.snackbar('Success', 'Profile information saved successfully');
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
    genderController.clear();
    dateOfBirth.clear();
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    super.dispose();
  }
}
