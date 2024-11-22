import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../core/app_export.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.enablePinAutofill = false,
  });

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  final Function(String) onChanged;

  final FormFieldValidator<String>? validator;

  final bool enablePinAutofill;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget,
          )
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => PinCodeTextField(
        appContext: context,
        controller: controller,
        length: 6,
        keyboardType: TextInputType.number,
        textStyle: textStyle ?? CustomTextStyles.titleMedium18,
        hintStyle: hintStyle ?? CustomTextStyles.titleMedium18,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        enableActiveFill: true,
        pinTheme: PinTheme(
          fieldHeight: 52.h,
          fieldWidth: 54.h,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10.h),
          inactiveColor: appTheme.gray30001,
          activeColor: appTheme.gray30001,
          inactiveFillColor:
              theme.colorScheme.onPrimaryContainer.withOpacity(1),
          activeFillColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          selectedColor: theme.colorScheme.primary,
          selectedFillColor:
              theme.colorScheme.onPrimaryContainer.withOpacity(1),
        ),
        onChanged: (value) => onChanged(value),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autoDismissKeyboard: true,
        enablePinAutofill: enablePinAutofill,
      );
}
