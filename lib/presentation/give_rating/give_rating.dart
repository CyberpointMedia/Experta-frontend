import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/bio_textformfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingPage extends StatefulWidget {
  final String bookingId;
  final String userName;
  final String profilePic;
  const RatingPage(
      {super.key,
      required this.bookingId,
      required this.userName,
      required this.profilePic});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _textFieldHeight = 150.0;
  int _selectedRating = 0; // State variable for selected rating
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitRating() async {
    final url = Uri.parse('http://3.110.252.174:8080/api/video-rating');
    final body = jsonEncode({
      "bookingId": "6728c79404d87083dbd5b371",
      "rating": _selectedRating,
      "review": _reviewController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'failed') {
        _showErrorDialog(responseData['error']['errorMessage']);
      } else {
        _showSuccessDialog();
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Rating submitted successfully!'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
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
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Give Rating"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:_buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 50,bottom: 20),
        child: Column(

          children: [
            CustomImageView(
              height: 100,
              width: 100,
              radius: BorderRadius.circular(50),
              imagePath: widget.profilePic,
            ),
            const SizedBox(height: 10),
             Text(
              'How was your experience with',
              style: theme.textTheme.titleSmall!.copyWith(color: appTheme.gray600, fontSize: 14)
            ),
            Text(
              widget.userName.toUpperCase(),
              style: theme.textTheme.titleSmall!.copyWith(color: appTheme.black900, fontSize: 16)
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: theme.primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Write your review", style: theme.textTheme.titleSmall!.copyWith(color: appTheme.gray600, fontSize: 14),textAlign: TextAlign.start,)),
                  CustomBioTextFormField(
                        controller: _reviewController,
                        hintText:  "Write Your review",
                                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                        textStyle:theme.textTheme.titleMedium!.copyWith(color: Colors.black, fontSize: 16.fSize, fontWeight: FontWeight.w500,),

                  ),
            const Spacer(),
            CustomElevatedButton(
                       height: 56.adaptSize,
              onPressed: _submitRating,
              text:'Submit Rating',
            ),
          ],
        ),
      ),
    );
  }
}
