import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:experta/core/utils/validation_functions.dart';
import 'package:experta/core/app_export.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomPhoneNumber extends StatefulWidget {
  CustomPhoneNumber({
    super.key,
    required this.country,
    required this.onTap,
    required this.controller,
  });

  Country country;

  Function(Country) onTap;

  TextEditingController? controller;

  @override
  State<CustomPhoneNumber> createState() => _CustomPhoneNumberState();
}

class _CustomPhoneNumberState extends State<CustomPhoneNumber> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Add listener to focus node
    _focusNode.addListener(() {
      if (_focusNode.hasFocus != _isFocused) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    // Don't forget to dispose the focus node
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(
          color: _isFocused
              ? Colors.yellow
              : appTheme.gray30001, // Change border color based on focus
          width: 1.h,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // _openCountryPicker(context);   //just uncomment this if you want to open country picker by tapping on t
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 15.h,
                top: 14.v,
                bottom: 14.v,
              ),
              child: Row(
                children: [
                  CountryPickerUtils.getDefaultFlagImage(widget.country),
                  CustomImageView(
                    imagePath: ImageConstant.imgArrowDown,
                    height: 18.adaptSize,
                    width: 18.adaptSize,
                    margin: EdgeInsets.fromLTRB(10.h, 3.v, 11.h, 3.v),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 9.h, right: 5.h),
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: "lbl_phone_number".tr,
                hintStyle: CustomTextStyles.titleMediumBluegray300,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: CustomTextStyles.titleMediumBluegray300,
              keyboardType: TextInputType.phone,
              focusNode: _focusNode,
              enableInteractiveSelection: false,
              contextMenuBuilder: (context, editableTextState) {
                return Container();
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(10),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if ((newValue.text.length - oldValue.text.length) > 1) {
                    return oldValue;
                  }
                  return newValue;
                }),
              ],
              validator: (value) {
                if (!isValidPhone(value, isRequired: true)) {
                  return "err_msg_please_enter_valid_phone_number".tr;
                }
                return null;
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Container(
            margin: EdgeInsets.only(
              left: 10.h,
            ),
            width: 60.h,
            child: Text(
              "+${country.phoneCode}",
              style: TextStyle(fontSize: 14.fSize),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              country.name,
              style: TextStyle(fontSize: 14.fSize),
            ),
          ),
        ],
      );

  void _openCountryPicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
          searchInputDecoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14.fSize),
          ),
          isSearchable: true,
          title: Text('Select your phone code',
              style: TextStyle(fontSize: 14.fSize)),
          onValuePicked: (Country country) => widget.onTap(country),
          itemBuilder: _buildDialogItem,
        ),
      );
}
