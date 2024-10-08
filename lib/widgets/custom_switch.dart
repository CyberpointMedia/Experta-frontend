import 'package:flutter/cupertino.dart';
import '../core/app_export.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.onChange,
    this.alignment,
    this.value,
    this.width,
    this.height,
    this.margin,
  });

  final Alignment? alignment;

  final bool? value;

  final Function(bool) onChange;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        margin: margin,
        child: alignment != null
            ? Align(
                alignment: alignment ?? Alignment.center,
                child: switchWidget,
              )
            : switchWidget);
  }

  Widget get switchWidget => CupertinoSwitch(
        value: value ?? false,
        trackColor: appTheme.green400,
        thumbColor: (value ?? false)
            ? theme.colorScheme.onPrimaryContainer.withOpacity(1)
            : theme.colorScheme.onPrimaryContainer.withOpacity(1),
        activeColor: appTheme.green400,
        onChanged: (value) {
          onChange(value);
        },
      );
}
