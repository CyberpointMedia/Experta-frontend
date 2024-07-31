import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/userProfile/models/profile_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailsController extends GetxController {
  var userData = ProfileModel().obs;
  var usersByIndustry = <String, List<User>>{}.obs;
  var isLoading = true.obs;
  
  final String? address = PrefUtils().getaddress();

  void fetchUserData(String userId) async {
    try {
      isLoading(true);
      var data =
          await ApiService().getUserData(userId, address.toString());
      userData.value = ProfileModel.fromJson(data);
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }

  void followUser(String followedByUserId) async {
    try {
      bool success = await ApiService().followUser(followedByUserId);
      if (success) {
        Fluttertoast.showToast(
          msg: "User followed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to follow user",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
