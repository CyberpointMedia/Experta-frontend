import 'dart:developer';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/socket_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/database_helper/database_helper.dart';
import 'widgets/appbar.dart';
import 'widgets/message_input.dart';
import 'widgets/message_list.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late final Map<String, dynamic> chat;
  late final ChatRoomSocketService _socketService;
  late final ApiService apiServices;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    chat = Get.arguments['chat'] ?? {};
    apiServices = ApiService();

    // Initializing the socket service and setting up listeners
    _socketService = Provider.of<ChatRoomSocketService>(context, listen: false);
    _socketService.initUser(chat['_id']);
    _socketService.onNewMessageReceived(_onNewMessageReceived);
    _socketService.onMessagesMarkedRead(_onMessagesMarkedRead);

    // Fetch initial messages
    if (chat.isNotEmpty) {
      fetchMessages();
    }
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _socketService.offChatRoomListeners();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    if (isFetching) return; // Prevent multiple fetches
    isFetching = true;
    log("Fetching messages...");

    try {
      final fetchedMessages = await apiServices.fetchMessages("${chat['_id']}");
      log("API response: $fetchedMessages");

      // Perform database operations asynchronously
      for (var message in fetchedMessages) {
        await DatabaseHelper().insertMessage(message);
      }

      if (mounted) {
        setState(() {
          _socketService.messages.clear();
          _socketService.messages.addAll(fetchedMessages);
        });
      }
    } catch (error) {
      log('Error fetching messages: $error');

      // Fallback to local database messages in case of an error
      final localMessages =
          await DatabaseHelper().fetchMessages("${chat['_id']}");
      if (mounted) {
        setState(() {
          _socketService.messages.clear();
          _socketService.messages.addAll(localMessages);
        });
      }
    } finally {
      isFetching = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      _socketService.sendMessage(content);

      // Clear the input after sending
      _messageController.clear();

      // Scroll to the bottom after sending
      _scrollToBottom();
    }
  }

  // Handle incoming new messages
  void _onNewMessageReceived(data) {
    if (mounted) {
      setState(() {
        _socketService.messages.add(data);
      });
      _scrollToBottom();
    }
  }

  // Handle messages marked as read
  void _onMessagesMarkedRead(data) {
    log("Messages marked as read: $data");
    if (mounted) {
      setState(() {});
    }
  }

  String convertToIST(String utcTime) {
    final utcDateTime = DateTime.parse(utcTime).toUtc();
    final istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('d MMMM yyyy').format(istDateTime);
  }

  String convertToISTs(String utcTime) {
    final utcDateTime = DateTime.parse(utcTime).toUtc();
    final istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('hh:mm a').format(istDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = (chat['users'] is List)
        ? chat['users']?.firstWhere(
            (u) => u['_id'] != _socketService.currentUserId,
            orElse: () => null)
        : null;

    final basicInfo = otherUser?['basicInfo'];
    final displayName = basicInfo?['firstName'] ?? 'Unknown';

    final groupedMessages = <String, List<Map<String, dynamic>>>{};
    for (var message in _socketService.messages) {
      final date = convertToIST(message['createdAt']);
      groupedMessages.putIfAbsent(date, () => []).add(message);
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: ChatAppBar(
          displayName: displayName,
          isConnected: _socketService.isConnected,
          onTapArrowLeft: onTapArrowLeft,
          onTapThreeThousand: onTapThreeThousand,
          onTapVideo: onTapVideo,
          onTapPhone: onTapPhone,
        ),
        body: Stack(
          children: [
            Positioned(
              left: 270,
              top: 50,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
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
                Expanded(
                  child: _socketService.messages.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : MessageList(
                          groupedMessages: groupedMessages,
                          convertToISTs: convertToISTs,
                          buildFrame: _buildFrame,
                          currentUserId:
                              _socketService.currentUserId.toString(),
                        ),
                ),
                MessageInput(
                  messageController: _messageController,
                  sendMessage: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onTapArrowLeft() {
    Navigator.pop(context);
  }

  void onTapThreeThousand() {
    // Handle custom button tap
  }

  void onTapVideo() {
    // Handle video call button tap
  }

  void onTapPhone() {
    // Handle phone call button tap
  }

  Widget _buildFrame({required String time, required List<dynamic> readBy}) {
    log("the message is getting marked");
    final otherUserId = chat['users']?.firstWhere(
        (u) => u['_id'] != _socketService.currentUserId,
        orElse: () => null)?['_id'];

    bool isReadByBoth = readBy.contains(_socketService.currentUserId) &&
        readBy.contains(otherUserId);
    log(" is read by $readBy");
    return Row(
      children: [
        Text(
          time,
          style: CustomTextStyles.bodySmallBluegray300,
        ),
        if (isReadByBoth)
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Icon(
              Icons.done_all,
              size: 16.adaptSize,
              color: Colors.blue,
            ),
          )
        else if (readBy.contains(_socketService.currentUserId))
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Icon(
              Icons.done,
              size: 16.adaptSize,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
