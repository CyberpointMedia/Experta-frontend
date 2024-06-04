import 'package:experta/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomToast {
  static final CustomToast _instance = CustomToast._internal();
  factory CustomToast() {
    return _instance;
  }

  CustomToast._internal();

  OverlayEntry? _overlayEntry;

  void showToast({
    required BuildContext context,
    required String message,
    required bool isSuccess,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 20,
        right: 20,
        child: _ToastWidget(
          message: message,
          isSuccess: isSuccess,
        ),
      ),
    );

    final overlay = Overlay.of(context);
    overlay?.insert(_overlayEntry!);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(duration, () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    });
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.isSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isSuccess ? Colors.green : Colors.red,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              // const SizedBox(width: 12.0),
              // CustomImageView(
              //   height: 24,
              //   width: 24,
              //   imagePath: 'assets/images/smlogo.svg',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
