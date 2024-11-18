import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_experties/edit_experties.dart';
import 'package:experta/presentation/professional_info/expertise.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:page_transition/page_transition.dart';

class EditProfessionalInfoController extends GetxController {
  Rx<EditProfessionalInfoModel> professionalInfoModelObj =
      EditProfessionalInfoModel().obs;
  final List<TextEditingController> _linkControllers = [
    TextEditingController()
  ];
  Rx<String> selectedOption = 'regNumber'.obs;
  TextEditingController regNumberController = TextEditingController();
  PlatformFile? pickedFile;
  RxDouble uploadProgress = 0.0.obs;
  ApiService apiService = ApiService();
  var educationList = <Education>[].obs;
  RxList<Expertise> expertiseList = <Expertise>[].obs;
  RxList<WorkExperience> workExperienceList = <WorkExperience>[].obs;
  RxBool isLoading = true.obs;
  var industries = <Industry>[].obs;
  var occupations = <Occupation>[].obs;
  var selectedIndustry = Rx<SelectionPopupModel?>(null);
  var selectedOccupation = Rx<SelectionPopupModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  void onResume() {
    fetchData();
  }

  void fetchData() {
    fetchIndustries();
    fetchExpertise();
    fetchWorkExperience();
    fetchEducation();
  }

  @override
  void dispose() {
    for (var controller in _linkControllers) {
      controller.clear();
    }
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchProfessionalInfo() {
    return apiService.fetchProfessionalInfo();
  }

  Future<void> fetchIndustries() async {
    isLoading.value = true;
    try {
      final response = await apiService.fetchIndustries();
      industries.assignAll(response.map((e) => Industry.fromJson(e)).toList());
    } catch (e) {
      log("Error fetching industries: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOccupations(String industryId) async {
    isLoading.value = true;
    try {
      final response = await apiService.fetchOccupations(industryId);
      occupations
          .assignAll(response.map((e) => Occupation.fromJson(e)).toList());
    } catch (e) {
      log("Error fetching occupations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onIndustryChanged(String industryId) {
    selectedOccupation.value = null;
    fetchOccupations(industryId);
  }

  Future<void> fetchExpertise() async {
    _setLoading(true);
    try {
      final expertise = await apiService.fetchExpertise();
      expertiseList.value = expertise;
    } catch (e) {
      log("Error fetching expertise: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchWorkExperience() async {
    _setLoading(true);
    try {
      final workExperience = await apiService.fetchWorkExperience();
      workExperienceList.value = workExperience;
    } catch (e) {
      log("Error fetching work experience: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchEducation() async {
    _setLoading(true);
    try {
      final educationData = await apiService.fetchEducation();
      educationList.value = educationData;
    } catch (e) {
      log('Error fetching education data: $e');
    } finally {
      _setLoading(false);
    }
  }

  List<ExpertiseItem> convertToExpertiseItemList(
      List<Expertise> expertiseList) {
    return expertiseList
        .map((e) => ExpertiseItem(id: e.id, name: e.name))
        .toList();
  }

  List<Expertise> convertToExpertiseList(
      List<ExpertiseItem> expertiseItemList) {
    return expertiseItemList
        .map((e) => Expertise(
            id: e.id,
            name: e.name,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()))
        .toList();
  }

  Future<void> editExpertise(BuildContext context) async {
    final result = await Navigator.pushReplacement(
      context,
      PageTransition(
        child: EditExpertisePage(
            selectedItems: convertToExpertiseItemList(expertiseList.toList())),
        type: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      ),
      // PageTransition(
      //   child: ExpertiseView(
      //       selectedItems: convertToExpertiseItemList(expertiseList.toList())),
      //   type: PageTransitionType.leftToRight,
      //   duration: const Duration(milliseconds: 300),
      //   reverseDuration: const Duration(milliseconds: 300),
      // ),
    );

    if (result != null) {
      fetchData();
    }
  }

  void _setLoading(bool value) {
    isLoading.value = value;
  }

  List<SelectionPopupModel> get industryDropdownItems {
    return industries.map((industry) {
      return SelectionPopupModel(id: industry.id, title: industry.name);
    }).toList();
  }

  List<SelectionPopupModel> get occupationDropdownItems {
    return occupations.map((occupation) {
      return SelectionPopupModel(id: occupation.id, title: occupation.name);
    }).toList();
  }

  void addNewLinkField() {
    if (_linkControllers.isNotEmpty) {
      final lastController = _linkControllers.last;
      if (lastController.text.isEmpty) {
        Get.snackbar(
            'Error', 'Please fill the previous link before adding a new one');
        return;
      } else if (!isValidUrl(lastController.text)) {
        Get.snackbar('Error', 'Please enter a valid URL');
        return;
      }
    }

    _linkControllers.add(TextEditingController());
    update();
  }

  bool isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  List<TextEditingController> get linkControllers => _linkControllers;

  void addLinkController() {
    _linkControllers.add(TextEditingController());
    update();
  }

  void removeLinkController(int index) {
    if (index >= 0 && index < _linkControllers.length) {
      _linkControllers.removeAt(index).dispose();
      update();
    }
  }

  Future<void> saveProfessionalInfo() async {
    _setLoading(true);
    try {
      final achievements =
          _linkControllers.map((controller) => controller.text).toList();

      final data = {
        "industry": selectedIndustry.value?.id,
        "occupation": selectedOccupation.value?.id,
        "registrationNumber": regNumberController.text,
        "certificate": pickedFile?.path ?? "",
        "achievements": achievements,
        "expertise": expertiseList.map((e) => e.id).toList(),
      };

      await apiService.createIndustryInfo(data);
      Get.snackbar('Success', 'Professional info saved successfully');
    } catch (e) {
      log("Error saving professional info: $e");
      Get.snackbar('Error', 'Failed to save professional info');
    } finally {
      _setLoading(false);
    }
  }
}
