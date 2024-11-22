import 'dart:convert';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/animated_hint_searchview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ProfileBlockPage extends StatefulWidget {
  const ProfileBlockPage({super.key});

  @override
  State<ProfileBlockPage> createState() => _ProfileBlockPageState();
}

class _ProfileBlockPageState extends State<ProfileBlockPage> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<List<SearchResult>> searchResults = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void dispose() {
    searchController.dispose();
    searchResults.dispose();
    isLoading.dispose();
    super.dispose();
  }

  // Function to fetch users by search query
  void fetchUsersBySearch(String query) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('http://3.110.252.174:8080/api/getUserBySearch/$query'),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'] as List;
        searchResults.value =
            data.map((json) => SearchResult.fromJson(json)).toList();
      } else {
        print('Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void blockUser(String userToBlockId) async {
    try {
      // Simulate API call using your ApiService
      bool success = await ApiService().blockUser(userToBlockId);
      if (success) {
        // Remove the user from the list
        searchResults.value = searchResults.value
            .where((user) => user.id != userToBlockId)
            .toList();
        Fluttertoast.showToast(
          msg: "User blocked successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to block user",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 270,
              top: 50,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal,
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
            // Main Content
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomAnimatedSearchView(
                          controller: searchController,
                          hintTexts: const ['Search users'],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              fetchUsersBySearch(value);
                            } else {
                              searchResults.value = [];
                            }
                          },
                          suffix: _buildClearIcon(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: TextButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          child: Text(
                            "Cancel",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: appTheme.gray900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<SearchResult>>(
                    valueListenable: searchResults,
                    builder: (context, results, _) {
                      if (isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (results.isEmpty) {
                        return Center(
                            child: Text(
                          'No users found.',
                          style: theme.textTheme.titleMedium!.copyWith(color: appTheme.blueGray300),
                        ));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          SearchResult user = results[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.detailsPage,
                                  arguments: {"user": user});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              height: 65.adaptSize,
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      CustomImageView(
                                        radius: BorderRadius.circular(29),
                                        imagePath: (user.profilePic.isEmpty)
                                            ? ImageConstant.imageNotFound
                                            : user.profilePic,
                                      ),
                                      Positioned(
                                        bottom: 3.adaptSize,
                                        right: 1.adaptSize,
                                        child: CircleAvatar(
                                          radius: 8.adaptSize,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 6.adaptSize,
                                            backgroundColor: user.online
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "${user.firstName} ${user.lastName}"),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            "${user.industry} | ${user.occupation}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleSmall!
                                                .copyWith(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  CustomElevatedButton(
                                    height: 30,
                                    width: 70,
                                    onPressed: () {
                                      blockUser(user.id);
                                      print('User ${user.displayName} blocked');
                                    },
                                    text: 'Block',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: Icon(
          Icons.clear,
          color: appTheme.gray900,
          size: 20,
        ),
        onPressed: () {
          searchController.clear();
        },
      ),
    );
  }
}

class SearchResult {
  String id;
  bool online;
  bool isVerified;
  int noOfBooking;
  int rating;
  String profilePic;
  String displayName;
  String lastName;
  String firstName;
  String industry;
  String occupation;

  SearchResult({
    required this.id,
    required this.online,
    required this.isVerified,
    required this.noOfBooking,
    required this.rating,
    required this.profilePic,
    required this.displayName,
    required this.lastName,
    required this.firstName,
    required this.industry,
    required this.occupation,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['_id'],
      online: json['online'],
      isVerified: json['isVerified'],
      noOfBooking: json['noOfBooking'],
      rating: json['rating'],
      profilePic: json['profilePic'],
      displayName: json['displayName'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      industry: json['industry'],
      occupation: json['occupation'],
    );
  }
}
