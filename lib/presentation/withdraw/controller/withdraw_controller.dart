import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/withdraw/model/withdraw_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WithdrawController extends GetxController{

  Rx<WithdrawModel> acountSettingModelObject = WithdrawModel().obs;
}