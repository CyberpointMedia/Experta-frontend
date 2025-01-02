import 'dart:io';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/dashed_border.dart';
import 'package:file_picker/file_picker.dart';

class RaiseTicketPage extends StatefulWidget {
  const RaiseTicketPage({super.key});

  @override
  State<RaiseTicketPage> createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends State<RaiseTicketPage> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptonController = TextEditingController();
  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  double _uploadProgress = 0.0;
  String? _uploadResponse;
  bool _isUploading = false;
  ApiService apiService = ApiService();
  PlatformFile? _pickedFile;

  @override
  void dispose() {
    subjectController.dispose();
    descriptonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Subject", style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: subjectController,
                          hintText: "Enter Subject",
                          hintStyle: CustomTextStyles.titleMediumBluegray300,
                          textInputType: TextInputType.text,
                          focusNode: subjectFocusNode,
                          autofocus: false, inputFormatters: [],
                        ),
                        const SizedBox(height: 16),
                        Text("Description", style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          maxLines: 5,
                          controller: descriptonController,
                          hintText: "Enter description here",
                          hintStyle: CustomTextStyles.titleMediumBluegray300,
                          textInputType: TextInputType.text,
                          focusNode: descriptionFocusNode,
                          autofocus: false, inputFormatters: [],
                        ),
                        const SizedBox(height: 16),
                        (_uploadResponse != null)
                            ? Center(
                                child: CustomImageView(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  imagePath: _uploadResponse,
                                ),
                              )
                            : GestureDetector(
                                onTap: _pickFileAndUpload,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomImageView(
                                          imagePath: ImageConstant.uploadcloud,
                                          width: 40,
                                          height: 40,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text("Upload your file",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        const SizedBox(height: 4),
                                        const Text("(JPEG, PNG)",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 8),
                        const Text("Maximum upload file size: 2MB",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12)),
                        const SizedBox(height: 16),
                        if (_isUploading && _pickedFile != null)
                          _buildFileUploadProgress(),
                        const Spacer(),
                        CustomElevatedButton(
                          text: 'Submit',
                          onPressed: _submitTicket,
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

  Widget _buildFileUploadProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 100.v,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                CustomIconButton(
                    height: 44.adaptSize,
                    width: 44.adaptSize,
                    padding: EdgeInsets.all(10.h),
                    decoration: IconButtonStyleHelper.fillGrayTL22,
                    child: CustomImageView(
                      imagePath: ImageConstant.pdf,
                    )),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pickedFile!.name,
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: appTheme.black900),
                    ),
                    Row(
                      children: [
                        Text(
                            '${(_pickedFile!.size / 1024).toStringAsFixed(2)} KB  •  '),
                        Text(
                            '${(_uploadProgress * 100).toStringAsFixed(0)}% uploaded'),
                      ],
                    ),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _uploadProgress,
              color: appTheme.green400,
              backgroundColor: appTheme.gray200,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFileAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.single;
      });
      File file = File(_pickedFile!.path!);
      _uploadFile(file);
    }
  }

  Future<void> _uploadFile(File file) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final response = await apiService.uploadFile(
        file,
        (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      setState(() {
        _uploadResponse = response['data']['fileUrl'];
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _uploadResponse = "Upload failed: $e";
        _isUploading = false;
      });
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.0,
      leadingWidth: 40.0,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: const EdgeInsets.only(left: 16.0),
        onTap: () {
          Get.back();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Raise Ticket"),
    );
  }

  Future<void> _submitTicket() async {
    if (subjectController.text.isEmpty || descriptonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final response = await apiService.raiseTicket(
        subject: subjectController.text,
        description: descriptonController.text,
        fileUrl: _uploadResponse ?? '',
      );

      if (response['status'] == 'success') {
        _showSuccessBottomSheet(response['data']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showSuccessBottomSheet(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140.h,
              height: 140.v,
              decoration: BoxDecoration(
                color: appTheme.green400.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 92.h,
                  height: 92.v,
                  decoration: BoxDecoration(
                    color: appTheme.green400,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomImageView(
                      imagePath: ImageConstant.success,
                      height: 20.v,
                      width: 30.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Ticket Raised Successfully!',
                style: theme.textTheme.titleMedium!
                    .copyWith(color: appTheme.black900)),
            const SizedBox(height: 8),
            Text('Ticket ID: ${data['_id']}',
                style: theme.textTheme.titleSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Status: ${data['status']}',
                    style: theme.textTheme.titleSmall!),
                Text('Priority: ${data['priority']}',
                    style: theme.textTheme.titleSmall!),
              ],
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
