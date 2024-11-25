import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Support"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: "Active Tickets"),
                  Tab(text: "Closed Tickets"),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  // Active Tickets Tab
                  _buildTicketList(active: true),
                  // Closed Tickets Tab
                  _buildTicketList(active: false),
                ],
              ),
            ),
            // Raise Ticket Button
            CustomElevatedButton(
            text: "Raise Ticket",
            onPressed: () {},
            margin: const EdgeInsets.all(10),
          )
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // Handle "Raise Ticket" action
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.yellow[700],
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         padding: const EdgeInsets.symmetric(vertical: 16),
            //       ),
            //       child: const Text(
            //         "Raise Ticket",
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          
          ],
        ),
      ),
    );
  }

  // Method to Build Ticket List Based on Status (Active or Closed)
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
      padding: const EdgeInsets.all(16.0),
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

  // Method to Build Ticket Card
  Widget _buildTicketCard({
    required String title,
    required String ticketId,
    required String date,
    required String status,
    required String statusColor,
  }) {
    return Card(
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ticket ID : $ticketId | Created date: $date",
                    style: const TextStyle(
                      fontSize: 14,
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
                        style: TextStyle(
                          fontSize: 14,
                          color: _getStatusColor(statusColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Helper Method to Get Status Color
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
