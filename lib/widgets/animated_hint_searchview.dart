import '../core/app_export.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class CustomAnimatedSearchView extends StatefulWidget {
  const CustomAnimatedSearchView({
    super.key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintTexts,
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
    this.onChanged,
    this.hintTextDuration = const Duration(seconds: 3),
  });

  final Alignment? alignment;
  final double? width;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final TextInputType? textInputType;
  final int? maxLines;
  final List<String>? hintTexts;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final Duration hintTextDuration;

  @override
  _CustomAnimatedSearchViewState createState() =>
      _CustomAnimatedSearchViewState();
}

class _CustomAnimatedSearchViewState extends State<CustomAnimatedSearchView> {
  int _currentHintIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.hintTexts != null && widget.hintTexts!.isNotEmpty) {
      _timer = Timer.periodic(widget.hintTextDuration, (timer) {
        setState(() {
          _currentHintIndex =
              (_currentHintIndex + 1) % widget.hintTexts!.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: searchViewWidget,
          )
        : searchViewWidget;
  }

  Widget get searchViewWidget => SizedBox(
        width: widget.width ?? double.maxFinite,
        child: TextFormField(
          scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          controller: widget.controller,
          focusNode: widget.focusNode ?? FocusNode(),
          autofocus: widget.autofocus!,
          style: widget.textStyle ?? theme.textTheme.titleMedium,
          keyboardType: widget.textInputType,
          maxLines: widget.maxLines ?? 1,
          decoration: decoration,
          validator: widget.validator,
          onChanged: (String value) {
            widget.onChanged!.call(value);
          },
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: widget.hintTexts != null && widget.hintTexts!.isNotEmpty
            ? widget.hintTexts![_currentHintIndex]
            : '',
        hintStyle: widget.hintStyle ?? CustomTextStyles.titleMediumBluegray300,
        prefixIcon: widget.prefix ??
            Container(
              margin: EdgeInsets.fromLTRB(15.h, 14.v, 6.h, 14.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgSearchBlueGray300,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
            ),
        prefixIconConstraints: widget.prefixConstraints ??
            BoxConstraints(
              maxHeight: 52.v,
            ),
        suffixIcon: widget.suffix,
        suffixIconConstraints: widget.suffixConstraints ??
            BoxConstraints(
              maxHeight: 52.v,
            ),
        isDense: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.only(
              top: 16.v,
              right: 16.h,
              bottom: 16.v,
            ),
        fillColor: widget.fillColor ??
            theme.colorScheme.onPrimaryContainer.withOpacity(1),
        filled: widget.filled,
        border: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(26.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
        enabledBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(26.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
        focusedBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(26.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
      );
}

/// Extension on [CustomAnimatedSearchView] to facilitate inclusion of all types of border style etc
extension SearchViewStyleHelper on CustomAnimatedSearchView {
  static OutlineInputBorder get fillGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get outlineGrayTL26 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(26.h),
        borderSide: BorderSide(
          color: appTheme.gray30001,
          width: 1,
        ),
      );
}
