import 'dart:ui'; // Required for the ImageFilter.blur
import 'package:experta/core/app_export.dart';

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
                      color: appTheme.deepOrangeA20.withOpacity(0.6), // Adjust the color
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
                            fillColor: Colors.grey.shade200, // Updated color
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove border
                              borderRadius: BorderRadius.circular(10.0),
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
                            fillColor: Colors.grey.shade200, // Updated color
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove border
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Upload File Section
                        GestureDetector(
                          onTap: () {
                            // Handle file upload
                          },
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey),
                              color: Colors.grey.shade200,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  "Upload your file",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
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
                        SizedBox(
                          width: double.infinity, // Full width
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle submit action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              minimumSize: const Size(150, 60), // Custom size for the button
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.black, fontSize: 15), // Larger text
                            ),
                          ),
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
      height: 40.h, // Adjust height as needed
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft(); // Go back when tapped
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(
        text: "Raise Ticket", // Your custom title
      ),
    );
  }

  // Function for back navigation
  void onTapArrowLeft() {
    Get.back(); // Using GetX to navigate back
  }
}

void main() {
  runApp(const MaterialApp(
    home: RaiseTicketPage(),
  ));
}
