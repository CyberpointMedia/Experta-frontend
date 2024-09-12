import 'dart:ui';
import 'package:experta/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class RecordedSessionsPage extends StatefulWidget {
  const RecordedSessionsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordedSessionsPageState createState() => _RecordedSessionsPageState();
}

class _RecordedSessionsPageState extends State<RecordedSessionsPage> {
  // Sessions list (state)
  List<Map<String, dynamic>> sessions = [
    {
      'imageUrl': 'https://via.placeholder.com/80',
      'name': 'Anjali Arora',
      'title': 'Social Media Influencer',
      'date': 'Tue, 2 Jan 2024',
      'time': '10:30',
      'hasPlayButton': true,
    },
    {
      'imageUrl': 'https://via.placeholder.com/80',
      'name': 'Taranvir Kaur',
      'title': 'Social Media Influencer',
      'date': 'Tue, 2 Jan 2024',
      'time': '10:30',
      'hasPlayButton': true,
    },
    {
      'imageUrl': 'https://via.placeholder.com/80',
      'name': 'Dinesh Verma',
      'title': 'Social Media Influencer',
      'date': 'Tue, 2 Jan 2024',
      'time': '10:30',
      'hasPlayButton': true,
    },
  ];

  // Function to handle session deletion
  void _deleteSession(int index) {
    setState(() {
      sessions.removeAt(index); // Remove session from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(context),
              Expanded(child: _buildRecordedSessionsList()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Recorded Sessions"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // Modified ListView builder with delete option in the PopupMenu
  Widget _buildRecordedSessionsList() {
    return ListView.builder(
      itemCount: sessions.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RecordedSessionTile(
            imageUrl: sessions[index]['imageUrl'],
            name: sessions[index]['name'],
            title: sessions[index]['title'],
            date: sessions[index]['date'],
            time: sessions[index]['time'],
            hasPlayButton: sessions[index]['hasPlayButton'],
            onDelete: () => _deleteSession(index), // Pass delete function
          ),
        );
      },
    );
  }
}

class RecordedSessionTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String title;
  final String date;
  final String time;
  final bool hasPlayButton;
  final VoidCallback onDelete;

  const RecordedSessionTile({
    required this.imageUrl,
    required this.name,
    required this.title,
    required this.date,
    required this.time,
    required this.hasPlayButton,
    required this.onDelete, // New delete callback
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                width: 80.0,
                height: 80.0,
                fit: BoxFit.cover,
              ),
            ),
            if (hasPlayButton)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white.withOpacity(0.7),
                    size: 40.0,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Text(
                    date,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Delete') {
              onDelete(); // Call delete function when "Delete" is selected
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'Delete',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduce vertical padding
                height: 30, // Reduce the overall height of the popup item
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 14.0, // Adjust font size for better visibility
                  ),
                ),
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert),
          padding: const EdgeInsets.all(4), // Removes any default padding
          offset: const Offset(0, 30), // Adjusts the popup position relative to the icon
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners for the popup menu
          ),
          elevation: 2.0, // Adds elevation for a better visual effect
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RecordedSessionsPage(),
  ));
}
