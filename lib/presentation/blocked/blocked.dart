import 'package:experta/core/app_export.dart';

class BlockedPage extends StatelessWidget {
  // Sample list of users
  final List<Map<String, String>> users = [
    {'name': 'Anjali Arora', 'subtitle': 'Social Media Influencer', 'image': 'assets/anjali_arora.png'},
    {'name': 'Taranvir Kaur', 'subtitle': 'Social Media Influencer', 'image': 'assets/taranvir_kaur.png'},
    {'name': 'Supreet Kaur', 'subtitle': 'Social Media Influencer', 'image': 'assets/supreet_kaur.png'},
    {'name': 'Priya Sangar', 'subtitle': 'Social Media Influencer', 'image': 'assets/priya_sangar.png'},
    {'name': 'Kamya Arora', 'subtitle': 'Social Media Influencer', 'image': 'assets/kamya_arora.png'},
    {'name': 'Divya Virmani', 'subtitle': 'Social Media Influencer', 'image': 'assets/divya_virmani.png'},
    {'name': 'Aachal Sharma', 'subtitle': 'Social Media Influencer', 'image': 'assets/aachal_sharma.png'},
  ];

  BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Navigate back to the settings page
          },
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomSearchView(
              hintText: 'Search user',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserTile(
                  name: user['name']!,
                  subtitle: user['subtitle']!,
                  image: user['image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String image;

  const UserTile({
    super.key, 
    required this.name,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(image),
      ),
      title: Row(
        children: [
          Text(name),
          const SizedBox(width: 4),
          const Icon(Icons.verified, color: Colors.blue, size: 16), // For the verified icon
        ],
      ),
      subtitle: Text(subtitle),
      trailing: ElevatedButton(
        onPressed: () {
          // Handle unblock action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(color: Colors.black),
          ),
          fixedSize: const Size(100, 36), // Fixed width and height
        ),
        child: const Text('Unblock'),
      ),
    );
  }
}
