// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'dart:developer';
import 'dart:io';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:experta/data/models/transaction_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final ApiService apiService = ApiService();
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  String searchQuery = '';
  List<String> selectedStatuses = [];
  List<String> selectedPaymentTypes = [];
  List<String> selectedMonths = [];

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _fetchTransactions();
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        log('Storage permission granted');
      } else {
        log(result.isPermanentlyDenied
            ? 'Storage permission is permanently denied. Please enable it in settings.'
            : 'Storage permission denied');
      }
    } else if (status.isGranted) {
      log('Storage permission already granted');
    }
  }

  Future<void> _fetchTransactions() async {
    try {
      final fetchedTransactions = await apiService.fetchTransactionHistory();
      log('Fetched Transactions: $fetchedTransactions');
      setState(() {
        transactions = fetchedTransactions;
        filteredTransactions = fetchedTransactions;
      });
    } catch (e) {
      log('Error fetching transactions: $e');
    }
  }

  void _filterTransactions() {
    setState(() {
      filteredTransactions = transactions.where((transaction) {
        // Check if the transaction matches the search query
        final matchesSearchQuery = transaction.type
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (transaction.description
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false);

        // Check if the transaction matches the selected date range
        final matchesDateRange = (_selectedFromDate == null ||
                transaction.createdAt.isAfter(_selectedFromDate!)) &&
            (_selectedToDate == null ||
                transaction.createdAt
                    .isBefore(_selectedToDate!.add(const Duration(days: 1))));

        // Check if the transaction matches the selected statuses
        final matchesStatus = selectedStatuses.isEmpty ||
            selectedStatuses.contains(transaction.status.toLowerCase());

        // Check if the transaction matches the selected payment types
        final matchesPaymentType = selectedPaymentTypes.isEmpty ||
            selectedPaymentTypes.contains(transaction.type.toLowerCase());

        // Check month
        final createdMonth =
            DateFormat('MMMM \'yy').format(transaction.createdAt);
        final matchesPaymentMonth =
            selectedMonths.isEmpty || selectedMonths.contains(createdMonth);

        return matchesSearchQuery &&
            matchesDateRange &&
            matchesStatus &&
            matchesPaymentType &&
            matchesPaymentMonth;
      }).toList();
    });
  }

  Future<void> _downloadExcel() async {
    if (await Permission.manageExternalStorage.request().isGranted ||
        await Permission.storage.request().isGranted) {
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      // Define styles
      final xlsio.Style headerStyle = workbook.styles.add('headerStyle');
      headerStyle.bold = true;
      headerStyle.hAlign = xlsio.HAlignType.center;
      headerStyle.vAlign = xlsio.VAlignType.center;
      headerStyle.fontName = 'Calibri';

      final xlsio.Style dataCellStyle = workbook.styles.add('dataCellStyle');
      dataCellStyle.hAlign = xlsio.HAlignType.center;
      dataCellStyle.vAlign = xlsio.VAlignType.center;

      // Define headers
      final headerRow = [
        'Transaction ID',
        'Type',
        'Amount',
        'Status',
        'Description',
        'Payment Method',
        'Created At',
        'Sender ID',
        'Receiver ID',
        'Booking Type',
        'Booking Status'
      ];

      // Apply headers
      for (int col = 0; col < headerRow.length; col++) {
        final cell = sheet.getRangeByIndex(1, col + 1);
        cell.setText(headerRow[col]);
        cell.cellStyle = headerStyle;
      }

      // Fill data rows
      for (int row = 0; row < filteredTransactions.length; row++) {
        var transaction = filteredTransactions[row];
        var rowData = [
          transaction.id,
          transaction.type,
          "₹${transaction.amount}",
          transaction.status,
          transaction.description ?? '',
          transaction.paymentMethod ?? '',
          DateFormat('yyyy-MM-dd HH:mm').format(transaction.createdAt),
          transaction.sender?.id ?? '',
          transaction.receiver?.id ?? '',
          transaction.relatedBooking?.type ?? '',
          transaction.relatedBooking?.status ?? ''
        ];

        for (int col = 0; col < rowData.length; col++) {
          final cell = sheet.getRangeByIndex(row + 2, col + 1);
          cell.setText(rowData[col].toString());
          cell.cellStyle = dataCellStyle;
        }
      }

      // Auto-fit columns
      for (int i = 1; i <= headerRow.length; i++) {
        sheet.autoFitColumn(i);
      }

      // Save the workbook
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      // Create directory if it doesn't exist
      final Directory downloadsDirectory =
          Directory('/storage/emulated/0/Download/MyExcelFiles');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      // Generate file path with timestamp
      final filePath =
          '${downloadsDirectory.path}/transactions_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Show notification
      await _showDownloadNotification(filePath);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file downloaded to $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to download the file'),
        ),
      );
    }
  }

  Future<void> _showDownloadNotification(String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      channelDescription: 'Notification for completed downloads',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: 'ic_notification',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'Your Excel file has been saved to $filePath',
      platformChannelSpecifics,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchView(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterTransactions();
                });
              },
              hintText: 'Search transactions',
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
                builder: (BuildContext context) {
                  // Return a StatefulBuilder to maintain state
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.85,
                        maxChildSize: 0.85,
                        minChildSize: 0.3,
                        builder: (context, scrollController) {
                          return _buildFilterSheet(
                            scrollController,
                            transactions,
                            setModalState, // Pass the setState function
                          );
                        },
                      );
                    },
                  );
                },
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Transaction History"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CustomImageView(
            height: 18,
            width: 18,
            imagePath: ImageConstant.excel,
            onTap: _downloadExcel,
          ),
        )
      ],
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    String formattedTime = DateFormat('hh:mm a').format(transaction.createdAt);
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    String displayText;
    if (transaction.createdAt.year == today.year &&
        transaction.createdAt.month == today.month &&
        transaction.createdAt.day == today.day) {
      displayText = 'Today, $formattedTime';
    } else if (transaction.createdAt.year == yesterday.year &&
        transaction.createdAt.month == yesterday.month &&
        transaction.createdAt.day == yesterday.day) {
      displayText = 'Yesterday, $formattedTime';
    } else {
      String formattedDate =
          DateFormat('MMM dd, yyyy').format(transaction.createdAt);
      displayText = '$formattedDate, $formattedTime';
    }

    // Determine transaction type icon
    String transactionIcon;
    if (transaction.type == 'deposit') {
      transactionIcon = ImageConstant.topup;
    } else if (transaction.type == 'booking_payment') {
      transactionIcon = ImageConstant.transact;
    } else if (transaction.type == 'refund') {
      transactionIcon = ImageConstant.deposit;
    } else {
      transactionIcon = ImageConstant.transact;
    }

    // Format transaction type display text
    String typeDisplayText;
    switch (transaction.type) {
      case 'deposit':
        typeDisplayText = 'Top up';
        break;
      case 'booking_payment':
        typeDisplayText = 'Booking Payment';
        break;
      case 'refund':
        typeDisplayText = 'Refund';
        break;
      default:
        typeDisplayText = transaction.type;
    }

    return ListTile(
      leading: CustomIconButton(
        height: 44.adaptSize,
        width: 44.adaptSize,
        padding: EdgeInsets.all(10.h),
        decoration: IconButtonStyleHelper.outline2,
        child: CustomImageView(imagePath: transactionIcon),
      ),
      title: Text(
        typeDisplayText,
        style: CustomTextStyles.labelLargeSFProTextBlack90001,
      ),
      subtitle: Text(
        displayText,
        style: CustomTextStyles.labelLargeBluegray300Medium,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: transaction.type == 'refund'
                      ? '+ '
                      : transaction.type == 'deposit'
                          ? '+ '
                          : '- ',
                  style: TextStyle(
                    color: transaction.type == 'refund' ||
                            transaction.type == 'deposit'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "₹${transaction.amount}",
                  style: CustomTextStyles.labelLargeSFProTextBlack90001,
                ),
              ],
            ),
          ),
          Text(
            transaction.status.capitalize ?? transaction.status,
            style: TextStyle(
              color: transaction.status == 'completed'
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(
      List<Transaction> transactions) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<Transaction>> groupedTransactions = {
      'Today': [],
      'Yesterday': [],
      'Others': []
    };

    for (var transaction in transactions) {
      final transactionDate = DateTime(transaction.createdAt.year,
          transaction.createdAt.month, transaction.createdAt.day);

      if (transactionDate.year == today.year &&
          transactionDate.month == today.month &&
          transactionDate.day == today.day) {
        groupedTransactions['Today']!.add(transaction);
      } else if (transactionDate.year == yesterday.year &&
          transactionDate.month == yesterday.month &&
          transactionDate.day == yesterday.day) {
        groupedTransactions['Yesterday']!.add(transaction);
      } else {
        groupedTransactions['Others']!.add(transaction);
      }
    }

    return groupedTransactions;
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate(filteredTransactions);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _buildSearchBar(),
          Expanded(
            child: ListView(
              children: [
                if (groupedTransactions['Today']!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('TODAY',
                        style: CustomTextStyles.bodySmallBluegray300),
                  ),
                  ...groupedTransactions['Today']!
                      .map(_buildTransactionTile)
                      .toList(),
                ],
                if (groupedTransactions['Yesterday']!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('YESTERDAY',
                        style: CustomTextStyles.bodySmallBluegray300),
                  ),
                  ...groupedTransactions['Yesterday']!
                      .map(_buildTransactionTile)
                      .toList(),
                ],
                if (groupedTransactions['Others']!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('OTHERS',
                        style: CustomTextStyles.bodySmallBluegray300),
                  ),
                  ...groupedTransactions['Others']!
                      .map(_buildTransactionTile)
                      .toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  Widget _buildFilterSheet(ScrollController scrollController,
      List<Transaction> transactions, StateSetter setModalState) {
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.filtercross,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: ['completed', 'pending', 'failed'].map((status) {
                return FilterChip(
                  label: Text(
                    status == 'completed' ? 'Successful' : status,
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: appTheme.black90001,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  selected: selectedStatuses.contains(status),
                  onSelected: (bool value) {
                    setModalState(() {
                      if (value) {
                        selectedStatuses.add(status);
                      } else {
                        selectedStatuses.remove(status);
                      }
                    });
                    setState(() {
                      _filterTransactions();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.white,
                  side: BorderSide(
                    color: selectedStatuses.contains(status)
                        ? theme.primaryColor
                        : appTheme.gray100,
                    width: 1.0,
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: ['deposit', 'booking_payment', 'refund'].map((type) {
                String displayText;
                switch (type) {
                  case 'deposit':
                    displayText = 'Top up';
                    break;
                  case 'booking_payment':
                    displayText = 'Booking Payment';
                    break;
                  case 'refund':
                    displayText = 'Refund';
                    break;
                  default:
                    displayText = type;
                }
                return FilterChip(
                  label: Text(
                    displayText,
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: appTheme.black90001,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  selected: selectedPaymentTypes.contains(type),
                  onSelected: (bool value) {
                    setModalState(() {
                      if (value) {
                        selectedPaymentTypes.add(type);
                      } else {
                        selectedPaymentTypes.remove(type);
                      }
                    });
                    setState(() {
                      _filterTransactions();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.white,
                  side: BorderSide(
                    color: selectedPaymentTypes.contains(type)
                        ? theme.primaryColor
                        : appTheme.gray100,
                    width: 1.0,
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Months',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _generateMonths().map((month) {
                return FilterChip(
                  label: Text(
                    month,
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: appTheme.black90001,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  selected: selectedMonths.contains(month),
                  onSelected: (bool value) {
                    setModalState(() {
                      if (value) {
                        selectedMonths.add(month);
                      } else {
                        selectedMonths.remove(month);
                      }
                    });
                    setState(() {
                      _filterTransactions();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.white,
                  side: BorderSide(
                    color: selectedMonths.contains(month)
                        ? theme.primaryColor
                        : appTheme.gray100,
                    width: 1.0,
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            const Text(
              'Filter by Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked =
                          await _selectDate(context, false);
                      if (picked != null) {
                        setModalState(() {
                          _selectedFromDate = picked;
                        });
                        setState(() {
                          _filterTransactions();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: appTheme.gray200),
                          borderRadius: BorderRadius.circular(13)),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedFromDate != null
                                ? DateFormat.yMMMd().format(_selectedFromDate!)
                                : 'From',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: appTheme.black90001,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgCalendar,
                            color: appTheme.blueGray300,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await _selectDate(context, true);
                      if (picked != null) {
                        setModalState(() {
                          _selectedToDate = picked;
                        });
                        setState(() {
                          _filterTransactions();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: appTheme.gray200),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedToDate != null
                                ? DateFormat.yMMMd().format(_selectedToDate!)
                                : 'To',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: appTheme.black90001,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgCalendar,
                            color: appTheme.blueGray300,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  onPressed: () {
                    setModalState(() {
                      selectedStatuses.clear();
                      selectedPaymentTypes.clear();
                      selectedMonths.clear();
                      _selectedFromDate = null;
                      _selectedToDate = null;
                      searchQuery = '';
                    });
                    setState(() {
                      _filterTransactions();
                    });
                  },
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: appTheme.gray200),
                    ),
                  ),
                  text: 'Clear All',
                ),
                CustomElevatedButton(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  text: 'Apply',
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  List<String> _generateMonths() {
    final currentYear = DateTime.now().year;
    return List.generate(12, (index) {
      final month = DateTime(currentYear, index + 1);
      return DateFormat('MMMM \'yy').format(month);
    });
  }

  Future<DateTime?> _selectDate(BuildContext context, bool isToDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isToDate) {
          _selectedToDate = picked;
        } else {
          _selectedFromDate = picked;
        }
        _filterTransactions();
      });
    }

    return picked;
  }
}
