import 'package:experta/presentation/search_block/controller/search_block_controller.dart';
import 'package:get/get.dart';


class BlockSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockSearchController>(() => BlockSearchController());
  }
}