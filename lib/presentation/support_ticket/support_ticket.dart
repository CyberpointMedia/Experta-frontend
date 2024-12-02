import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_elevated_button.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  bool isActiveSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background blur effect
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
                sigmaX: 60,
                sigmaY: 60,
              ),
              child: Align(
                child: SizedBox(
                  width: 252,
                  height: 252,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(126),
                      color: appTheme.deepOrangeA20.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildAppBar(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Tab selector
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffe4e4e4)),
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          _buildTab(true, 'Active Tickets'),
                          _buildTab(false, 'Closed Tickets'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Ticket list
                    Expanded(
                      child: _buildTicketList(active: isActiveSelected),
                    ),
                  ],
                ),
              ),
              // Raise Ticket Button
              CustomElevatedButton(
                text: "Raise Ticket",
                onPressed: () {
                  // Handle raise ticket action
                },
                margin: const EdgeInsets.all(16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 56.v,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          Get.back();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Support"),
    );
  }

  Widget _buildTab(bool isActive, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isActiveSelected = isActive),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: (isActiveSelected == isActive) ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: (isActiveSelected == isActive) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketList({required bool active}) {
    List<Map<String, String>> tickets = active
        ? [
            {
              "title": "Payment Not Processed",
              "ticketId": "#TK-421",
              "date": "Oct, 20, 2024",
              "status": "Active",
              "statusColor": "orange",
            },
          ]
        : [
            {
              "title": "Refund Processed",
              "ticketId": "#TK-422",
              "date": "Oct, 15, 2024",
              "status": "Closed",
              "statusColor": "green",
            },
          ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _buildTicketCard(
          title: ticket["title"]!,
          ticketId: ticket["ticketId"]!,
          date: ticket["date"]!,
          status: ticket["status"]!,
          statusColor: ticket["statusColor"]!,
        );
      },
    );
  }

  Widget _buildTicketCard({
    required String title,
    required String ticketId,
    required String date,
    required String status,
    required String statusColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ticket ID : $ticketId | Created date: $date",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 16,
                        color: _getStatusColor(statusColor),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _getStatusColor(statusColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, 
                size: 16, 
                color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

 Color _getStatusColor(String statusColor) {
    switch (statusColor) {
      case "orange":
        return Colors.orange;
      case "green":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
