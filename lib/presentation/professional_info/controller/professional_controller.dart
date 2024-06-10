import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditProfessionalInfoController extends GetxController {
  Rx<EditProfessionalInfoModel> professionalInfoModelObj =
      EditProfessionalInfoModel().obs;
  Rx<String> selectedOption = 'regNumber'.obs;
  TextEditingController regNumberController = TextEditingController();
  PlatformFile? pickedFile;
  RxDouble uploadProgress = 0.0.obs;
  ApiService apiService = ApiService();
  var educationList = <Education>[].obs;
  RxList<Expertise> expertiseList = <Expertise>[].obs;
  RxList<WorkExperience> workExperienceList = <WorkExperience>[].obs;
  RxBool isLoading = true.obs;
  var selectedIndustry = ''.obs;
  var selectedOccupation = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchExpertise();
    fetchWorkExperience();
    fetchEducation();
  }

  Future<void> fetchExpertise() async {
    try {
      final expertise = await apiService.fetchExpertise();
      expertiseList.value = expertise;
    } catch (e) {
      // Handle error
      log("$e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWorkExperience() async {
    try {
      final workExperience = await apiService.fetchWorkExperience();
      workExperienceList.value = workExperience;
    } catch (e) {
      // Handle error
      log("$e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchEducation() async {
    try {
      isLoading(true);
      var educationData = await apiService.fetchEducation();
      educationList.value = educationData;
    } catch (e) {
      // Handle error
      print('Error fetching education data: $e');
    } finally {
      isLoading(false);
    }
  }
}
