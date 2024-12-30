import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/add_upi/controller/add_upi_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class PanDetail extends StatefulWidget {
  final String name;
  final String panno;
  final String dob;

  const PanDetail(
      {super.key, required this.name, required this.panno, required this.dob});

  @override
  State<PanDetail> createState() => _PanDetailState();
}

class _PanDetailState extends State<PanDetail> {
  AddUpiController controller = Get.put(AddUpiController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Full Name"),
                  const SizedBox(
                    height: 6,
                  ),
                  CustomTextFormField(
                    initialValue: widget.name,
                    textInputType: TextInputType.name,
                    autofocus: false,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  const Text("PAN Number"),
                  const SizedBox(
                    height: 6,
                  ),
                  CustomTextFormField(
                    initialValue: widget.panno,
                    textInputType: TextInputType.text,
                    autofocus: false,
                    readOnly: true,
                  ),
                  const Spacer(),
                ],
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
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "PAN Details"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
