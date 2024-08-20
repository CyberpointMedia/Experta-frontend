import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';

class ReportReasonSheet extends StatefulWidget {
  final String itemId;
  final String itemType;

  const ReportReasonSheet(
      {super.key, required this.itemId, required this.itemType});

  @override
  State<ReportReasonSheet> createState() => _ReportReasonSheetState();
}

class _ReportReasonSheetState extends State<ReportReasonSheet> {
  List<Reason> reasons = [];
  String? selectedReasonId;
  bool isLoading = true;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    log("itemId: ${widget.itemId}, itemType: ${widget.itemType}, selectedReasonId: ${selectedReasonId},");
    fetchReasons();
  }

  Future<void> fetchReasons() async {
    try {
      reasons = await apiService.fetchReasons();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToDetails() {
    log("itemId: ${widget.itemId}, itemType: ${widget.itemType}, selectedReasonId: ${selectedReasonId},");

    Navigator.pop(context);
    Get.bottomSheet(
      backgroundColor: appTheme.whiteA700,
      ReportDetailsSheet(
        itemId: widget.itemId,
        itemType: widget.itemType,
        selectedReasonId: selectedReasonId!,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Why are you reporting?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey[300]),
                  ...reasons.map((reason) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(reason.reason),
                          trailing: CustomImageView(
                            imagePath: ImageConstant.imgArrowRight,
                            color: appTheme.black900,
                          ),
                          onTap: () {
                            setState(() {
                              selectedReasonId = reason.id;
                            });
                            navigateToDetails();
                          },
                          selected: selectedReasonId == reason.id,
                          selectedTileColor: Colors.grey[200],
                        ),
                        Divider(color: Colors.grey[300]),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
  }
}

class ReportDetailsSheet extends StatefulWidget {
  final String itemId;
  final String itemType;
  final String selectedReasonId;

  const ReportDetailsSheet({
    super.key,
    required this.itemId,
    required this.itemType,
    required this.selectedReasonId,
  });

  @override
  State<ReportDetailsSheet> createState() => _ReportDetailsSheetState();
}

class _ReportDetailsSheetState extends State<ReportDetailsSheet> {
  final TextEditingController commentController = TextEditingController();
  ApiService apiService = ApiService();

  Future<void> submitReport() async {
    try {
      final report = Report(
        reportedItem: widget.itemId,
        itemType: widget.itemType,
        reason: widget.selectedReasonId,
        comment: commentController.text,
      );
      await apiService.submitReport(report).then((value) {
        log("itemId: ${widget.itemId}, itemType: ${widget.itemType}, selectedReasonId: ${widget.selectedReasonId},");
        Get.back(closeOverlays: true);
        log("Report submitted successfully");
        Get.snackbar('Success', 'Report submitted successfully');
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit report');
      Get.back(closeOverlays: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Report',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Anything else we should know?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: commentController,
            maxLength: 200,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Please elaborate...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              onPressed: submitReport,
              text: "Submit",
            ),
          ),
        ],
      ),
    );
  }
}
