import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? bankDetails;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchBankingDetails();
  }

  Future<void> fetchBankingDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final details = await _apiService.getBankingDetails();
      setState(() {
        bankDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load banking details';
        isLoading = false;
      });
      print('Error fetching banking details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load banking details')),
      );
    }
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account Number",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              hintText: "Account Number",
              readOnly: true,
              hintStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
              textInputType: TextInputType.number,
              autofocus: false,
            ),
            const SizedBox(height: 10),
            Text(
              "IFSC Code",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              hintText: "IFSC Code",
              readOnly: true,
              hintStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
              textInputType: TextInputType.number,
              autofocus: false,
            ),
            const SizedBox(),
            Text(
              "Bank Name",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              hintText: "Bank Name",
              readOnly: true,
              hintStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
              textInputType: TextInputType.text,
              autofocus: false,
            ),
            const SizedBox(height: 10),
            Text(
              "Branch Name",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              hintText: "Branch Name",
              readOnly: true,
              hintStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
              textInputType: TextInputType.name,
              autofocus: false,
            ),
            Text(
              "State",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              hintText: "State",
              readOnly: true,
              hintStyle: theme.textTheme.titleSmall!.copyWith(fontSize: 14),
              textInputType: TextInputType.name,
              autofocus: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          isLoading
              ? _buildShimmerLoading()
              : error != null
                  ? Center(child: Text(error!))
                  : SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Account Number",
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            CustomTextFormField(
                              initialValue: bankDetails?['accountNumber'] ?? '',
                              readOnly: true,
                              hintStyle: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 14),
                              textInputType: TextInputType.number,
                              autofocus: false,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "IFSC Code",
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            CustomTextFormField(
                              initialValue: bankDetails?['ifsc'] ?? '',
                              readOnly: true,
                              hintStyle: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 14),
                              textInputType: TextInputType.number,
                              autofocus: false,
                            ),
                            const SizedBox(),
                            Text(
                              "Bank Name",
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            CustomTextFormField(
                              initialValue: bankDetails?['bankDetails']
                                      ?['ifsc_details']?['bank_name'] ??
                                  '',
                              readOnly: true,
                              hintStyle: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 14),
                              textInputType: TextInputType.text,
                              autofocus: false,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Branch Name",
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            CustomTextFormField(
                              initialValue: bankDetails?['bankDetails']
                                      ?['ifsc_details']?['branch'] ??
                                  '',
                              readOnly: true,
                              hintStyle: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 14),
                              textInputType: TextInputType.name,
                              autofocus: false,
                            ),
                            Text(
                              "State",
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            CustomTextFormField(
                              initialValue: bankDetails?['bankDetails']
                                      ?['ifsc_details']?['state'] ??
                                  '',
                              readOnly: true,
                              hintStyle: theme.textTheme.titleSmall!
                                  .copyWith(fontSize: 14),
                              textInputType: TextInputType.name,
                              autofocus: false,
                            ),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Bank Account Details"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
