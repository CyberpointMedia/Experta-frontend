import 'package:experta/core/app_export.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevent back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 140.h,
                height: 140.v,
                decoration: BoxDecoration(
                  color: appTheme.green400.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 92.h,
                    height: 92.v,
                    decoration: BoxDecoration(
                      color: appTheme.green400,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomImageView(
                        imagePath: ImageConstant.success,
                        height: 20.v,
                        width: 30.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Successfully',
                style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: appTheme.black900),
              ),
              const SizedBox(height: 8),
              Text(
                'Your appointment booking confirmed.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
