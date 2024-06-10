import '../core/app_export.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.alignment,
    this.width,
    this.focusNode,
    this.icon,
    this.autofocus = true,
    this.textStyle,
    this.items,
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
    this.onChanged,
    this.value,
  });

  final Alignment? alignment;

  final double? width;

  final FocusNode? focusNode;

  final Widget? icon;

  final bool? autofocus;

  final TextStyle? textStyle;

  final List<SelectionPopupModel>? items;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<SelectionPopupModel>? validator;

  final Function(SelectionPopupModel)? onChanged;

  final SelectionPopupModel? value;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: dropDownWidget,
          )
        : dropDownWidget;
  }

  Widget get dropDownWidget => SizedBox(
        width: width ?? double.maxFinite,
        child: DropdownButtonFormField<SelectionPopupModel>(
          hint: Text(
            "Select",
            style:theme.textTheme.titleSmall!.copyWith(color: appTheme.black900),
          ),
          focusNode: focusNode ?? FocusNode(),
          icon: icon,
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.titleMediumOnPrimaryContainer_1,
          items: items?.map((SelectionPopupModel item) {
            return DropdownMenuItem<SelectionPopupModel>(
              value: item,
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: hintStyle ?? CustomTextStyles.titleMediumSemiBold_1,
                  ),
                ],
              ),
            );
          }).toList(),
          decoration: decoration,
          validator: validator,
          itemHeight: 50,
          onChanged: (value) {
            onChanged!(value!);
          },
          value: value,
        ),
      );

  InputDecoration get decoration => InputDecoration(
        // hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.titleMediumSemiBold_1,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              left: 15.v,
              right: 15.v,
              top: 16.v,
              bottom: 16.v,
            ),
        fillColor:
            fillColor ?? theme.colorScheme.onPrimaryContainer.withOpacity(1),
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: appTheme.gray30001,
                width: 1,
              ),
            ),
      );
}
