import 'dart:ui';
import 'package:photo_view/photo_view.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Basic_Info/controller/basic_info_controller.dart';
import 'package:experta/widgets/bio_textformfield.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BasicProfileInfo extends StatefulWidget {
  const BasicProfileInfo({super.key});

  @override
  State<BasicProfileInfo> createState() => _BasicProfileInfoState();
}

class _BasicProfileInfoState extends State<BasicProfileInfo> {
  BasicProfileInfoController controller = Get.put(BasicProfileInfoController());

  void _addSocialLink() {
    setState(() {
      controller.socialLinks.add('');
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
                              : const AssetImage(
                                  "assets/images/settings/profile.jpeg"))
                          as ImageProvider,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              "Your Name",
              style: CustomTextStyles.bodyLargeBlack90001,
              textAlign: TextAlign.start,
            ),
          ),
          CustomTextFormField(
            width: MediaQuery.of(context).size.width,
            controller: controller.textField1,
            focusNode: controller.focus1,
            hintText: "Your Name".tr,
            hintStyle: CustomTextStyles.titleMediumBluegray300,
            textInputType: TextInputType.name,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "Display Name",
              style: CustomTextStyles.bodyLargeBlack90001,
              textAlign: TextAlign.start,
            ),
          ),
          CustomTextFormField(
            controller: controller.textField2,
            focusNode: controller.focus2,
            width: MediaQuery.of(context).size.width,
            hintText: "Display Name".tr,
            hintStyle: CustomTextStyles.titleMediumBluegray300,
            textInputType: TextInputType.name,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "Bio",
              style: CustomTextStyles.bodyLargeBlack90001,
              textAlign: TextAlign.start,
            ),
          ),
          CustomBioTextFormField(
            controller: controller.textField3,
            focusNode: controller.focus3,
            hintText: "Write Your Bio",
            hintStyle: CustomTextStyles.titleMediumBluegray300,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              "Social Links",
              style: CustomTextStyles.bodyLargeBlack90001,
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
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: _getSocialMediaIcon(controller.socialLinks[index]),
        ),
        Expanded(
          child: CustomTextFormField(
            initialValue: controller.socialLinks[index],
            onChanged: (value) =>
                setState(() => controller.socialLinks[index] = value),
            hintText: "Social Link".tr,
            hintStyle: CustomTextStyles.titleMediumBluegray300,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            suffix: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () =>
                  setState(() => controller.socialLinks.removeAt(index)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getSocialMediaIcon(String link) {
    if (link.contains('facebook.com')) {
      return const Icon(FontAwesomeIcons.facebookF,
          size: 20.0, color: Colors.blue);
    } else if (link.contains('instagram.com')) {
      return const Icon(FontAwesomeIcons.instagram,
          size: 20.0, color: Colors.pink);
    } else if (link.contains('twitter.com')) {
      return const Icon(FontAwesomeIcons.twitter,
          size: 20.0, color: Colors.lightBlue);
    } else if (link.contains('linkedin.com')) {
      return const Icon(FontAwesomeIcons.linkedin,
          size: 20.0, color: Colors.blueAccent);
    } else if (link.contains('youtube.com')) {
      return const Icon(FontAwesomeIcons.youtube,
          size: 20.0, color: Colors.red);
    } else if (link.contains('github.com')) {
      return const Icon(FontAwesomeIcons.github,
          size: 20.0, color: Colors.black);
    } else {
      return const SizedBox();
    }
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
}
