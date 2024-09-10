import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<String> messages;

  ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {}
