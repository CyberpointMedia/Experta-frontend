import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class FollowersPage extends StatelessWidget {
  final List<Follower> followers = [
    Follower(
      name: 'Anjali Arora',
      profession: 'Social Media Influencer',
      isOnline: true,
      imageUrl: 'assets/images/Icon.svg',
    ),
    Follower(
      name: 'Taranvir Kaur',
      profession: 'Social Media Influencer',
      isOnline: false,
      imageUrl: 'assets/images/Icon.svg',
    ),
    // Add more followers here
  ];

  FollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: const Text('Followers'),
)
,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search followers',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  return FollowerTile(follower: followers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Follower {
  final String name;
  final String profession;
  final bool isOnline;
  final String imageUrl;

  Follower({
    required this.name,
    required this.profession,
    required this.isOnline,
    required this.imageUrl,
  });
}

class FollowerTile extends StatelessWidget {
  final Follower follower;

  const FollowerTile({super.key, required this.follower});

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          ClipOval(
            child: SizedBox(
              width: 40.0, // Adjust the size as needed
              height: 40.0,
              child: _isSvg(follower.imageUrl)
                  ? SvgPicture.asset(
                      follower.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      follower.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 6,
              backgroundColor: follower.isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      title: Text(follower.name),
      subtitle: Text(follower.profession),
      trailing: ElevatedButton(
        onPressed: () {
          // Add your remove function here
        },
        style: ElevatedButton.styleFrom(
          shape: const LinearBorder(),
          backgroundColor: Colors.white,
        ),
        child: const Text('Remove'),
      ),
    );
  }
}
