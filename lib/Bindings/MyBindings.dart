import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Controllers/CreateNewPasswordController.dart';
import 'package:workforceclientapp/Controllers/EndtheOrderController.dart';
import 'package:workforceclientapp/Controllers/ForgotPasswordContoller.dart';
import 'package:workforceclientapp/Controllers/JobPostCompleteController.dart';
import 'package:workforceclientapp/Controllers/JobRecommendationController.dart';
import 'package:workforceclientapp/Controllers/LoginContoller.dart';
import 'package:workforceclientapp/Controllers/NotificationsContoller.dart';
import 'package:workforceclientapp/Controllers/OPTVerificationController.dart';
import 'package:workforceclientapp/Controllers/OnboardingScreenController.dart';
import 'package:workforceclientapp/Controllers/PasswordUpdatedController.dart';
import 'package:workforceclientapp/Controllers/PickAddressController.dart';
import 'package:workforceclientapp/Controllers/PostedOrderDetailsController.dart';
import 'package:workforceclientapp/Controllers/PostedOrdersController.dart';
import 'package:workforceclientapp/Controllers/ProfileController.dart';
import 'package:workforceclientapp/Controllers/ReviewScreenController.dart';
import 'package:workforceclientapp/Controllers/SelectLanguageController.dart';
import 'package:workforceclientapp/Controllers/SelectServiceController.dart';
import 'package:workforceclientapp/Controllers/SignupContoller.dart';
import 'package:workforceclientapp/Controllers/SplashController.dart';
import 'package:workforceclientapp/Controllers/TradesmenDetailController.dart';
import 'package:workforceclientapp/Controllers/UploadJobImagesController.dart';
import 'package:workforceclientapp/views/screens/LegalInformation/PrivacyPolicy.dart';
import 'package:workforceclientapp/views/screens/LegalInformation/TermsAndConditions.dart';

class SelectServiceBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SelectServiceController>(SelectServiceController());
  }
}

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}

class SelectLanguageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SelectLanguageController>(SelectLanguageController());
  }
}

class OnBoardScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<OnboardingScreenController>(OnboardingScreenController());
  }
}

class LoginScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<LoginContoller>(LoginContoller());
  }
}

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ForgotPasswordContoller>(ForgotPasswordContoller());
  }
}

class CreateNewPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CreateNewPasswordController>(CreateNewPasswordController());
  }
}

class OTPVerificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<OTPVerificationController>(OTPVerificationController());
  }
}

class SignupScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SignUpContoller>(SignUpContoller());
  }
}

class PasswordUpdatedBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PasswordUpdatedController>(PasswordUpdatedController());
  }
}

class JobDescriptionBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PasswordUpdatedController>(PasswordUpdatedController());
  }
}

class JobTitleBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PasswordUpdatedController>(PasswordUpdatedController());
  }
}

class JobPostCompletedBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<JobPostCompleteController>(JobPostCompleteController());
  }
}

class PickAddressBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PickAddressController>(PickAddressController());
  }
}

class UploadJobImageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<UploadJobImagesController>(UploadJobImagesController());
  }
}

class ReviewScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ReviewScreenController>(ReviewScreenController());
  }
}

class PostedOrdersSectionBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PostedOrdersController>(PostedOrdersController());
  }
}

class AllChatsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AllChatsContoller>(AllChatsContoller());
  }
}

class EndTheOrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<EndtheOrderController>(EndtheOrderController());
  }
}

class OrdersDetailsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PostedOrderDetailsController>(PostedOrderDetailsController());
  }
}

class JobRecommendationsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<JobRecommendationController>(JobRecommendationController());
  }
}

class TradesmenDetailScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TradesmenDetailController>(TradesmenDetailController());
  }
}

class DeleteAccountScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }
}

class UpdatePasswordScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CreateNewPasswordController>(CreateNewPasswordController());
  }
}

class NotificationSettingScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NotificationsContoller>(NotificationsContoller());
  }
}

class TermsAndConditionsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<TermsandconditionController>(TermsandconditionController());
  }
}

class PrivacyPolicyBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<PrivacyPolicyController>(PrivacyPolicyController());
  }
}
