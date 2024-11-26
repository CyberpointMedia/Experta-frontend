import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/controller/add_upi_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class AddUpi extends StatefulWidget {
  const AddUpi({super.key});

  @override
  State<AddUpi> createState() => _AddUpiState();
}

class _AddUpiState extends State<AddUpi> {
  final _formKey = GlobalKey<FormState>();
  AddUpiController controller = Get.put(AddUpiController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Positioned(
              left: 270.adaptSize,
              top: 50.adaptSize,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal,
                  sigmaX: 60,
                  sigmaY: 60,
                ),
                child: Align(
                  child: SizedBox(
                    width: 252.adaptSize,
                    height: 252.adaptSize,
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
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UPI ID",
                      style: theme.textTheme.titleMedium!.copyWith(
                          color: appTheme.blueGray300,
                          fontSize: 14.adaptSize,
                          fontWeight: FontWeight.w400),
                    ),
                    CustomTextFormField(
                      hintText: "Enter your UPI ID",
                      hintStyle: theme.textTheme.titleSmall!.copyWith(
                          color: appTheme.blueGray300,
                          fontSize: 14.adaptSize,
                          fontWeight: FontWeight.w500),
                      textInputType: TextInputType.name,
                      controller: controller.upiController,
                      focusNode: controller.focus1,
                      autofocus: false,
                      validator: controller.validateUpiId,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 15),
                      child: Text(
                        "Example: username@bankname",
                        maxLines: 1,
                      ),
                    ),
                    const Spacer(),
                    Obx(() => CustomElevatedButton(
                          text:
                              controller.isLoading.value ? "Saving..." : "Save",
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.saveUpiId(context);
                                  }
                                },
                          margin: const EdgeInsets.all(10),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
        height: 40.h,
        leadingWidth: 40.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
            margin: EdgeInsets.only(left: 16.h),
            onTap: () {
              onTapArrowLeft();
            }),
        centerTitle: true,
        title: AppbarSubtitleSix(text: "Add UPI"));
  }

  onTapArrowLeft() {
    Get.back();
  }
}
