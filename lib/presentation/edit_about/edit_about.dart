import 'package:experta/core/app_export.dart';

class EditAboutPage extends StatefulWidget {
  final String bio;

  const EditAboutPage({super.key, required this.bio});

  @override
  State<EditAboutPage> createState() => _EditAboutPageState();
}

class _EditAboutPageState extends State<EditAboutPage> {
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController(text: widget.bio);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "Edit about",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.fSize,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bioController,
              maxLines: 12,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Edit your bio here",
                hintStyle: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.fSize,
                ),
              ),
              style: theme.textTheme.titleMedium,
              onChanged: (_) {
                setState(() {}); // Update the character counter dynamically
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${bioController.text.length}/2600",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: CustomElevatedButton(
                text: 'Save',
                onPressed: () {
                  if (bioController.text.trim().isNotEmpty) {
                    Navigator.pop(context, bioController.text.trim());
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
