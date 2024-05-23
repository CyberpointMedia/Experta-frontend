import 'package:get/get.dart';
import 'category_screen.dart';

/// This class defines the variables used in the [category_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class CategoryModel {}

/// A controller class for the CategoryScreen.
///
/// This class manages the state of the CategoryScreen, including the
/// current categoryModelObj
class CategoryController extends GetxController {
  Rx<CategoryModel> categoryModelObj = CategoryModel().obs;
}

/// A binding class for the CategoryScreen.
///
/// This class ensures that the CategoryController is created when the
/// CategoryScreen is first loaded.
class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController());
  }
}
