import 'package:experta/core/app_export.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingPage extends StatefulWidget {
  final String bookingId;
  final String userName;
  final String profilePic;
  const RatingPage(
      {super.key,
      required this.bookingId,
      required this.userName,
      required this.profilePic});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _textFieldHeight = 150.0;
  int _selectedRating = 0; // State variable for selected rating
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitRating() async {
    final url = Uri.parse('http://3.110.252.174:8080/api/video-rating');
    final body = jsonEncode({
      "bookingId": "6728c79404d87083dbd5b371",
      "rating": _selectedRating,
      "review": _reviewController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'failed') {
        _showErrorDialog(responseData['error']['errorMessage']);
      } else {
        _showSuccessDialog();
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Rating submitted successfully!'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give Rating'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomImageView(
              height: 40,
              width: 40,
              radius: BorderRadius.circular(20),
              imagePath: widget.profilePic,
            ),
            const SizedBox(height: 10),
            const Text(
              'How was your experience with',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              widget.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Stack(
                children: [
                  SizedBox(
                    height: _textFieldHeight,
                    child: TextField(
                      controller: _reviewController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: 'Write your experience',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _textFieldHeight += details.delta.dy;
                          if (_textFieldHeight < 100) {
                            _textFieldHeight = 100; // Minimum height
                          }
                        });
                      },
                      child: const Icon(
                        Icons.drag_handle,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _submitRating,
                child: const Text(
                  'Submit Rating',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
