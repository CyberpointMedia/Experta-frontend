import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_export.dart';

class CustomBioTextFormField extends StatefulWidget {
  const CustomBioTextFormField({
    super.key,
    this.alignment,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.wordLimit = 500,
  });

  final Alignment? alignment;
  final double? width;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextStyle? textStyle;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final int maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool filled;
  final FormFieldValidator<String>? validator;
  final int wordLimit;

  @override
  _CustomBioTextFormFieldState createState() => _CustomBioTextFormFieldState();
}

class _CustomBioTextFormFieldState extends State<CustomBioTextFormField> {
  late TextEditingController _controller;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateWordCount);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateWordCount() {
    setState(() {
      _wordCount = _controller.text
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widget.alignment != null
            ? Align(
                alignment: widget.alignment ?? Alignment.center,
                child: textFormFieldWidget,
              )
            : textFormFieldWidget,
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '$_wordCount/${widget.wordLimit}',
            style: TextStyle(
                color:
                    _wordCount > widget.wordLimit ? Colors.red : Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget get textFormFieldWidget => SizedBox(
        width: widget.width ?? double.maxFinite,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: _controller,
          focusNode: widget.focusNode ?? FocusNode(),
          autofocus: widget.autofocus,
          style: widget.textStyle ?? theme.textTheme.titleMedium,
          obscureText: widget.obscureText,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          maxLines: null, // Allows the field to expand vertically
          decoration: decoration,
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            if (_wordCount > widget.wordLimit) {
              return 'Word limit exceeded';
            }
            return null;
          },
          inputFormatters: [WordLimitInputFormatter(widget.wordLimit)],
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: widget.hintText ?? "",
        hintStyle: widget.hintStyle ??
            CustomTextStyles.titleMediumOnPrimaryContainer_1,
        prefixIcon: widget.prefix,
        prefixIconConstraints: widget.prefixConstraints,
        suffixIcon: widget.suffix,
        suffixIconConstraints: widget.suffixConstraints,
        isDense: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 15.h,
              vertical: 16.v,
            ),
        fillColor: widget.fillColor ??
            theme.colorScheme.onPrimaryContainer.withOpacity(1),
        filled: widget.filled,
        border: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
        enabledBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
        focusedBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1,
              ),
            ),
      );
}

class WordLimitInputFormatter extends TextInputFormatter {
  final int wordLimit;

  WordLimitInputFormatter(this.wordLimit);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int wordCount = newValue.text
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    if (wordCount <= wordLimit) {
      return newValue;
    }
    return oldValue;
  }
}
