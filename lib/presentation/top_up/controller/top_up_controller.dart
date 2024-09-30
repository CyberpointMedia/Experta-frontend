import 'package:experta/presentation/top_up/model/top_up_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TopUpController extends GetxController{

  Rx<TopUpModel> acountSettingModelObject = TopUpModel().obs;
}