import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  double enteredAmount = 1000.0;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: _buildAppBar(),
      body: Stack(
        children: [
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
                      color: appTheme.deepOrangeA20.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                 padding: const EdgeInsets.only(left: 16.0,right: 16,top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      _buildEnterAmountSection(),
                      _buildQuickSelectButtons(),
                      const Spacer(),
                      _buildDisclaimerText(),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      _buildDetailsSection(),
                      _buildTopUpButton(),
                    ],
                  ),
                ),
              ),
            ],
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
      title: AppbarSubtitleSix(text: "Top Up"),
    );
  }

  Widget _buildEnterAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enter amount",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              "₹",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            Expanded(
              child: TextFormField(
                controller: amountController,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    enteredAmount = double.tryParse(value) ?? 0;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "= ",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            CustomImageView(imagePath: ImageConstant.imgLayer1),
            const SizedBox(width: 8),
            Text(
              "$enteredAmount",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickSelectButtons() {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickSelectButton("+₹100", 100),
          _quickSelectButton("+₹200", 200),
          _quickSelectButton("+₹500", 500),
          _quickSelectButton("+₹1000", 1000),
        ],
      ),
    );
  }

  Widget _quickSelectButton(String text, double amount) {
    bool isSelected = enteredAmount == amount;
    return SizedBox(
      width: 70, // Set the width to 80 pixels
      height: 40, // Set the height to 46 pixels
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            enteredAmount = amount;
            amountController.text = amount.toString();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Set background to transparent
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(
            color: isSelected ? appTheme.deepYello : appTheme.gray200, // Set border color to orange if selected
            width: 1, // Set the border width
          ),
          elevation: 0, // Remove shadow
        ),
        child: Text(text, style: const TextStyle(fontSize: 16),),
      ),
    );
  }

  Widget _buildDisclaimerText() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: CustomImageView(imagePath: ImageConstant.imgInfoBlueGray300),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            "Effective 1st October 2023, as per the Govt. mandate, 28% GST will be applied on the top-up amount.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      children: [
        _buildDetailRow("Add to current balance", "₹150.00", isBold: true, color: Colors.black),
        // Divider(),
        _buildDetailRow("Deposit amount (excl. Govt. Tax)", "₹117.18"),
        _buildDetailRow("Govt. Tax (28% GST)", "₹32.82"),
        _buildDetailRow("Platform fee", "₹5.00"),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        _buildDetailRow("Total Amount", "₹112.18", isBold: true, color: Colors.black),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color color = Colors.grey}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 50,bottom: 20),
      child: CustomElevatedButton(
        onPressed: () {
          // Add top-up action here
          print("Top Up ₹$enteredAmount");
        },
        text: 'Top ₹150'
      ),
    );
  }
}
