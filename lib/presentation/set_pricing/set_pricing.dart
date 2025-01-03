import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_pricing/controller/set_pricing_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class SetPricing extends StatefulWidget {
  const SetPricing({super.key});

  @override
  State<SetPricing> createState() => _SetPricingState();
}

class _SetPricingState extends State<SetPricing> {
  SetPricingController controller = Get.put(SetPricingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              _buildFormData(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                child: CustomElevatedButton(
                  text: "Save",
                  onPressed: () {
                    controller.savePricing();
                  },
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.loading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlur() {
    return Positioned(
      left: 270,
      top: 50,
      child: ImageFiltered(
        imageFilter:
            ImageFilter.blur(tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Set Pricing"),
    );
  }

  Widget _buildFormData() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 15.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: CustomTextStyles.bodySmallSFProTextGray900,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Audio Call ',
                      style: CustomTextStyles.bodySmallSFProTextGray900
                          .copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    TextSpan(
                      text: '(For 1 minute) ',
                      style: CustomTextStyles.bodySmallSFProTextGray900
                          .copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    TextSpan(
                      text: '*',
                      style: CustomTextStyles.labelMediumGray900
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
              )),
          CustomTextFormField(
            prefix: const Icon(Icons.currency_rupee),
            width: MediaQuery.of(context).size.width,
            controller: controller.textField1,
            focusNode: controller.focus1,
            hintText: "Enter your price".tr,
            hintStyle: CustomTextStyles.titleMediumBluegray300,
            textInputType: TextInputType.number, inputFormatters: [],
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 6),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: CustomTextStyles.bodySmallSFProTextGray900,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Video Call ',
                      style: CustomTextStyles.bodySmallSFProTextGray900
                          .copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    TextSpan(
                      text: '(For 1 minute) ',
                      style: CustomTextStyles.bodySmallSFProTextGray900
                          .copyWith(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    TextSpan(
                      text: '*',
                      style: CustomTextStyles.labelMediumGray900
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
              )),
          CustomTextFormField(
            prefix: const Icon(Icons.currency_rupee),
            width: MediaQuery.of(context).size.width,
            controller: controller.textField2,
            focusNode: controller.focus2,
            hintText: " Enter your price".tr,
            hintStyle: CustomTextStyles.titleMediumBluegray300,
            textInputType: TextInputType.number, inputFormatters: [],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Messages",
                  style: CustomTextStyles.labelBigBlack900,
                ),
                Obx(() => controller.showAddButton.value
                    ? TextButton(
                        onPressed: () {
                          controller.additionalTextFields
                              .add(TextEditingController());
                          controller.showAddButton.value = false;
                        },
                        child: Text(
                          "+Set Price",
                          style: CustomTextStyles.titleSmallffec1313,
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "All users can send messages for free. If you want to charge for messages, please include the price/message.",
              style: theme.textTheme.bodyMedium
                
            ),
          ),
          Obx(() => Column(
                children: controller.additionalTextFields
                    .map((textController) => Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: CustomTextFormField(
                            width: MediaQuery.of(context).size.width,
                            controller: textController,
                            focusNode: controller.focus3,
                            hintText: " Enter your price".tr,
                            hintStyle: CustomTextStyles.titleMediumBluegray300,
                            textInputType: TextInputType.number, inputFormatters: [],
                          ),
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
