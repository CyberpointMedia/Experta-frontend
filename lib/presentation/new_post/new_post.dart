import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:experta/presentation/new_post/controller/new_post_controller.dart';

class NewPostPage extends StatelessWidget {
  final NewPostController newPostController = Get.put(NewPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('New post'),
        actions: [
          TextButton(
            onPressed: () {
              // Implement your share functionality here
            },
            child: const Text(
              'Share',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage('https://example.com/your_image.jpg'), // Replace with your profile image URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 5,
                        height: 5,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 5,
                        height: 5,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 5,
                        height: 5,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 5,
                        height: 5,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                // Implement your location selection logic here
              },
              child: const Row(
                children: [
                 
                  SizedBox(width: 5),
                  Text(
                    'Add location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Dark black color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
