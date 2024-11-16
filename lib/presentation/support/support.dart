import 'dart:ui'; // Required for the ImageFilter.blur
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/dashed_border.dart';
import 'package:file_picker/file_picker.dart';

class RaiseTicketPage extends StatelessWidget {
  const RaiseTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for the page
      body: Stack(
        children: [
          // Positioned Blur Background
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
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                _buildAppBar(),

                // Body content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject Field
                        const Text(
                          "Subject",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Enter subject",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description Field
                        const Text(
                          "Description",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Enter description here",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'pdf'],
                            );

                            if (result != null) {
                              var pickedFile = result.files.single;
                              print('Picked file: ${pickedFile.name}');
                            }
                          },
                          child: CustomPaint(
                            painter: DashedBorderPainter(
                              color: Colors.grey,
                              strokeWidth: 1.0,
                              dashWidth: 5.0,
                              dashSpace: 3.0,
                            ),
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.uploadcloud,
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Upload your file",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  // Display file types info
                                  // const Text(
                                  //   "(JPEG, PNG, PDF)",
                                  //   style: TextStyle(color: Colors.grey),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Maximum upload file size: 2MB",
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        const Spacer(),

                        // Submit Button
                        const SizedBox(
                          width: double.infinity,
                          // Add your submit button here if needed
                        ),
                      ],
                    ),
                  ),
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
      height: 40.0,
      leadingWidth: 40.0,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: const EdgeInsets.only(left: 16.0),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(
        text: "Raise Ticket",
      ),
    );
  }

  // Function for back navigation
  void onTapArrowLeft() {
    Get.back();
  }
}
