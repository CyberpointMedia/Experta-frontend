import 'dart:async';
import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:connectivity_plus/connectivity_plus.dart';

class SocketService with ChangeNotifier {
  late IO.Socket socket;
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> filteredChats = [];
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> unsentMessages = [];
  final Set<String> onlineUsers = {};
  bool isConnected = false;
  late final StreamSubscription<ConnectivityResult> connectivitySubscription;
  final String? currentUserId = PrefUtils().getaddress();
  String? currentChatId;

  SocketService() {
    initializeSocket();
    monitorConnectivity();
  }

  // Initialize socket connection and set up listeners
  void initializeSocket() {
    socket = IO.io(
        'http://3.110.252.174:8080',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();

    socket.on('connect', (_) {
      log('Connected to socket');
      isConnected = true;
      notifyListeners();
      if (currentUserId != null) {
        socket.emit('init_user', currentUserId);
      }
    });

    socket.on('disconnect', (_) {
      log('Disconnected from socket');
      isConnected = false;
      notifyListeners();
    });

    socket.on('reconnect_attempt', (_) => log('Reconnecting...'));
    socket.on('reconnect_failed', (_) => log('Reconnection failed'));

    // Socket events
    socket.on('chats_fetched', (data) {
      log('Chats fetched: $data');
      chats = List<Map<String, dynamic>>.from(data);
      filteredChats = chats;
      notifyListeners();
    });

    socket.on('chat_list_updated', (newChat) {
      log('Chat list updated: $newChat');
      final chat = Map<String, dynamic>.from(newChat);

      // Check for duplicate before inserting
      final existingChatIndex =
          chats.indexWhere((chat) => chat['_id'] == newChat['_id']);
      if (existingChatIndex == -1) {
        chats.insert(0, chat);
      } else {
        chats[existingChatIndex] = chat; // Update the existing chat
      }

      filteredChats = chats;
      _updateMessageReadStatus(currentChatId.toString());
      notifyListeners();
    });

    socket.on('update_unread_count', (data) {
      log('Update unread count: $data');
      final chatId = data['chatId'];
      final unreadCount = data['unreadCount'];

      // Prevent redundant updates if the unread count is already accurate
      final chatIndex = chats.indexWhere((chat) => chat['_id'] == chatId);
      if (chatIndex != -1 && chats[chatIndex]['unreadCounts'] != unreadCount) {
        _updateUnreadCount(chatId, unreadCount);
      }
    });

    socket.on('messages_marked_read', (data) {
      log('Messages marked read: $data');
      final chatId = currentChatId;
      final userId = data['sender']['_id'];
      if (userId != currentUserId) {
        _updateMessageReadStatus(chatId.toString());
      }
    });

    socket.on('messages_marked_read', (data) {
      final chatId = data['chatId'];
      if (chatId == currentChatId) {
        log('Messages marked read: $data');
        final userId = data['sender']['_id'];
        if (userId != currentUserId) {
          _updateMessageReadStatus(chatId.toString());
        }
      }
    });

    socket.on('getUserOnline', (userId) {
      log('User online: $userId');
      onlineUsers.add(userId);
      notifyListeners();
    });

    socket.on('getUserOffline', (userId) {
      log('User offline: $userId');
      onlineUsers.remove(userId);
      notifyListeners();
    });

    // Fetch chats initially
    if (currentUserId != null) {
      socket.emit('fetch_chats', currentUserId);
    }
  }

  void handleChatTap(String chatId) {
    log('Chat tapped: $chatId');
    currentChatId = chatId;
  }

  void monitorConnectivity() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      isConnected = result != ConnectivityResult.none;
      if (isConnected) {
        fetchMessages();
        resendUnsentMessages();
      }
    });
  }

  Future<void> fetchMessages() async {
    if (currentUserId != null) {
      try {
        final fetchedMessages =
            await ApiService().fetchMessages(currentChatId!);
        messages.clear();
        messages.addAll(fetchedMessages);
        notifyListeners();
      } catch (error) {
        log('Error fetching messages: $error');
      }
    }
  }

  void markMessagesAsRead() {
    if (currentChatId != null) {
      // Emit an event to mark the message as read only once
      socket.emit('mark_messages_read', {
        'chatId': currentChatId,
        'userId': currentUserId,
      });

      // Also update the unread count locally
      _updateUnreadCount(currentChatId!, 0);
      _updateMessageReadStatus(currentChatId!);
    }
  }

  void sendMessage(String content) async {
    if (content.trim().isEmpty || currentChatId == null) return;

    final newMsg = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': content,
      'createdAt': DateTime.now().toUtc().toString(),
      'sender': {'_id': currentUserId},
      'readBy': [currentUserId],
      'status': 'pending'
    };

    messages.insert(0, newMsg);
    notifyListeners();

    if (isConnected) {
      try {
        final sentMsg = await ApiService().sendMessage(content, currentChatId!);
        sentMsg['status'] = 'sent';
        updateMessageStatus(newMsg['id'].toString(), sentMsg);
        socket.emit('new_msg_sent', sentMsg);
        await fetchMessages(); // Fetch messages from API after sending (optimize here if needed)
      } catch (error) {
        log('Error sending message: $error');
        unsentMessages.add(newMsg);
      }
    } else {
      unsentMessages.add(newMsg);
    }
  }

  void updateMessageStatus(String messageId, Map<String, dynamic> updatedMsg) {
    final index = messages.indexWhere((msg) => msg['id'] == messageId);
    if (index != -1) {
      messages[index] = updatedMsg;
      notifyListeners();
    }
  }

  void resendUnsentMessages() async {
    if (unsentMessages.isEmpty || currentChatId == null) return;

    final List<Map<String, dynamic>> successfullySent = [];
    for (var msg in unsentMessages) {
      try {
        final sentMsg = await ApiService().sendMessage(
          msg['content'],
          currentChatId!,
        );
        sentMsg['status'] = 'sent';
        updateMessageStatus(msg['id'], sentMsg);
        socket.emit('new_msg_sent', sentMsg);
        successfullySent.add(msg);
        await fetchMessages(); // Fetch messages from API after resending
      } catch (error) {
        log('Error resending message: $error');
      }
    }

    unsentMessages.removeWhere((msg) => successfullySent.contains(msg));
    notifyListeners();
  }

  void reconnectSocket() {
    if (!isConnected) {
      log('Attempting to reconnect to socket...');
      socket.connect();
    } else {
      log('Socket is already connected.');
    }
  }

  void _updateMessageReadStatus(String chatId) {
    bool hasUpdates = false;
    messages = messages.map((msg) {
      if (msg['chat'] == chatId && !msg['readBy'].contains(currentUserId)) {
        msg['readBy'].add(currentUserId);
        hasUpdates = true;
      }
      return msg;
    }).toList();
    if (hasUpdates) {
      notifyListeners();
    }
  }

  void _updateUnreadCount(String chatId, int unreadCount) {
    final chatIndex = chats.indexWhere((chat) => chat['_id'] == chatId);
    if (chatIndex != -1 && chats[chatIndex]['unreadCounts'] != unreadCount) {
      chats[chatIndex]['unreadCounts'] = unreadCount;
      filteredChats = chats;
      notifyListeners();
    }
  }

  void disposeSocket() {
    socket.dispose();
    connectivitySubscription.cancel();
  }
}
