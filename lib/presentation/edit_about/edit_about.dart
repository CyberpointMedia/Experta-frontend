// lib/pages/edit_about_page.dart
import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class EditAboutPage extends StatefulWidget {
  final String bio;

  const EditAboutPage({super.key, required this.bio});

  @override
  State<EditAboutPage> createState() => _EditAboutPageState();
}

class _EditAboutPageState extends State<EditAboutPage> {
  late TextEditingController bioController;
  final ApiService _apiService = ApiService();
  List<String> bioSuggestions = [];
  bool isLoading = false;
  bool loaded = false;
  int? selectedSuggestionIndex;

  var lastchangetext="";

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController(text: widget.bio);
    lastchangetext=bioController.text;
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  void resetPage() {
    setState(() {
      bioController.clear();
      bioSuggestions.clear();
      selectedSuggestionIndex = null;
      bioController.text=lastchangetext;
    });
  }

  Future<void> getBioSuggestions() async {
    if (bioController.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final suggestions = await _apiService.getBioSuggestions(
        bioController.text.trim(),
      );
      setState(() {
        bioSuggestions = suggestions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CustomToast().showToast(
        context: context,
        message: "Error getting suggestions: $e",
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset : false,
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),
                  Text(
                    "Edit About",
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: appTheme.black900),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.52,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: bioController,
                            maxLength: 500,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              counterText: "",
                              hintText: "Edit your bio here",
                              hintStyle: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 20),
                          if (bioSuggestions.isNotEmpty) ...[
                            Text(
                              "Suggestions",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bioSuggestions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: AppDecoration.fillOnPrimaryContainer
                                      .copyWith(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: selectedSuggestionIndex == index
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      bioSuggestions[index],
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        bioController.text =
                                            bioSuggestions[index];
                                        selectedSuggestionIndex = index;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Divider(color: appTheme.black900),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (bioSuggestions.isEmpty)
                        CustomElevatedButton(
                          height: 36,
                          width: MediaQuery.of(context).size.width * 0.4,
                          text: !isLoading ? "Write with AI" : "Suggesting...",
                          isDisabled: isLoading,
                          leftIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CustomImageView(
                              imagePath: ImageConstant.ai,
                            ),
                          ),
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: appTheme.gray300),
                            ),
                          ),
                          onPressed: isLoading ? null : getBioSuggestions,
                        )
                      else
                        CustomElevatedButton(
                          height: 36,
                          width: MediaQuery.of(context).size.width * 0.3,
                          text: "Revert",
                          leftIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CustomImageView(
                              imagePath: ImageConstant.revert,
                            ),
                          ),
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: appTheme.gray300),
                            ),
                          ),
                          onPressed: resetPage,
                        ),
                      Text(
                        "${bioController.text.length}/500",
                        style: theme.textTheme.titleSmall,
                      )
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      text: !loaded ? 'Save' : "Saving...",
                      isDisabled: loaded,
                      onPressed: () async {
                        setState(() {
                          loaded = true;
                        });
                        if (bioController.text.trim().isNotEmpty) {
                          try {
                            final success = await _apiService
                                .updateBio(bioController.text.trim());
                            if (success) {
                              setState(() {
                                loaded = true;
                              });
                              Get.back(result: bioController.text.trim());
                            } else {
                              setState(() {
                                loaded = true;
                              });
                              CustomToast().showToast(
                                context: context,
                                message: "Failed to update bio",
                                isSuccess: false,
                              );
                            }
                          } catch (e) {
                            setState(() {
                              loaded = true;
                            });
                            CustomToast().showToast(
                              context: context,
                              message: "Error updating bio: $e",
                              isSuccess: false,
                            );
                          }
                        }else{
                             setState(() {
                                loaded = false;
                              });
                             CustomToast().showToast(
                                context: context,
                                message: "Please enter bio!",
                                isSuccess: false,
                              );
                        }
            
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
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

  Widget _buildAppBar() {
    return CustomAppBar(
      centerTitle: true,
      height: 65,
      leadingWidth: 45,
      leading: Padding(
        padding: const EdgeInsets.only(left: 0, right: 26),
        child: CustomImageView(
          imagePath: ImageConstant.cross,
          onTap: () => Get.back(),
        ),
      ),
    );
  }
}
