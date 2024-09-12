import 'dart:ui';
import 'package:experta/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for date formatting

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onTap;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final List<Map<String, dynamic>> transactions = [
    {
      'type': 'Transfer',
      'amount': -1350,
      'time': 'Today, 06:07 PM',
      'status': 'Success',
    },
    {
      'type': 'Receive',
      'amount': 1350,
      'time': 'Today, 06:07 PM',
      'status': 'Success',
    },
    {
      'type': 'Top up',
      'amount': 1350,
      'time': 'Today, 06:07 PM',
      'status': 'Success',
    },
    // Add more transactions here
  ];

  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isFromDate ? _selectedFromDate : _selectedToDate)) {
      setState(() {
        if (isFromDate) {
          _selectedFromDate = picked;
        } else {
          _selectedToDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Add download action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionTile(
                        transaction['type'],
                        transaction['amount'],
                        transaction['time'],
                        transaction['status'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search transaction',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.85, // Set initial size to 85%
                maxChildSize: 0.85, // Set max size to 85%
                minChildSize: 0.3,
                builder: (context, scrollController) {
                  return _buildFilterSheet(scrollController);
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.filter_list),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(String type, int amount, String time, String status) {
    return ListTile(
      leading: Icon(
        type == 'Transfer' ? Icons.call_made : type == 'Receive' ? Icons.call_received : Icons.account_balance_wallet,
        color: type == 'Transfer' ? Colors.red : Colors.green,
      ),
      title: Text(type),
      subtitle: Text(time),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${amount > 0 ? '+' : ''}$amount',
            style: TextStyle(
              color: amount > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            status,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

Widget _buildFilterSheet(ScrollController scrollController) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Filter Payments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
          Wrap(
            spacing: 8.0,
            children: ['Successful', 'Pending', 'Failed'].map((status) {
              return FilterChip(
                label: Text(status, style: const TextStyle(color: Colors.black)),
                onSelected: (bool value) {
                  // Handle filter action
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Payment Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
          Wrap(
            spacing: 8.0,
            children: ['Deposit', 'Received', 'Withdrawals'].map((type) {
              return FilterChip(
                label: Text(type, style: const TextStyle(color: Colors.black)),
                onSelected: (bool value) {
                  // Handle filter action
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Months', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
          Wrap(
            spacing: 8.0,
            children: [
              'January\' 24',
              'February\' 24',
              'March\' 24',
              'April\' 24',
              'May\' 24',
              'June\' 24',
              'July\' 24'
            ].map((month) {
              return FilterChip(
                label: Text(month, style: const TextStyle(color: Colors.black)),
                onSelected: (bool value) {
                  // Handle filter action
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Filter by Date Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: 'From',
                  controller: TextEditingController(
                    text: _selectedFromDate != null ? DateFormat.yMMMd().format(_selectedFromDate!) : '',
                  ),
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  hintText: 'To',
                  controller: TextEditingController(
                    text: _selectedToDate != null ? DateFormat.yMMMd().format(_selectedToDate!) : '',
                  ),
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          // Adding the SizedBox for padding before the buttons
          const SizedBox(height: 32),  // Add this line for spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle clear all action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black, // Changed text color to black
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(164, 56), // Set minimum size
                ),
                child: const Text('Clear All'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle apply action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(164, 56), // Set minimum size
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}

void main() {
  runApp(const MaterialApp(
    home: TransactionHistoryPage(),
  ));
}
