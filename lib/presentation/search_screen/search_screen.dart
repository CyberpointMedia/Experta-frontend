import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/home_screen.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_four.dart';
import 'package:experta/widgets/app_bar/appbar_title_searchview.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_bottom_bar.dart';
import 'package:experta/widgets/custom_search_view.dart';

import 'widgets/search_item_widget.dart';
import 'models/search_item_model.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'controller/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchController controller = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 60,
                sigmaY: 60,
              ),
              child: Align(
                child: SizedBox(
                  width: 252,
                  height: 252,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(126),
                      color: appTheme.deepOrangeA20.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 25),
                child: Row(
                  children: [
                    CustomSearchView(
                      width: 279.h,
                      controller: controller.searchController,
                      hintText: "lbl_influencer".tr,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.h),
                      child: Text(
                        "lbl_cancel".tr,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: appTheme.gray900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 16.h, top: 29.v),
                          child: Text("lbl_recommended".tr,
                              style: CustomTextStyles.titleMediumBold)),
                      _buildSearch()
                    ]),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
        height: 152.v,
        title: AppbarTitleSearchview(
            margin: EdgeInsets.only(left: 16.h),
            hintText: "lbl_influencer".tr,
            controller: controller.searchController),
        actions: [
          AppbarSubtitleFour(
              text: "lbl_cancel".tr,
              margin: EdgeInsets.fromLTRB(15.h, 16.v, 16.h, 15.v),
              onTap: () {
                // onTapCancel();
              })
        ]);
  }

  /// Section Widget
  Widget _buildSearch() {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Obx(() => ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 1.v);
                },
                itemCount:
                    controller.searchModelObj.value.searchItemList.value.length,
                itemBuilder: (context, index) {
                  SearchItemModel model = controller
                      .searchModelObj.value.searchItemList.value[index];
                  return SearchItemWidget(model);
                }))));
  }
}
