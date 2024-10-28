import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;
  final ImagePicker pickerp = ImagePicker();

  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  /// Save token to SharedPreferences
  Future<void> setToken(String token) async {
    await _sharedPreferences!.setString('token', token);
  }

  /// Retrieve token from SharedPreferences
  String? getToken() {
    return _sharedPreferences!.getString('token');
  }

  /// Remove token from SharedPreferences
  Future<void> removeToken() async {
    await _sharedPreferences!.remove('token');
  }

  /// Clear all data stored in SharedPreferences
  Future<void> clearPreferencesData() async {
    await _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  /// Save image to SharedPreferences
  Future<void> setProfileImage(String imagePath) async {
    await _sharedPreferences!.setString('img', imagePath);
  }

  /// Retrieve image from SharedPreferences
  String? getProfileImage() {
    return _sharedPreferences!.getString('img');
  }

  /// Remove image from SharedPreferences
  Future<void> removeProfileImage() async {
    await _sharedPreferences!.remove('img');
  }

  /// Save name to SharedPreferences
  Future<void> setProfileName(String name) async {
    await _sharedPreferences!.setString('name', name);
  }

  /// Retrieve name from SharedPreferences
  String? getProfileName() {
    return _sharedPreferences!.getString('name');
  }

  /// Remove name from SharedPreferences
  Future<void> removeProfileName() async {
    await _sharedPreferences!.remove('name');
  }

  /// Save address to SharedPreferences
  Future<void> setaddress(String address) async {
    await _sharedPreferences!.setString('address', address);
  }

  /// Retrieve address from SharedPreferences
  String? getaddress() {
    return _sharedPreferences!.getString('address');
  }

  /// Remove address from SharedPreferences
  Future<void> removeaddress() async {
    await _sharedPreferences!.remove('address');
  }

  /// Save address to SharedPreferences
  Future<void> setbasic(String basicInfo) async {
    await _sharedPreferences!.setString('basicInfo', basicInfo);
  }

  /// Retrieve address from SharedPreferences
  String? getbasic() {
    return _sharedPreferences!.getString('basicInfo');
  }

  /// Remove address from SharedPreferences
  Future<void> removebasic() async {
    await _sharedPreferences!.remove('basicInfo');
  }
}
