import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExpertaBrowser extends StatefulWidget {
  const ExpertaBrowser({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<ExpertaBrowser> createState() => _ExpertaBrowserState();
}

class _ExpertaBrowserState extends State<ExpertaBrowser> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: WebViewWidget(controller: controller),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.cross,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => Get.back(),
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: widget.title),
      actions: [
        IconButton(
          onPressed: () {
            controller.reload();
          },
          icon: const Icon(Icons.refresh_outlined),
        )
      ],
    );
  }
}
