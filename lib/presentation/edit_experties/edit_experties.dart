import 'package:flutter/material.dart';

class EditExpertisePage extends StatefulWidget {
  @override
  _EditExpertisePageState createState() => _EditExpertisePageState();
}

class _EditExpertisePageState extends State<EditExpertisePage> {
  // List of expertise
  List<String> expertise = [
    'Visual design',
    'web design',
    'Information architecture',
    'user research',
    'Interaction design',
    'mobile app design',
  ];

  // Method to delete expertise
  void _deleteExpertise(String item) {
    setState(() {
      expertise.remove(item);
    });
  }

  // Method to add new expertise
  void _addExpertise() {
    // Logic for adding a new expertise item
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expertise'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expertise',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Show your top expertise - add up to 5 skills you want to be known for. They'll also appear in your expertise section.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0, // Gap between chips
              runSpacing: 8.0, // Gap between rows
              children: expertise.map((skill) {
                return Chip(
                  label: Text(skill),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    _deleteExpertise(skill); // Delete skill
                  },
                  backgroundColor: Colors.grey[200],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _addExpertise,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          '+ Add Expertise',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  // Save button logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700], // Set button color
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
