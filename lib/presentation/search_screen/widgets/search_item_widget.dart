import 'package:experta/presentation/search_screen/models/search_model.dart';
import 'package:experta/presentation/search_screen/controller/search_controller.dart';
import 'package:experta/widgets/dashed_border.dart';
import '../../../core/app_export.dart';

class SearchItemWidget extends StatefulWidget {
  final SearchResult searchResult;

  const SearchItemWidget(this.searchResult, {super.key});

  @override
  State<SearchItemWidget> createState() => _SearchItemWidgetState();
}

class _SearchItemWidgetState extends State<SearchItemWidget> {
  SearchPageController controller = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    SearchResult user = widget.searchResult;
    return GestureDetector(
      onTap: () {
        controller.searchPageController.clear();
        Get.toNamed(AppRoutes.detailsPage, arguments: {"user": user});
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
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
                              border: Border.all(color: Colors.white, width: 2),
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
                                          color: Colors.black, fontSize: 12),
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
                              SizedBox(
                                width:
                                        MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    (() {
                                      if (user.language != null &&
                                          user.language!.isNotEmpty) {
                                        final languages = user.language!
                                            .map((l) => l.name)
                                            .toList();
                                
                                        if (languages.length > 3) {
                                          return '${languages.take(3).join(', ')} +${languages.length - 3} more';
                                        } else {
                                          return languages.join(', ');
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
              Center(
                child: CustomPaint(
                  painter: DashedDividerPainter(
                    color: appTheme.gray200, // or your desired color
                    dashWidth: 5.0, // length of each dash
                    dashSpace: 3.0, // space between dashes
                    strokeWidth: 1.0, // thickness of the line
                  ),
                  size: Size(MediaQuery.of(context).size.width * 0.8, 1),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Wrap(
                  spacing: 8.adaptSize,
                  runSpacing: 8.adaptSize,
                  children: user.expertise == null || user.expertise!.isEmpty
                      ? [_buildChip('No expertise')]
                      : [
                          ...user.expertise!
                              .take(3)
                              .map((e) => _buildChip(e.name)),
                          if (user.expertise!.length > 3)
                            _buildChip(
                              '+${user.expertise!.length - 3}',
                            ),
                        ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: appTheme.gray100,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.video_call,
                        "${user.pricing!.videoCallPrice}", Colors.red),
                    Container(
                      color: appTheme.gray300,
                      width: 0.5,
                      height: 50,
                    ),
                    _buildActionButton(Icons.phone,
                        "${user.pricing!.audioCallPrice}", Colors.green),
                    Container(
                      color: appTheme.gray300,
                      width: 0.5,
                      height: 50,
                    ),
                    _buildActionButton(Icons.message,
                        "${user.pricing!.messagePrice}", appTheme.yellow900),
                  ],
                ),
              ),
            ],
          ),
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
