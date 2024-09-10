import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'bloc_event.dart';
import 'bloc_staate.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WebSocketChannel channel;

  ChatBloc(this.channel) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<LoadMessagesEvent>(_onLoadMessages);

    channel.stream.listen((message) {
      add(MessageReceivedEvent(message));
    });
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) {
    channel.sink.add(event.message);
    if (state is ChatLoaded) {
      final updatedMessages = List<String>.from((state as ChatLoaded).messages)
        ..add("You: ${event.message}");
      emit(ChatLoaded(updatedMessages));
    }
  }

  void _onMessageReceived(MessageReceivedEvent event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final updatedMessages = List<String>.from((state as ChatLoaded).messages)
        ..add(event.message);
      emit(ChatLoaded(updatedMessages));
    }
  }

  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    // Here you would normally load messages from a local database or backend
    // For simplicity, we'll just start with an empty list
    emit(ChatLoaded([]));
  }

  @override
  Future<void> close() {
    channel.sink.close();
    return super.close();
  }
}
