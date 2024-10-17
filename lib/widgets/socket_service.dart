// import 'dart:developer';

// import 'package:experta/core/app_export.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class InboxSocketService with ChangeNotifier {
//   late IO.Socket
//       socket; // Use 'late' since socket is initialized in the constructor
//   List<dynamic> chats = [];

//   InboxSocketService() {
//     socket = IO.io('http://3.110.252.174:8080', <String, dynamic>{
//       'transports': ['websocket'],
//     });
//   }

//   // Initialize the user on the socket
//   void initUser(String userId) {
//     socket.emit('init_user', userId);
//   }

//   // Fetch chats for the given user ID
//   void fetchChats(String userId) {
//     socket.emit('fetch_chats', userId);
//   }

//   // Set up a listener for when chats are fetched
//   void onChatsFetched(Function(dynamic) callback) {
//     socket.on('chats_fetched', (data) {
//       chats = List<Map<String, dynamic>>.from(data); // Store fetched chats
//       callback(data);
//     });
//   }

//   // Set up a listener for chat list updates
//   void onChatListUpdated(Function(dynamic) callback) {
//     socket.on('chat_list_updated', (data) => callback(data));
//   }

//   // Set up a listener for unread count updates
//   void onUpdateUnreadCount(Function(dynamic) callback) {
//     socket.on('update_unread_count', (data) => callback(data));
//   }

//   // Set up a listener for when a user comes online
//   void onUserOnline(Function(dynamic) callback) {
//     socket.on('getUserOnline', (data) => callback(data));
//   }

//   // Set up a listener for when a user goes offline
//   void onUserOffline(Function(dynamic) callback) {
//     socket.on('getUserOffline', (data) => callback(data));
//   }

//   // Remove listeners for inbox-related events
//   void offInboxListeners() {
//     socket.off('chats_fetched');
//     socket.off('chat_list_updated');
//     socket.off('update_unread_count');
//     socket.off('getUserOnline');
//     socket.off('getUserOffline');
//   }
// }

// // next socket

// class ChatRoomSocketService with ChangeNotifier {
//   late IO.Socket socket;
//   bool isConnected = false;
//   // Add the messages list and currentUserId field
//   List<Map<String, dynamic>> messages = [];
//   String? currentChatId;
//   List<Map<String, dynamic>> unsentMessages = [];
//   final String? currentUserId = PrefUtils().getaddress();
//   ChatRoomSocketService() {
//     socket = IO.io('http://3.110.252.174:8080', <String, dynamic>{
//       'transports': ['websocket'],
//     });
//   }

//   void initUser(String currentChatId) {
//     // Set currentUserId when user is initialized
//     currentChatId = currentChatId;
//     socket.emit('init_user', currentUserId);
//     isConnected = true;
//   }

//   void markMessagesAsRead(String chatId, String userId) {
//     socket.emit('mark_messages_read', {'chatId': chatId, 'userId': userId});
//   }

//   void onNewMessageReceived(Function callback) {
//     socket.on('new_msg_received', (data) {
//       // Add the new message to the messages list
//       messages.add(data);
//       callback(data);
//     });
//   }

//   void onUpdateUnreadCount(Function callback) {
//     socket.on('update_unread_count', (data) => callback(data));
//   }

//   void onMessagesMarkedRead(Function callback) {
//     socket.on('messages_marked_read', (data) => callback(data));
//   }

//   void offChatRoomListeners() {
//     socket.off('new_msg_received');
//     socket.off('update_unread_count');
//     socket.off('messages_marked_read');
//   }

//   Future<void> fetchMessages() async {
//     if (currentUserId != null) {
//       try {
//         final fetchedMessages =
//             await ApiService().fetchMessages(currentChatId!);
//         messages.clear();
//         messages.addAll(fetchedMessages);
//         notifyListeners();
//       } catch (error) {
//         log('Error fetching messages: $error');
//       }
//     }
//   }

//   // Method to send a message
//   void sendMessage(String content) async {
//     if (content.trim().isEmpty || currentChatId == null) return;

//     final newMsg = {
//       'id': DateTime.now().millisecondsSinceEpoch.toString(),
//       'content': content,
//       'createdAt': DateTime.now().toUtc().toString(),
//       'sender': {'_id': currentUserId},
//       'readBy': [currentUserId],
//       'status': 'pending'
//     };

//     messages.insert(0, newMsg);
//     notifyListeners();

//     if (isConnected) {
//       try {
//         final sentMsg = await ApiService().sendMessage(content, currentChatId!);
//         sentMsg['status'] = 'sent';
//         updateMessageStatus(newMsg['id'].toString(), sentMsg);
//         socket.emit('new_msg_sent', sentMsg);
//         await fetchMessages(); // Fetch messages from API after sending (optimize here if needed)
//       } catch (error) {
//         log('Error sending message: $error');
//         unsentMessages.add(newMsg);
//       }
//     } else {
//       unsentMessages.add(newMsg);
//     }
//   }

//   void updateMessageStatus(String messageId, Map<String, dynamic> updatedMsg) {
//     final index = messages.indexWhere((msg) => msg['id'] == messageId);
//     if (index != -1) {
//       messages[index] = updatedMsg;
//       notifyListeners();
//     }
//   }

//   void resendUnsentMessages() async {
//     if (unsentMessages.isEmpty || currentChatId == null) return;

//     final List<Map<String, dynamic>> successfullySent = [];
//     for (var msg in unsentMessages) {
//       try {
//         final sentMsg = await ApiService().sendMessage(
//           msg['content'],
//           currentChatId!,
//         );
//         sentMsg['status'] = 'sent';
//         updateMessageStatus(msg['id'], sentMsg);
//         socket.emit('new_msg_sent', sentMsg);
//         successfullySent.add(msg);
//         await fetchMessages(); // Fetch messages from API after resending
//       } catch (error) {
//         log('Error resending message: $error');
//       }
//     }

//     unsentMessages.removeWhere((msg) => successfullySent.contains(msg));
//     notifyListeners();
//   }
// }
