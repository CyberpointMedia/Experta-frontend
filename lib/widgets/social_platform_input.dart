import 'package:experta/core/app_export.dart';

class SocialPlatformInput extends StatefulWidget {
  final String? initialPlatform;
  final String? initialLink;
  final Function(String, String)? onChanged;
  const SocialPlatformInput(
      {super.key, this.initialPlatform, this.initialLink, this.onChanged});

  @override
  State<SocialPlatformInput> createState() => _SocialPlatformInputState();
}

class _SocialPlatformInputState extends State<SocialPlatformInput> {
  String? selectedPlatform;
  final TextEditingController _linkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize with provided values
    if (widget.initialPlatform != null) {
      selectedPlatform = widget.initialPlatform;
    }
    if (widget.initialLink != null) {
      _linkController.text = widget.initialLink!;
    }
  }

  final List<Map<String, String>> platforms = [
    {
      "name": "Facebook",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/facebook.svg"
    },
    {
      "name": "Instagram",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/instagram.svg"
    },
    {
      "name": "Twitter (now X)",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/x.svg"
    },
    {
      "name": "Linkedin",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/linkedin.svg"
    },
    {
      "name": "Snapchat",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/snapchat.svg"
    },
    {
      "name": "Tiktok",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/tiktok.svg"
    },
    {
      "name": "Pinterest",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/pinterest.svg"
    },
    {
      "name": "Reddit",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/reddit.svg"
    },
    {
      "name": "Tumblr",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/tumblr.svg"
    },
    {
      "name": "Threads",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/threads.svg"
    },
    {
      "name": "Telegram",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/telegram.svg"
    },
    {
      "name": "Youtube",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/youtube.svg"
    },
    {
      "name": "Vimeo",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/vimeo.svg"
    },
    {
      "name": "Dailymotion",
      "icon":
          "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/dailymotion.svg"
    },
    {
      "name": "Twitch",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/twitch.svg"
    },
    {
      "name": "Rumble",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/rumble.svg"
    },
    {
      "name": "Meetup",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/meetup.svg"
    },
    {
      "name": "AngelList",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/angellist.svg"
    },
    {
      "name": "Medium",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/medium.svg"
    },
    {
      "name": "Substack",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/substack.svg"
    },
    {
      "name": "Wordpress",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/wordpress.svg"
    },
    {
      "name": "Blogger",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/blogger.svg"
    },
    {
      "name": "Quora",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/quora.svg"
    },
    {
      "name": "Goodreads",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/goodreads.svg"
    },
    {
      "name": "Strava",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/strava.svg"
    },
    {
      "name": "Behance",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/behance.svg"
    },
    {
      "name": "Dribbble",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/dribbble.svg"
    },
    {
      "name": "Steam Community",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/steam.svg"
    },
    {
      "name": "Roblox",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/roblox.svg"
    },
    {
      "name": "Second Life",
      "icon":
          "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/secondlife.svg"
    },
    {
      "name": "Flickr",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/flickr.svg"
    },
    {
      "name": "Deviantart",
      "icon":
          "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/deviantart.svg"
    },
    {
      "name": "Etsy Community",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/etsy.svg"
    },
    {
      "name": "Amazon Spark",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/amazon.svg"
    },
    {
      "name": "Github",
      "icon": "https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/amazon.svg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      ),
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: appTheme.gray300,
              ),
              padding: const EdgeInsets.only(left: 15.0, right: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: (selectedPlatform?.isEmpty ?? true)
                      ? null
                      : selectedPlatform,
                  hint: const Text(
                    'Select',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: platforms
                      .map((platform) => DropdownMenuItem<String>(
                            value: platform['name'],
                            child: Text(
                              platform['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlatform = value;
                      _linkController.clear();
                      if (widget.onChanged != null && value != null) {
                        widget.onChanged!(value, _linkController.text);
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 7,
            child: TextFormField(
              controller: _linkController,
              keyboardType: TextInputType.url,
              style: theme.textTheme.titleSmall!
                  .copyWith(color: appTheme.black900),
              decoration: InputDecoration(
                hintText: 'Add social url',
                hintStyle: theme.textTheme.titleSmall!
                    .copyWith(color: appTheme.black900),
                border: InputBorder.none,
              ),
              enabled: selectedPlatform != null,
              onChanged: (value) {
                if (widget.onChanged != null && selectedPlatform != null) {
                  widget.onChanged!(selectedPlatform!, value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }
}
