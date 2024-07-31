
import '../../../core/app_export.dart';
import '../models/search_model.dart';

/// A controller class for the SearchScreen.
///
/// This class manages the state of the SearchScreen, including the
/// current searchModelObj.
class SearchPageController extends GetxController {
  // ignore: non_constant_identifier_names
  TextEditingController searchPageControllers = TextEditingController();

  Rx<SearchModel> searchModelObj = SearchModel().obs;

  @override
  void onClose() {
    super.onClose();
    searchPageControllers.dispose();
  }
}
