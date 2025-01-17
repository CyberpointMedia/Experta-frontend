import 'dart:ui';
import 'package:experta/presentation/edit_about/edit_about.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/social_platform_input.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Basic_Info/controller/basic_info_controller.dart';
import 'package:experta/widgets/bio_textformfield.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class BasicProfileInfo extends StatefulWidget {
  const BasicProfileInfo({super.key});

  @override
  State<BasicProfileInfo> createState() => _BasicProfileInfoState();
}

class _BasicProfileInfoState extends State<BasicProfileInfo> {
  BasicProfileInfoController controller = Get.put(BasicProfileInfoController());

  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  @override
  void initState() {
    super.initState();
    controller.isLoading.listen((isLoading) {
      if (!isLoading) {
        _initializeGenderSelection();
      }
    });
  }

  void _initializeGenderSelection() {
    String currentGender =
        controller.genderController.text.toLowerCase().trim();
    setState(() {
      isMaleSelected = currentGender == 'male';
      isFemaleSelected = currentGender == 'female';
    });
  }

  void _addSocialLink() {
    setState(() {
      controller.socialLinks.add({'platform': '', 'link': ''});
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFullImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('View Image'),
          ),
          body: Obx(() {
            return PhotoView(
              imageProvider: controller.imageFile.value != null
                  ? FileImage(controller.imageFile.value!)
                  : (controller.profileImageUrl.value.isNotEmpty
                          ? NetworkImage(controller.profileImageUrl.value)
                          : const AssetImage(
                              "assets/images/settings/profile.jpeg"))
                      as ImageProvider,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerEffect();
              } else {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          _buildAppBar(),
                          _buildBasicPic(),
                          Expanded(child: _formFields()),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        ],
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
        title: AppbarSubtitleSix(text: "Edit Basic Info"));
  }

  Widget _buildBasicPic() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: _showFullImage,
            child: Obx(() {
              return CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.purple,
                  backgroundImage: controller.imageFile.value != null
                      ? FileImage(controller.imageFile.value!)
                      : (controller.profileImageUrl.value.isNotEmpty
                          ? NetworkImage(controller.profileImageUrl.value)
                          : CustomImageView(
                              imagePath: ImageConstant.imageNotFound,
                            )) as ImageProvider,
                ),
              );
            }),
          ),
        ),
        TextButton(
          onPressed: _showImagePickerOptions,
          child: const Text(
            "Change Profile Picture",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _formFields() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5,left: 5),
                    child: Text(
                      "First Name",
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                   CustomTextFormField(
                    
                width: MediaQuery.of(context).size.width/2.45,
                controller: controller.firstnameController,
                focusNode: controller.focus1,
                hintText: "Enter your First name".tr,
                hintStyle: CustomTextStyles.titleMediumBluegray300,
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w500,
                ),
                textInputType: TextInputType.name,
              ),
                       
                ],
              ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Padding(
                  padding: const EdgeInsets.only(bottom: 5,left: 5),
                  child: Text(
                    "Last Name",
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                                ),
                   CustomTextFormField(
                              width: MediaQuery.of(context).size.width/2.45,
                              controller: controller.lastnameController,
                              focusNode: controller.lastnamefocus,
                              hintText: "Enter your Last name".tr,
                              hintStyle: CustomTextStyles.titleMediumBluegray300,
                              textStyle: theme.textTheme.titleMedium!.copyWith(
                                color: Colors.black,
                                fontSize: 16.fSize,
                                fontWeight: FontWeight.w500,
                              ),
                              textInputType: TextInputType.name,
                            ),
                             ],
                           ),
                ),
            ],
          ),
       
        
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "Display Name",
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          CustomTextFormField(
            controller: controller.displayNameController,
            focusNode: controller.focus2,
            width: MediaQuery.of(context).size.width,
            hintText: "Name to display publicly".tr,
            hintStyle: CustomTextStyles.titleMediumBluegray300,
            textStyle: theme.textTheme.titleMedium!.copyWith(
              color: Colors.black,
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
            ),
            textInputType: TextInputType.name,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "What’s your gender?",
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMaleSelected = true;
                      isFemaleSelected = false;
                      controller.genderController.text = 'Male';
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: 149.0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 28.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: isMaleSelected
                            ? theme.primaryColor
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomImageView(
                          imagePath: isMaleSelected
                              ? ImageConstant.male
                              : ImageConstant.maleunselected,
                          width: 50.0,
                          height: 50.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Male",
                            style: theme.textTheme.titleSmall!.copyWith(
                                color: isMaleSelected
                                    ? appTheme.black900
                                    : appTheme.gray400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMaleSelected = false;
                      isFemaleSelected = true;
                      controller.genderController.text = 'Female';
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: 149.0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 28.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: isFemaleSelected
                            ? theme.primaryColor
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomImageView(
                          imagePath: isFemaleSelected
                              ? ImageConstant.female
                              : ImageConstant.femele,
                          width: 50.0,
                          height: 50.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Female",
                            style: theme.textTheme.titleSmall!.copyWith(
                                color: isFemaleSelected
                                    ? appTheme.black900
                                    : appTheme.gray400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "Date of birth (DD/MM/YYYY)",
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          CustomTextFormField(
            hintText: "01/01/2024",
            readOnly: true,
            hintStyle: CustomTextStyles.titleMediumBluegray300,
            textInputType: TextInputType.datetime,
            controller: controller.dateOfBirthController,
            focusNode: FocusNode(),
            suffix: CustomIconButton(
                decoration: const BoxDecoration(color: Colors.transparent),
                height: 24.0, // Adjust the size as needed
                width: 24.0,
                child: CustomImageView(
                  imagePath: ImageConstant.imgCalendar,
                  color: appTheme.blueGray300,
                  onTap: () => _selectDate(context),
                )

                // Adjust the size as needed
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "Bio",
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final currentBio = controller.bioController.text;
              final result = await Get.to(
                () => EditAboutPage(bio: currentBio),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              if (result != null && result is String) {
                controller.bioController.text = result;
              }
            },
            child: AbsorbPointer(
              child: CustomBioTextFormField(
                controller: controller.bioController,
                focusNode: controller.focus3,
                hintText: "Write Your Bio",
                hintStyle: CustomTextStyles.titleMediumBluegray300,
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "Social Links",
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Obx(() => Column(
                children: controller.socialLinks
                    .asMap()
                    .entries
                    .map((entry) => _buildSocialLinkFormField(entry.key))
                    .toList(),
              )),
          const SizedBox(
            height: 10,
          ),
          CustomElevatedButton(
            onPressed: _addSocialLink,
            text: "+ Add More Links".tr,
            buttonTextStyle:
                theme.textTheme.titleMedium!.copyWith(color: Colors.red),
            buttonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomElevatedButton(
            text: "Save Changes",
            onPressed: () {
              controller.saveProfileInfo();
            },
          )
        ],
      ),
    );
  }

  Widget _buildSocialLinkFormField(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            child: SocialPlatformInput(
              initialPlatform: controller.socialLinks[index]['platform'],
              initialLink: controller.socialLinks[index]['link'],
              onChanged: (platform, link) {
                setState(() {
                  // Update both platform and link in the controller
                  controller.socialLinks[index] = {
                    'platform': platform,
                    'link': link
                  };
                });
              },
            ),
          ),
          SizedBox(width: 8.h),
          CustomImageView(
            height: 20.v,
            width: 20.h,
            imagePath: ImageConstant.cross,
            onTap:() {
              setState(() {
                  print("tab value= $index");
                  controller.socialLinks.removeAt(index);
              });
            },
          ),
          SizedBox(width: 8.h),
        ],
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  Widget _buildShimmerEffect() {
    return IntrinsicHeight(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            _buildAppBar(),
            _buildBasicPic(),
            Expanded(child: _formFields()),
          ],
        ),
      ),
    );
  }


  void _selectDate(BuildContext context) async {
    String date = DateFormat("dd/MM/yyyy").format(DateTime.now());
    final sDateFormate = "DD/MM/yyyy";
    DateTime selectedDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      // fieldHintText: sDateFormate,
       initialDate: selectedDate,
       firstDate: DateTime(1900),
       lastDate: DateTime.now(),
       locale: const Locale('en', 'GB'), // Adjust to your locale
    );
    if (pickedDate != null) {
      setState(() {
        controller.dateOfBirthController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }
}
