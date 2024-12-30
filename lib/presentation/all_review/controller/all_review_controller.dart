import 'package:experta/presentation/all_review/model/all_review_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AllReviewController extends GetxController{

  Rx<AllReviewModel> acountSettingModelObject = AllReviewModel().obs;
}