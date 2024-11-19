import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class UpiDetails extends StatefulWidget {
  const UpiDetails({super.key});

  @override
  State<UpiDetails> createState() => _UpiDetailsState();
}

class _UpiDetailsState extends State<UpiDetails> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? upiDetails;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUpiDetails();
  }

  Future<void> fetchUpiDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final details = await _apiService.getUpiDetails();
      setState(() {
        upiDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load UPI details';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load UPI details')),
      );
    }
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "UPI ID",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              hintText: "Upi Id",
              readOnly: true,
              hintStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
              textInputType: TextInputType.number,
              autofocus: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
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
          isLoading
              ? _buildShimmerLoading()
              : error != null
                  ? Center(child: Text(error!))
                  : Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UPI ID",
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          CustomTextFormField(
                            initialValue: upiDetails?['upiId'] ?? '',
                            readOnly: true,
                            hintStyle: theme.textTheme.titleSmall!
                                .copyWith(fontSize: 14),
                            textInputType: TextInputType.number,
                            autofocus: false,
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "UPI Details"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
