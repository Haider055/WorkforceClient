import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:workforceclientapp/Bindings/MyBindings.dart';
import 'package:workforceclientapp/views/screens/Authentications/CreateNewPassword.dart';
import 'package:workforceclientapp/views/screens/Authentications/ForgotPasswordScreen.dart';
import 'package:workforceclientapp/views/screens/Authentications/LoginScreen.dart';
import 'package:workforceclientapp/views/screens/Authentications/OTPVerificationScreen.dart';
import 'package:workforceclientapp/views/screens/Authentications/PasswordUpdatedScreen.dart';
import 'package:workforceclientapp/views/screens/Authentications/SignupScreen.dart';
import 'package:workforceclientapp/views/screens/Chat/ReviewJobScreen.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobDescriptionScreen.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobPostCompletedScreen.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobTitleScreen.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/PickAddressScreen.dart';
import 'package:workforceclientapp/views/screens/DashBoard/SelectServiceScreen.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/UploadJobImageScreen.dart';
import 'package:workforceclientapp/views/screens/Chat/AllChats.dart';
import 'package:workforceclientapp/views/screens/JobRecommendations/EndTheOrderScreen.dart';
import 'package:workforceclientapp/views/screens/JobRecommendations/JobRecommendations.dart';
import 'package:workforceclientapp/views/screens/JobRecommendations/TradesmenDetailScreen.dart';
import 'package:workforceclientapp/views/screens/LegalInformation/PrivacyPolicy.dart';
import 'package:workforceclientapp/views/screens/Profile/SupportCentre.dart';
import 'package:workforceclientapp/views/screens/LegalInformation/TermsAndConditions.dart';
import 'package:workforceclientapp/views/screens/Notifications/NotificationSettingScreen.dart';
import 'package:workforceclientapp/views/screens/PostedOrders/OrdersDetailsScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/ChangeLanguageScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/DeleteAccountScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/ManageAccountScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/UpdatePasswordScreen.dart';
import 'package:workforceclientapp/views/screens/SelectLanguage.dart';
import 'package:workforceclientapp/views/screens/SplashScreen.dart';
import 'package:workforceclientapp/views/screens/onboard/OnBoardScreen1.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: AppLinks.select_service_screen,
      page: () => const SelectServiceScreen(),
      binding: SelectServiceBinding(),
    ),
    GetPage(
      name: AppLinks.splash_screen,
      page: () => const SplashScreen(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: AppLinks.onboard_screen,
      page: () => const OnBoardScreen1(),
      binding: OnBoardScreenBinding(),
    ),
    GetPage(
      name: AppLinks.select_language_screen,
      page: () => SelectLanguage(),
      binding: SelectLanguageBinding(),
    ),
    GetPage(
      name: AppLinks.change_language_screen,
      page: () => const ChangeLanguageScreen(),
      binding: ChangeLanguageBinding(),
    ),
    GetPage(
      name: AppLinks.login_screen,
      page: () => LoginScreen(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: AppLinks.forgot_password_screen,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppLinks.create_new_password_screen,
      page: () => const CreateNewPassword(),
      binding: CreateNewPasswordBinding(),
    ),
    GetPage(
      name: AppLinks.otp_verification_screen,
      page: () => const OTPVerificationScreen(),
      binding: OTPVerificationBinding(),
    ),
    GetPage(
      name: AppLinks.signup_screen,
      page: () => const SignupScreen(),
      binding: SignupScreenBinding(),
    ),
    GetPage(
      name: AppLinks.password_updated_screen,
      page: () => const PasswordUpdatedScreen(),
      binding: PasswordUpdatedBinding(),
    ),
    GetPage(
      name: AppLinks.job_description_screen,
      page: () => const JobDescriptionScreen(),
      binding: JobDescriptionBinding(),
    ),
    GetPage(
      name: AppLinks.job_title_screen,
      page: () => const JobTitleScreen(),
      binding: JobTitleBinding(),
    ),
    GetPage(
      name: AppLinks.job_post_completed_screen,
      page: () => const JobPostCompletedScreen(),
      binding: JobPostCompletedBinding(),
    ),
    GetPage(
      name: AppLinks.manage_account_screen,
      page: () => const ManageAccountScreen(),
      binding: ManageAccountScreenBindings(),
    ),
    GetPage(
      name: AppLinks.pick_address_screen,
      page: () => const PickAddressScreen(),
      binding: PickAddressBinding(),
    ),
    GetPage(
      name: AppLinks.upload_job_image_screen,
      page: () => const UploadJobImageScreen(),
      binding: UploadJobImageBinding(),
    ),
    GetPage(
      name: AppLinks.review_screen,
      page: () => const ReviewJobScreen(),
      binding: ReviewScreenBinding(),
    ),
    GetPage(
      name: AppLinks.posted_orders_section,
      page: () => const PostedOrdersSection(),
      binding: PostedOrdersSectionBinding(),
    ),
    GetPage(
      name: AppLinks.all_chats,
      page: () => const AllChats(),
      binding: AllChatsBinding(),
    ),
    GetPage(
      name: AppLinks.end_the_order_screen,
      page: () => const EndTheOrderScreen(),
      binding: EndTheOrderBinding(),
    ),
    GetPage(
      name: AppLinks.orders_details_screen,
      page: () => OrdersDetailsScreen(),
      binding: OrdersDetailsScreenBinding(),
    ),
    GetPage(
      name: AppLinks.job_recommendations,
      page: () => const JobRecommendations(),
      binding: JobRecommendationsBinding(),
    ),
    GetPage(
      name: AppLinks.tradesmen_detail_screen,
      page: () => const TradesmenDetailScreen(),
      binding: TradesmenDetailScreenBinding(),
    ),
    GetPage(
      name: AppLinks.delete_account_screen,
      page: () => const DeleteAccountScreen(),
      binding: DeleteAccountScreenBinding(),
    ),
    GetPage(
      name: AppLinks.update_password_screen,
      page: () => const UpdatePasswordScreen(),
      binding: UpdatePasswordScreenBinding(),
    ),
    GetPage(
      name: AppLinks.notification_setting_screen,
      page: () => const NotificationSettingScreen(),
      binding: NotificationSettingScreenBinding(),
    ),
    GetPage(
      name: AppLinks.terms_and_conditions,
      page: () => const TermsAndConditions(),
      binding: TermsAndConditionsBindings(),
    ),
    GetPage(
      name: AppLinks.privacy_policy,
      page: () => const PrivacyPolicy(),
      binding: PrivacyPolicyBindings(),
    ),
    GetPage(
      name: AppLinks.support_centre,
      page: () => const SupportCentre(),
      binding: SupportCentreBindings(),
    ),
  ];
}

class AppLinks {
  static const splash_screen = '/splash';
  static const select_language_screen = '/select_language';
  static const change_language_screen = '/change_language';
  static const onboard_screen = '/onboard_screen';
  static const select_service_screen = '/select_service';
  static const login_screen = '/login';
  static const forgot_password_screen = '/forgot_password';
  static const create_new_password_screen = '/create_new_password';
  static const otp_verification_screen = '/otp_verification_screen';
  static const signup_screen = '/signup_screen';
  static const password_updated_screen = '/password_updated_screen';
  static const job_description_screen = '/job_description_screen';
  static const job_title_screen = '/job_title_screen';
  static const job_post_completed_screen = '/jobpost_completed_screen';
  static const pick_address_screen = '/pick_address_screen';
  static const upload_job_image_screen = '/upload_job_image_screen';
  static const review_screen = '/review_screen';
  static const posted_orders_section = '/PostedOrdersSection';
  static const all_chats = '/all_chats ';
  static const end_the_order_screen = '/end_the_order_screen';
  static const orders_details_screen = '/orders_details_screen';
  static const job_recommendations = '/job_recommendations';
  static const tradesmen_detail_screen = '/tradesmen_detail_screen';
  static const delete_account_screen = '/delete_account_screen';
  static const update_password_screen = '/update_password_screen';
  static const notification_setting_screen = '/notification_setting_screen';
  static const terms_and_conditions = '/terms_and_conditions';
  static const privacy_policy = '/privacy_policy';
  static const manage_account_screen = '/manage_account_screen';
  static const support_centre = '/support_centre';
}
