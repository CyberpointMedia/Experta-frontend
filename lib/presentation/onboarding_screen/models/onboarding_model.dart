import '../../../core/app_export.dart';import 'onboarding_item_model.dart';/// This class defines the variables used in the [onboarding_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class OnboardingModel {Rx<List<OnboardingItemModel>> onboardingItemList = Rx([OnboardingItemModel(rectangle:ImageConstant.imgRectangle101.obs),OnboardingItemModel(rectangle:ImageConstant.imgRectangle108.obs),OnboardingItemModel(rectangle:ImageConstant.imgRectangle102.obs),OnboardingItemModel(rectangle:ImageConstant.imgRectangle107.obs)]);

 }
