import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// This class defines the variables used in the [home_screen],
/// and is typically used to hold data that is passed between different parts of the application.

class HomeModel {
  Rx<List<ListactorsOneItemModel>> listactorsOneItemList = Rx([
    ListactorsOneItemModel(
        actorsone: "assets/images/img_celebrity_1.svg".obs,
        actorstwo: "Actors".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_running_shoe.svg".obs,
        actorstwo: "Athletes".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_theater_3.svg".obs,
        actorstwo: "Comedians".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_guitar.svg".obs,
        actorstwo: "Musicians".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_movie.svg".obs,
        actorstwo: "Creators".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_stethoscope_5.svg".obs,
        actorstwo: "Doctors".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_chef_hat_3.svg".obs,
        actorstwo: "Chef".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_graduate_hat.svg".obs,
        actorstwo: "Teachers".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_magic_cards.svg".obs,
        actorstwo: "Astrologer".obs),
    ListactorsOneItemModel(
        actorsone: "assets/images/img_american_football.svg".obs,
        actorstwo: "Sports".obs)
  ]);

  Rx<List<UserprofileItemModel>> userprofileItemList = Rx([
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Anjali Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_220x156.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Priya Sangar".obs,
        userRoleText: "Social Media Influencer".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_1.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.2".obs,
        usernameText: "Kamya Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.5".obs,
        usernameText: "Dolphy".obs,
        userRoleText: "Social Media Influencer".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_220x156.png".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_1.png".obs),
    UserprofileItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_2.png".obs)
  ]);

  Rx<List<Userprofile1ItemModel>> userprofile1ItemList = Rx([
    Userprofile1ItemModel(
        onlineImage: "assets/images/img_rectangle_2.png".obs,
        onlineText: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Anjali Arora".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile1ItemModel(onlineImage: "assets/images/img_rectangle_2.png".obs),
    Userprofile1ItemModel(onlineImage: "assets/images/img_rectangle_2.png".obs),
    Userprofile1ItemModel(
        onlineImage: "assets/images/img_rectangle_2_220x156.png".obs,
        onlineText: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Priya Sangar".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile1ItemModel(
        onlineImage: "assets/images/img_rectangle_2_1.png".obs,
        onlineText: "Online".obs,
        ratingText: "4.2".obs,
        usernameText: "Kamya Arora".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile1ItemModel(
        onlineImage: "assets/images/img_rectangle_2_2.png".obs,
        onlineText: "Online".obs,
        ratingText: "4.5".obs,
        usernameText: "Dolphy".obs,
        roleText: "Social Media Influencer".obs)
  ]);

  Rx<List<Userprofile2ItemModel>> userprofile2ItemList = Rx([
    Userprofile2ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Anjali Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile2ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    Userprofile2ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    Userprofile2ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_220x156.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Priya Sangar".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile2ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_1.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.2".obs,
        usernameText: "Kamya Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile2ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.5".obs,
        usernameText: "Dolphy".obs,
        userRoleText: "Social Media Influencer".obs)
  ]);

  Rx<List<Userprofile3ItemModel>> userprofile3ItemList = Rx([
    Userprofile3ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Anjali Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile3ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    Userprofile3ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    Userprofile3ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_220x156.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Priya Sangar".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile3ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_1.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.2".obs,
        usernameText: "Kamya Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile3ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.5".obs,
        usernameText: "Dolphy".obs,
        userRoleText: "Social Media Influencer".obs)
  ]);

  Rx<List<Userprofile4ItemModel>> userprofile4ItemList = Rx([
    Userprofile4ItemModel(
        onlineImage: "assets/images/img_rectangle_2.png".obs,
        onlineText: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Anjali Arora".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile4ItemModel(onlineImage: "assets/images/img_rectangle_2.png".obs),
    Userprofile4ItemModel(onlineImage: "assets/images/img_rectangle_2.png".obs),
    Userprofile4ItemModel(
        onlineImage: "assets/images/img_rectangle_2_220x156.png".obs,
        onlineText: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Priya Sangar".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile4ItemModel(
        onlineImage: "assets/images/img_rectangle_2_1.png".obs,
        onlineText: "Online".obs,
        ratingText: "4.2".obs,
        usernameText: "Kamya Arora".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile4ItemModel(
        onlineImage: "assets/images/img_rectangle_2_2.png".obs,
        onlineText: "Online".obs,
        ratingText: "4.5".obs,
        usernameText: "Dolphy".obs,
        roleText: "Social Media Influencer".obs)
  ]);

  Rx<List<Userprofile5ItemModel>> userprofile5ItemList = Rx([
    Userprofile5ItemModel(
        onlineImage: "assets/images/img_rectangle_2.png".obs,
        onlineText: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Anjali Arora".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile5ItemModel(onlineImage: "assets/images/img_rectangle_2.png".obs),
    Userprofile5ItemModel(onlineImage: "assets/images/img_rectangle_2.png".obs),
    Userprofile5ItemModel(
        onlineImage: "assets/images/img_rectangle_2_220x156.png".obs,
        onlineText: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Priya Sangar".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile5ItemModel(
        onlineImage: "assets/images/img_rectangle_2_1.png".obs,
        onlineText: "Online".obs,
        ratingText: "4.2".obs,
        usernameText: "Kamya Arora".obs,
        roleText: "Social Media Influencer".obs),
    Userprofile5ItemModel(
        onlineImage: "assets/images/img_rectangle_2_2.png".obs,
        onlineText: "Online".obs,
        ratingText: "4.5".obs,
        usernameText: "Dolphy".obs,
        roleText: "Social Media Influencer".obs)
  ]);

  Rx<List<Userprofile6ItemModel>> userprofile6ItemList = Rx([
    Userprofile6ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Anjali Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile6ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    Userprofile6ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2.png".obs),
    Userprofile6ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_220x156.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "5.0".obs,
        usernameText: "Priya Sangar".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile6ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_1.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.2".obs,
        usernameText: "Kamya Arora".obs,
        userRoleText: "Social Media Influencer".obs),
    Userprofile6ItemModel(
        onlineStatusIma: "assets/images/img_rectangle_2_2.png".obs,
        onlineStatusTex: "Online".obs,
        ratingText: "4.5".obs,
        usernameText: "Dolphy".obs,
        userRoleText: "Social Media Influencer".obs)
  ]);
}

/// This class is used in the [listactors_one_item_widget] screen.

class ListactorsOneItemModel {
  ListactorsOneItemModel({this.actorsone, this.actorstwo, this.id}) {
    actorsone = actorsone ?? Rx("assets/images/img_celebrity_1.svg");
    actorstwo = actorstwo ?? Rx("Actors");
    id = id ?? Rx("");
  }

  Rx<String>? actorsone;

  Rx<String>? actorstwo;

  Rx<String>? id;
}

/// This class is used in the [userprofile1_item_widget] screen.

class Userprofile1ItemModel {
  Userprofile1ItemModel(
      {this.onlineImage,
      this.onlineText,
      this.ratingText,
      this.usernameText,
      this.roleText,
      this.id}) {
    onlineImage = onlineImage ?? Rx("assets/images/img_rectangle_2.png");
    onlineText = onlineText ?? Rx("Online");
    ratingText = ratingText ?? Rx("5.0");
    usernameText = usernameText ?? Rx("Anjali Arora");
    roleText = roleText ?? Rx("Social Media Influencer");
    id = id ?? Rx("");
  }

  Rx<String>? onlineImage;

  Rx<String>? onlineText;

  Rx<String>? ratingText;

  Rx<String>? usernameText;

  Rx<String>? roleText;

  Rx<String>? id;
}

/// This class is used in the [userprofile2_item_widget] screen.

class Userprofile2ItemModel {
  Userprofile2ItemModel(
      {this.onlineStatusIma,
      this.onlineStatusTex,
      this.ratingText,
      this.usernameText,
      this.userRoleText,
      this.id}) {
    onlineStatusIma =
        onlineStatusIma ?? Rx("assets/images/img_rectangle_2.png");
    onlineStatusTex = onlineStatusTex ?? Rx("Online");
    ratingText = ratingText ?? Rx("5.0");
    usernameText = usernameText ?? Rx("Anjali Arora");
    userRoleText = userRoleText ?? Rx("Social Media Influencer");
    id = id ?? Rx("");
  }

  Rx<String>? onlineStatusIma;

  Rx<String>? onlineStatusTex;

  Rx<String>? ratingText;

  Rx<String>? usernameText;

  Rx<String>? userRoleText;

  Rx<String>? id;
}

/// This class is used in the [userprofile3_item_widget] screen.

class Userprofile3ItemModel {
  Userprofile3ItemModel(
      {this.onlineStatusIma,
      this.onlineStatusTex,
      this.ratingText,
      this.usernameText,
      this.userRoleText,
      this.id}) {
    onlineStatusIma =
        onlineStatusIma ?? Rx("assets/images/img_rectangle_2.png");
    onlineStatusTex = onlineStatusTex ?? Rx("Online");
    ratingText = ratingText ?? Rx("5.0");
    usernameText = usernameText ?? Rx("Anjali Arora");
    userRoleText = userRoleText ?? Rx("Social Media Influencer");
    id = id ?? Rx("");
  }

  Rx<String>? onlineStatusIma;

  Rx<String>? onlineStatusTex;

  Rx<String>? ratingText;

  Rx<String>? usernameText;

  Rx<String>? userRoleText;

  Rx<String>? id;
}

/// This class is used in the [userprofile4_item_widget] screen.

class Userprofile4ItemModel {
  Userprofile4ItemModel(
      {this.onlineImage,
      this.onlineText,
      this.ratingText,
      this.usernameText,
      this.roleText,
      this.id}) {
    onlineImage = onlineImage ?? Rx("assets/images/img_rectangle_2.png");
    onlineText = onlineText ?? Rx("Online");
    ratingText = ratingText ?? Rx("5.0");
    usernameText = usernameText ?? Rx("Anjali Arora");
    roleText = roleText ?? Rx("Social Media Influencer");
    id = id ?? Rx("");
  }

  Rx<String>? onlineImage;

  Rx<String>? onlineText;

  Rx<String>? ratingText;

  Rx<String>? usernameText;

  Rx<String>? roleText;

  Rx<String>? id;
}

/// This class is used in the [userprofile5_item_widget] screen.

class Userprofile5ItemModel {
  Userprofile5ItemModel(
      {this.onlineImage,
      this.onlineText,
      this.ratingText,
      this.usernameText,
      this.roleText,
      this.id}) {
    onlineImage = onlineImage ?? Rx("assets/images/img_rectangle_2.png");
    onlineText = onlineText ?? Rx("Online");
    ratingText = ratingText ?? Rx("5.0");
    usernameText = usernameText ?? Rx("Anjali Arora");
    roleText = roleText ?? Rx("Social Media Influencer");
    id = id ?? Rx("");
  }

  Rx<String>? onlineImage;

  Rx<String>? onlineText;

  Rx<String>? ratingText;

  Rx<String>? usernameText;

  Rx<String>? roleText;

  Rx<String>? id;
}

/// This class is used in the [userprofile6_item_widget] screen.

class Userprofile6ItemModel {
  Userprofile6ItemModel(
      {this.onlineStatusIma,
      this.onlineStatusTex,
      this.ratingText,
      this.usernameText,
      this.userRoleText,
      this.id}) {
    onlineStatusIma =
        onlineStatusIma ?? Rx("assets/images/img_rectangle_2.png");
    onlineStatusTex = onlineStatusTex ?? Rx("Online");
    ratingText = ratingText ?? Rx("5.0");
    usernameText = usernameText ?? Rx("Anjali Arora");
    userRoleText = userRoleText ?? Rx("Social Media Influencer");
    id = id ?? Rx("");
  }

  Rx<String>? onlineStatusIma;

  Rx<String>? onlineStatusTex;

  Rx<String>? ratingText;

  Rx<String>? usernameText;

  Rx<String>? userRoleText;

  Rx<String>? id;
}

/// This class is used in the [userprofile_item_widget] screen.

class UserprofileItemModel {
  UserprofileItemModel(
      {this.onlineStatusIma,
      this.onlineStatusTex,
      this.ratingText,
      this.usernameText,
      this.userRoleText,
      this.id}) {
    onlineStatusIma =
        onlineStatusIma ?? Rx("assets/images/img_rectangle_2.png");
    onlineStatusTex = onlineStatusTex ?? Rx("Online");
    ratingText = ratingText ?? Rx("5.0");
    usernameText = usernameText ?? Rx("Anjali Arora");
    userRoleText = userRoleText ?? Rx("Social Media Influencer");
    id = id ?? Rx("");
  }

  Rx<String>? onlineStatusIma;

  Rx<String>? onlineStatusTex;

  Rx<String>? ratingText;

  Rx<String>? usernameText;

  Rx<String>? userRoleText;

  Rx<String>? id;
}

/// A controller class for the HomeScreen.
///
/// This class manages the state of the HomeScreen, including the
/// current homeModelObj
class HomeController extends GetxController {
  TextEditingController searchController = TextEditingController();

  Rx<HomeModel> homeModelObj = HomeModel().obs;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}

/// A binding class for the HomeScreen.
///
/// This class ensures that the HomeController is created when the
/// HomeScreen is first loaded.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
