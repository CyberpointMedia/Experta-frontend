import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_system/bloc_event.dart';
import 'bloc_system/bloc_staate.dart';
import 'bloc_system/chat_bloc.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Name'),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: state.messages[index].startsWith('You:')
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: state.messages[index].startsWith('You:')
                                ? Colors.yellow[700]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(state.messages[index]),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Failed to load messages'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.yellow[700]),
                  onPressed: () {
                    context
                        .read<ChatBloc>()
                        .add(SendMessageEvent(_controller.text));
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://example.com/user_avatar.png'), // Replace with actual image URL
                  ),
                  title: Text('User Name'),
                  subtitle: Text(state.messages[index]),
                  trailing: Text('Time'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('Failed to load messages'));
          }
        },
      ),
    );
  }
}
