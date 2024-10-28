import 'package:experta/presentation/search_screen/models/search_model.dart';
import 'package:experta/presentation/search_screen/controller/search_controller.dart';
import '../../../core/app_export.dart';

class SearchItemWidget extends StatelessWidget {
  final SearchResult searchResult;

  SearchItemWidget(this.searchResult, {super.key});

  SearchPageController controller = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    SearchResult user = searchResult;
    return GestureDetector(
      onTap: () {
        controller.searchPageController.clear();
        Get.toNamed(AppRoutes.detailsPage, arguments: {"user": user});
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(5),
          height: 65,
          child: Row(
            children: [
              Stack(
                children: [
                  CustomImageView(
                    radius: BorderRadius.circular(29), // 58 / 2
                    imagePath: (user.profilePic.isEmpty)
                        ? ImageConstant.imgImage3380x80
                        : user.profilePic,
                  ),
                  Positioned(
                    bottom: 3,
                    right: 1,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor:
                            user.online ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(left: 10.adaptSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${user.firstName} ${user.lastName}"),
                    Text("${user.industry} | ${user.occupation}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
