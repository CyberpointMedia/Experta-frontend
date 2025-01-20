import 'package:experta/core/app_export.dart';

class CustomToast {
  static final CustomToast _instance = CustomToast._internal();

  factory CustomToast() => _instance;

  CustomToast._internal();

  OverlayEntry? _overlayEntry; 

  void showToast({
    required BuildContext context,
    required String message,
    required bool isSuccess,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    TextStyle? textStyle,
    IconData? icon,
  }) {
    // If a toast is already active, update the message and reset duration
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Accounts for status bar
        left: 20,
        right: 20,
        child: _ToastWidget(
          message: message,
          isSuccess: isSuccess,
          duration: duration,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          icon: icon,
        ),
      ),
    );

    final overlay = Overlay.of(context);
    if (overlay == null) {
      debugPrint("Overlay is not available in this context.");
      return;
    }
    overlay.insert(_overlayEntry!);

    // Remove the toast after the specified duration
    Future.delayed(duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final Duration duration;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final IconData? icon;

  const _ToastWidget({
    required this.message,
    required this.isSuccess,
    required this.duration,
    this.backgroundColor,
    this.textStyle,
    this.icon,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _iconScaleAnimation;
  late AnimationController _timerController;
  late Animation<double> _timerAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.elasticIn,
    ));

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticInOut,
    ));

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 75),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _timerController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _timerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _timerController,
      curve: Curves.linear,
    ));

    _animationController.forward();
    _timerController.forward();

    Future.delayed(widget.duration - const Duration(milliseconds: 700), () {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ??
        (widget.isSuccess ? Colors.green.shade700 : Colors.red.shade700);
    final txtStyle = widget.textStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );
    final toastIcon =
        widget.icon ?? (widget.isSuccess ? Icons.check_circle : Icons.error);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: bgColor,
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withOpacity(0.3),
                      blurRadius: 8.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ScaleTransition(
                          scale: _iconScaleAnimation,
                          child: RotationTransition(
                            turns: _iconRotationAnimation,
                            child: Icon(
                              toastIcon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: txtStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _timerAnimation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: _timerAnimation.value,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 2,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timerController.dispose();
    super.dispose();
  }
}
