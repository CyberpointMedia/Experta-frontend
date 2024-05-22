import 'package:experta/presentation/dashboard/models/dashboard_model.dart';

import '../../../core/app_export.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  TextEditingController dashboardController = TextEditingController();

  Rx<DashboardModel> dashboardModelObj = DashboardModel().obs;

  @override
  void onClose() {
    super.onClose();
    dashboardController.dispose();
  }
}
