import 'package:experta/core/app_export.dart';

class ChatItemWidget extends StatelessWidget {
  final String profilePic;
  final String displayName;

  const ChatItemWidget({
    required this.profilePic,
    required this.displayName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 2.v),
          child: Column(
            children: [
              SizedBox(
                height: 58.adaptSize,
                width: 58.adaptSize,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 29.h,
                      backgroundColor: appTheme.whiteA700,
                      backgroundImage: profilePic.isNotEmpty
                          ? NetworkImage(profilePic) as ImageProvider
                          : const AssetImage(
                              'assets/images/image_not_found.png'),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        decoration: BoxDecoration(
                          color: appTheme.green400,
                          borderRadius: BorderRadius.circular(8.h),
                          border: Border.all(
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(1),
                            width: 2.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.v),
              SizedBox(
                // width: 29.h,
                child: Text(
                  displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.labelLargeGray900Medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
