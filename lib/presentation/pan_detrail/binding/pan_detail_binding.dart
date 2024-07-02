import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/pan_detrail/controller/pan_detail_controller.dart';

class PanDetailBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => PanDetailController());
  }
  
}
