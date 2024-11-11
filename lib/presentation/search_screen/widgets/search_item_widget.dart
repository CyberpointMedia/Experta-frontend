import 'package:experta/presentation/search_screen/models/search_model.dart';
import 'package:experta/presentation/search_screen/controller/search_controller.dart';
import 'package:experta/widgets/dashed_border.dart';
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
      child: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.orange,
                              child: CustomImageView(
                                radius: BorderRadius.circular(30),
                                imagePath: user.profilePic.isNotEmpty
                                    ? user.profilePic
                                    : ImageConstant.imageNotFound,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.displayName.isNotEmpty
                                        ? user.displayName
                                        : "anonymous",
                                    style: TextStyle(
                                      fontSize: 16.fSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.verified,
                                      color: Colors.deepPurple, size: 16),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.orange, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.orange, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          user.rating.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                user.industry.isNotEmpty
                                    ? "${user.industry} | ${user.occupation}"
                                    : "No data",
                                style: TextStyle(
                                  fontSize: 12.fSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  CustomImageView(
                                    height: 14,
                                    width: 14,
                                    imagePath: "assets/images/language.svg",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      (() {
                                        if (user.languages.isNotEmpty) {
                                          if (user.languages.length > 3) {
                                            return '${user.languages.take(3).join(', ')} +${user.languages.length - 3} more';
                                          } else {
                                            return user.languages.join(', ');
                                          }
                                        } else {
                                          return 'No languages';
                                        }
                                      })(),
                                      style: TextStyle(
                                        fontSize: 12.fSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                    child: CustomPaint(
                      painter: DashedBorderPainter(
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashWidth: 6.0,
                        dashSpace: 2.0,
                      ),
                      child: Container(height: 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Wrap(
                      spacing: 8.adaptSize,
                      runSpacing: 8.adaptSize,
                      children: user.expertises.isEmpty
                          ? [_buildChip('No expertise')]
                          : [
                              ...user.expertises
                                  .take(3)
                                  .map((e) => _buildChip(e)),
                              if (user.expertises.length > 3)
                                _buildChip(
                                  '+${user.expertises.length - 3}',
                                ),
                            ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: appTheme.gray100,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                            Icons.video_call, "Call", Colors.red),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5,
                          height: 50,
                        ),
                        _buildActionButton(
                            Icons.phone, "Audio Call", Colors.green),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5,
                          height: 50,
                        ),
                        _buildActionButton(
                            Icons.message, "Message", appTheme.yellow900),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 55,
              left: -15,
              child: Transform.rotate(
                angle: -45 * (3.141592653589793 / 180),
                alignment: Alignment.topLeft,
                child: Container(
                  width: 100,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Top Rated",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(60),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 12.adaptSize, vertical: 6.adaptSize),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.fSize,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        SizedBox(width: 4.adaptSize),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
