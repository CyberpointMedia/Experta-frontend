import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:experta/core/app_export.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    this.onChanged,
  });

  final int selectedIndex;
  final Function(BottomBarEnum)? onChanged;

  @override
  Widget build(BuildContext context) {
    List<BottomMenuModel> bottomMenuList = [
      BottomMenuModel(
        icon: ImageConstant.imgNavHome,
        activeIcon: ImageConstant.imgNavHome,
        title: "lbl_home".tr,
        type: BottomBarEnum.Home,
      ),
      BottomMenuModel(
        icon: ImageConstant.imgSearchBlueGray300,
        activeIcon: ImageConstant.imgSearchBlueGray300,
        title: "lbl_search".tr,
        type: BottomBarEnum.Search,
      ),
      BottomMenuModel(
        icon: ImageConstant.imgNavMessage,
        activeIcon: ImageConstant.imgNavMessage,
        title: "lbl_message".tr,
        type: BottomBarEnum.Message,
      ),
      BottomMenuModel(
        icon: ImageConstant.imgNavFeeds,
        activeIcon: ImageConstant.imgNavFeeds,
        title: "lbl_feeds".tr,
        type: BottomBarEnum.Feeds,
      ),
      BottomMenuModel(
        icon: ImageConstant.imgNavProfile,
        activeIcon: ImageConstant.imgNavProfile,
        title: "lbl_profile".tr,
        type: BottomBarEnum.Profile,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: double.maxFinite,
          child: Divider(),
        ),
        Container(
          decoration: const BoxDecoration(),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            elevation: 0,
            currentIndex: selectedIndex,
            type: BottomNavigationBarType.fixed,
            items: List.generate(bottomMenuList.length, (index) {
              return BottomNavigationBarItem(
                icon: Container(
                  width: double.infinity,
                  decoration: AppDecoration.fillOnPrimaryContainer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: bottomMenuList[index].icon,
                        color: appTheme.blueGray300,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 2.v,
                          bottom: 3.v,
                        ),
                        child: Text(
                          bottomMenuList[index].title ?? "",
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: appTheme.blueGray300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                activeIcon: Container(
                  width: double.infinity,
                  decoration: AppDecoration.fillOnPrimaryContainer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: bottomMenuList[index].activeIcon,
                        color: appTheme.gray900,
                      ),
                      Text(
                        bottomMenuList[index].title ?? "",
                        style: CustomTextStyles.labelMediumGray900.copyWith(
                          color: appTheme.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              );
            }),
            onTap: (index) {
              onChanged?.call(bottomMenuList[index].type);
            },
          ),
        ),
      ],
    );
  }
}

enum BottomBarEnum {
  Home,
  Search,
  Message,
  Feeds,
  Profile,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;
}
