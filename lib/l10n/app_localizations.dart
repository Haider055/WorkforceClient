import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de')
  ];

  /// No description provided for @auftragNowText.
  ///
  /// In en, this message translates to:
  /// **'Auftrag Now'**
  String get auftragNowText;

  /// No description provided for @auftragText.
  ///
  /// In en, this message translates to:
  /// **'Auftrag'**
  String get auftragText;

  /// No description provided for @yesText.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesText;

  /// No description provided for @noText.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noText;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @letsStartText.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start'**
  String get letsStartText;

  /// No description provided for @select_languageText.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_languageText;

  /// No description provided for @englishText.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishText;

  /// No description provided for @jobPostText.
  ///
  /// In en, this message translates to:
  /// **'Job Post'**
  String get jobPostText;

  /// No description provided for @myJobsText.
  ///
  /// In en, this message translates to:
  /// **'My Jobs'**
  String get myJobsText;

  /// No description provided for @germanText.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get germanText;

  /// No description provided for @cancelText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelText;

  /// No description provided for @canceledText.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceledText;

  /// No description provided for @loginText.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginText;

  /// No description provided for @logoutText.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutText;

  /// No description provided for @registerText.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerText;

  /// No description provided for @phoneText.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneText;

  /// No description provided for @skipText.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipText;

  /// No description provided for @allText.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allText;

  /// No description provided for @chatText.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatText;

  /// No description provided for @settingsText.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsText;

  /// No description provided for @languageText.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageText;

  /// No description provided for @changeLanguageText.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguageText;

  /// No description provided for @createText.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createText;

  /// No description provided for @signupText.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupText;

  /// No description provided for @signInText.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInText;

  /// No description provided for @loginDesc.
  ///
  /// In en, this message translates to:
  /// **'Please Sign in to Continue'**
  String get loginDesc;

  /// No description provided for @forgotPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordText;

  /// No description provided for @rememberPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Remember Password'**
  String get rememberPasswordText;

  /// No description provided for @incorrectPasswordText.
  ///
  /// In en, this message translates to:
  /// **'incorrect Password'**
  String get incorrectPasswordText;

  /// No description provided for @fullNameAddressText.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameAddressText;

  /// No description provided for @emailAddressText.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressText;

  /// No description provided for @emailAddressNotFoundText.
  ///
  /// In en, this message translates to:
  /// **'Email Address not Found'**
  String get emailAddressNotFoundText;

  /// No description provided for @chatBoxIsEmptyText.
  ///
  /// In en, this message translates to:
  /// **'Chat Box is empty'**
  String get chatBoxIsEmptyText;

  /// No description provided for @notificationIsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Please Login to See You notifications'**
  String get notificationIsEmptyDesc;

  /// No description provided for @notificationListEmptyText.
  ///
  /// In en, this message translates to:
  /// **'Notification List is Empty'**
  String get notificationListEmptyText;

  /// No description provided for @chatBoxIsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'You have not started chatting with tradesman yet. Start a chat to get you job done soon.'**
  String get chatBoxIsEmptyDesc;

  /// No description provided for @passwordText.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordText;

  /// No description provided for @currentPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordText;

  /// No description provided for @newPasswordText.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordText;

  /// No description provided for @confirmPasswordErrorText.
  ///
  /// In en, this message translates to:
  /// **'Both Passwords did not match'**
  String get confirmPasswordErrorText;

  /// No description provided for @successText.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successText;

  /// No description provided for @updateText.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateText;

  /// No description provided for @confirmPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordText;

  /// No description provided for @createNewPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Create a New Password'**
  String get createNewPasswordText;

  /// No description provided for @passwordUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Password Updated'**
  String get passwordUpdatedText;

  /// No description provided for @manageAccountText.
  ///
  /// In en, this message translates to:
  /// **'Manage Account'**
  String get manageAccountText;

  /// No description provided for @managePaswordText.
  ///
  /// In en, this message translates to:
  /// **'Manage Password'**
  String get managePaswordText;

  /// No description provided for @deleteAccountText.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountText;

  /// No description provided for @deleteMyAaccountText.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteMyAaccountText;

  /// No description provided for @updatePasswordText.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordText;

  /// No description provided for @congratulationsText.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulationsText;

  /// No description provided for @painterText.
  ///
  /// In en, this message translates to:
  /// **'Painter'**
  String get painterText;

  /// No description provided for @completedText.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedText;

  /// No description provided for @servicesText.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesText;

  /// No description provided for @youGotText.
  ///
  /// In en, this message translates to:
  /// **'You got'**
  String get youGotText;

  /// No description provided for @orderNowText.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNowText;

  /// No description provided for @hireNowText.
  ///
  /// In en, this message translates to:
  /// **'Hire Now'**
  String get hireNowText;

  /// No description provided for @myOrdersText.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrdersText;

  /// No description provided for @myPostedOrdersText.
  ///
  /// In en, this message translates to:
  /// **'My Posted Orders'**
  String get myPostedOrdersText;

  /// No description provided for @acceptedText.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedText;

  /// No description provided for @rejectedText.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejectedText;

  /// No description provided for @acceptText.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptText;

  /// No description provided for @rejectText.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectText;

  /// No description provided for @activeText.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeText;

  /// No description provided for @accountText.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountText;

  /// No description provided for @helpText.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpText;

  /// No description provided for @postJobText.
  ///
  /// In en, this message translates to:
  /// **'Post Job'**
  String get postJobText;

  /// No description provided for @noOrdersText.
  ///
  /// In en, this message translates to:
  /// **'No Orders'**
  String get noOrdersText;

  /// No description provided for @postedAtText.
  ///
  /// In en, this message translates to:
  /// **'Posted at'**
  String get postedAtText;

  /// No description provided for @passwodisWrongText.
  ///
  /// In en, this message translates to:
  /// **'Passwod is Wrong'**
  String get passwodisWrongText;

  /// No description provided for @noActiveOrdersText.
  ///
  /// In en, this message translates to:
  /// **'No Active orders yet'**
  String get noActiveOrdersText;

  /// No description provided for @noMaybeLaterText.
  ///
  /// In en, this message translates to:
  /// **'No, Maybe Later'**
  String get noMaybeLaterText;

  /// No description provided for @noInProcessOrdersText.
  ///
  /// In en, this message translates to:
  /// **'No In-Process Orders yet'**
  String get noInProcessOrdersText;

  /// No description provided for @noCompleteOrdersText.
  ///
  /// In en, this message translates to:
  /// **'No Completed Orders yet'**
  String get noCompleteOrdersText;

  /// No description provided for @orderCompletedText.
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get orderCompletedText;

  /// No description provided for @noCancelOrdersText.
  ///
  /// In en, this message translates to:
  /// **'No Cancelled Orders yet'**
  String get noCancelOrdersText;

  /// No description provided for @showMoreText.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMoreText;

  /// No description provided for @showLessText.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLessText;

  /// No description provided for @noPortfolioFoundText.
  ///
  /// In en, this message translates to:
  /// **'No Portfolio Found!'**
  String get noPortfolioFoundText;

  /// No description provided for @noReviewFoundText.
  ///
  /// In en, this message translates to:
  /// **'No Review Found!'**
  String get noReviewFoundText;

  /// No description provided for @noRequestsFoundText.
  ///
  /// In en, this message translates to:
  /// **'No Requests Found!'**
  String get noRequestsFoundText;

  /// No description provided for @noDataFoundText.
  ///
  /// In en, this message translates to:
  /// **'No Data Found!'**
  String get noDataFoundText;

  /// No description provided for @noTradesmenText.
  ///
  /// In en, this message translates to:
  /// **'No Tradesmen Found!'**
  String get noTradesmenText;

  /// No description provided for @profileText.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileText;

  /// No description provided for @recommendationsText.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendationsText;

  /// No description provided for @assignmentText.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get assignmentText;

  /// No description provided for @recommendedCraftsmenText.
  ///
  /// In en, this message translates to:
  /// **'Recommended Craftmen/Agencies'**
  String get recommendedCraftsmenText;

  /// No description provided for @getAnswersText.
  ///
  /// In en, this message translates to:
  /// **'Get Answers'**
  String get getAnswersText;

  /// No description provided for @startConversationText.
  ///
  /// In en, this message translates to:
  /// **'Start\nConversation'**
  String get startConversationText;

  /// No description provided for @sendRequestText.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequestText;

  /// No description provided for @requestRejectedText.
  ///
  /// In en, this message translates to:
  /// **'Request Rejected'**
  String get requestRejectedText;

  /// No description provided for @moreCraftmenText.
  ///
  /// In en, this message translates to:
  /// **'more craftmen.'**
  String get moreCraftmenText;

  /// No description provided for @backText.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backText;

  /// No description provided for @photosText.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosText;

  /// No description provided for @notificationSetupErrorText.
  ///
  /// In en, this message translates to:
  /// **'Notification Setup Error'**
  String get notificationSetupErrorText;

  /// No description provided for @enterCodeText.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCodeText;

  /// No description provided for @pleaseVerifyText.
  ///
  /// In en, this message translates to:
  /// **'Please verify'**
  String get pleaseVerifyText;

  /// No description provided for @failedText.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failedText;

  /// No description provided for @tryAgainText.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainText;

  /// No description provided for @cancelOrderText.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderText;

  /// No description provided for @removeJobText.
  ///
  /// In en, this message translates to:
  /// **'Remove Job'**
  String get removeJobText;

  /// No description provided for @agencyText.
  ///
  /// In en, this message translates to:
  /// **'Agency'**
  String get agencyText;

  /// No description provided for @profileImageUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Profile image has been updated'**
  String get profileImageUpdatedText;

  /// No description provided for @pleaseEnterValidEmailText.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email!'**
  String get pleaseEnterValidEmailText;

  /// No description provided for @pleaseSelectSeviceText.
  ///
  /// In en, this message translates to:
  /// **'Please Select Sevice!'**
  String get pleaseSelectSeviceText;

  /// No description provided for @overviewText.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewText;

  /// No description provided for @detailsText.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsText;

  /// No description provided for @tradesman.
  ///
  /// In en, this message translates to:
  /// **'Tradesman'**
  String get tradesman;

  /// No description provided for @orderDetailText.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderDetailText;

  /// No description provided for @searchYourLocationText.
  ///
  /// In en, this message translates to:
  /// **'Search your location'**
  String get searchYourLocationText;

  /// No description provided for @pleaseVerifyYourEmailText.
  ///
  /// In en, this message translates to:
  /// **'Please verify your Email'**
  String get pleaseVerifyYourEmailText;

  /// No description provided for @requestUpto10TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'Request upto 10 Tradesmen'**
  String get requestUpto10TradesmenText;

  /// No description provided for @dataNotFoundText.
  ///
  /// In en, this message translates to:
  /// **'Data Not Found'**
  String get dataNotFoundText;

  /// No description provided for @photosNotFoundText.
  ///
  /// In en, this message translates to:
  /// **'Photos Not Found'**
  String get photosNotFoundText;

  /// No description provided for @sendARequestText.
  ///
  /// In en, this message translates to:
  /// **'Send a request'**
  String get sendARequestText;

  /// No description provided for @noPhotosWereUploadText.
  ///
  /// In en, this message translates to:
  /// **'No Photos were Uploaded!'**
  String get noPhotosWereUploadText;

  /// No description provided for @pleaseLoginToSeeOrdersText.
  ///
  /// In en, this message translates to:
  /// **'Please Login to See Your Orders.'**
  String get pleaseLoginToSeeOrdersText;

  /// No description provided for @startPostingYourOrdersText.
  ///
  /// In en, this message translates to:
  /// **'Start posting your orders to see them here.'**
  String get startPostingYourOrdersText;

  /// No description provided for @goodToknowText.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get goodToknowText;

  /// No description provided for @workForceText.
  ///
  /// In en, this message translates to:
  /// **'WorkForce'**
  String get workForceText;

  /// No description provided for @professionsText.
  ///
  /// In en, this message translates to:
  /// **'Professions'**
  String get professionsText;

  /// No description provided for @portfolioText.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolioText;

  /// No description provided for @portfoliosText.
  ///
  /// In en, this message translates to:
  /// **'Portfolios'**
  String get portfoliosText;

  /// No description provided for @descriptionText.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionText;

  /// No description provided for @jobDescriptionText.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get jobDescriptionText;

  /// No description provided for @jobTitleHintText.
  ///
  /// In en, this message translates to:
  /// **'e.g. I need painter for my House.'**
  String get jobTitleHintText;

  /// No description provided for @jobTitleDescText.
  ///
  /// In en, this message translates to:
  /// **'Mention your work briefly, so that may help us find the best matched opportunities for you.'**
  String get jobTitleDescText;

  /// No description provided for @itSeemsYouAreNotLoginText.
  ///
  /// In en, this message translates to:
  /// **'It seems you\'re not logged in. Log in to post a job.'**
  String get itSeemsYouAreNotLoginText;

  /// No description provided for @nextText.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextText;

  /// No description provided for @exploreRecommendedTradesmenText.
  ///
  /// In en, this message translates to:
  /// **'Explore Recommended Tradesmen'**
  String get exploreRecommendedTradesmenText;

  /// No description provided for @pleaseLoginToSeeChatsText.
  ///
  /// In en, this message translates to:
  /// **'Please Login to See Your Chats'**
  String get pleaseLoginToSeeChatsText;

  /// No description provided for @viewPostedJobsText.
  ///
  /// In en, this message translates to:
  /// **'View Posted Jobs'**
  String get viewPostedJobsText;

  /// No description provided for @leaveOrderText.
  ///
  /// In en, this message translates to:
  /// **'Leave order'**
  String get leaveOrderText;

  /// No description provided for @jobTitleText.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitleText;

  /// No description provided for @aboutThisCompanyText.
  ///
  /// In en, this message translates to:
  /// **'About this Company'**
  String get aboutThisCompanyText;

  /// No description provided for @termsAndConditionText.
  ///
  /// In en, this message translates to:
  /// **'Terms And Conditions'**
  String get termsAndConditionText;

  /// No description provided for @infoText.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoText;

  /// No description provided for @inProcessText.
  ///
  /// In en, this message translates to:
  /// **'In Process'**
  String get inProcessText;

  /// No description provided for @notificationsText.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsText;

  /// No description provided for @notificationText.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationText;

  /// No description provided for @contactInformationText.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformationText;

  /// No description provided for @legalGuidelinesText.
  ///
  /// In en, this message translates to:
  /// **'Legal Guidelines'**
  String get legalGuidelinesText;

  /// No description provided for @dataSafeguardsText.
  ///
  /// In en, this message translates to:
  /// **'Data Safeguards'**
  String get dataSafeguardsText;

  /// No description provided for @cookieManagementText.
  ///
  /// In en, this message translates to:
  /// **'Cookie Management'**
  String get cookieManagementText;

  /// No description provided for @supportCenterText.
  ///
  /// In en, this message translates to:
  /// **'Support Center'**
  String get supportCenterText;

  /// No description provided for @contactText.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactText;

  /// No description provided for @memberSinceText.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSinceText;

  /// No description provided for @endingOrderPageHeadText.
  ///
  /// In en, this message translates to:
  /// **'Why are you ending this assignment?'**
  String get endingOrderPageHeadText;

  /// No description provided for @endingOrderPageDescText.
  ///
  /// In en, this message translates to:
  /// **'Your feedback help us to improve AuftragNow even further'**
  String get endingOrderPageDescText;

  /// No description provided for @jobhasRemovedText.
  ///
  /// In en, this message translates to:
  /// **'Your Job has been removed Successfully'**
  String get jobhasRemovedText;

  /// No description provided for @jobhasRemovedandNoActiveText.
  ///
  /// In en, this message translates to:
  /// **'This Job has been Canceled and no longer Active.'**
  String get jobhasRemovedandNoActiveText;

  /// No description provided for @somethingWentWrongText.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong!'**
  String get somethingWentWrongText;

  /// No description provided for @messageFailedToSendText.
  ///
  /// In en, this message translates to:
  /// **'Message failed to send'**
  String get messageFailedToSendText;

  /// No description provided for @youHaveReachedtoLlimitText.
  ///
  /// In en, this message translates to:
  /// **'You have reached to limit!'**
  String get youHaveReachedtoLlimitText;

  /// No description provided for @somethingWentWrongWhileRemovingJobText.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong while removing Job!'**
  String get somethingWentWrongWhileRemovingJobText;

  /// No description provided for @somethingWentWrongGettingResultsText.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while getting results!'**
  String get somethingWentWrongGettingResultsText;

  /// No description provided for @somethingWentWrongwhilePickImagesText.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong while picking images!'**
  String get somethingWentWrongwhilePickImagesText;

  /// No description provided for @somethingWentWrongwhilePickImageText.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong while picking image!'**
  String get somethingWentWrongwhilePickImageText;

  /// No description provided for @somethingWentWrongwhileLoadingPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong while loading portfolio!'**
  String get somethingWentWrongwhileLoadingPortfolio;

  /// No description provided for @somethingWentWrongwhileLoadingReviews.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong while loading Reviews!'**
  String get somethingWentWrongwhileLoadingReviews;

  /// No description provided for @pickTheBestAndStartWorkText.
  ///
  /// In en, this message translates to:
  /// **'tradesman requests! Let’s pick the best and start work'**
  String get pickTheBestAndStartWorkText;

  /// No description provided for @wrongPinText.
  ///
  /// In en, this message translates to:
  /// **'You Entered Wrong PinCode!'**
  String get wrongPinText;

  /// No description provided for @endOrderReason1.
  ///
  /// In en, this message translates to:
  /// **'I did not find a tradesman on AuftragNow'**
  String get endOrderReason1;

  /// No description provided for @endOrderReason2.
  ///
  /// In en, this message translates to:
  /// **'I found a tradesman elsewhere'**
  String get endOrderReason2;

  /// No description provided for @endOrderReason3.
  ///
  /// In en, this message translates to:
  /// **'I will do the job myself'**
  String get endOrderReason3;

  /// No description provided for @endOrderReason4.
  ///
  /// In en, this message translates to:
  /// **'The order was interrupted'**
  String get endOrderReason4;

  /// No description provided for @endOrderReason5.
  ///
  /// In en, this message translates to:
  /// **'Other reason (Please Specify)'**
  String get endOrderReason5;

  /// No description provided for @nameMustbeAtleastText.
  ///
  /// In en, this message translates to:
  /// **'Name Must be Atleast 4 Characters'**
  String get nameMustbeAtleastText;

  /// No description provided for @passwordhasbeenupdatedText.
  ///
  /// In en, this message translates to:
  /// **'Your Password has been Updated.'**
  String get passwordhasbeenupdatedText;

  /// No description provided for @selectServiceHeadingText.
  ///
  /// In en, this message translates to:
  /// **'What kind of order is it?'**
  String get selectServiceHeadingText;

  /// No description provided for @selectServiceDescText.
  ///
  /// In en, this message translates to:
  /// **'Find and hire certified tradesmen in your \narea for the services your need.'**
  String get selectServiceDescText;

  /// No description provided for @selectServiceInfoText1.
  ///
  /// In en, this message translates to:
  /// **'Create your order fee of charge and\nwithout obligations.'**
  String get selectServiceInfoText1;

  /// No description provided for @selectServiceInfoText2.
  ///
  /// In en, this message translates to:
  /// **'More than 1000 registered craftsmen.'**
  String get selectServiceInfoText2;

  /// No description provided for @moreThanText.
  ///
  /// In en, this message translates to:
  /// **'More than'**
  String get moreThanText;

  /// No description provided for @independentReviewsText.
  ///
  /// In en, this message translates to:
  /// **'independent reviews.'**
  String get independentReviewsText;

  /// No description provided for @findYourAddressText.
  ///
  /// In en, this message translates to:
  /// **'Find your Address'**
  String get findYourAddressText;

  /// No description provided for @reviewsText.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsText;

  /// No description provided for @yourAddressText.
  ///
  /// In en, this message translates to:
  /// **'Your Address'**
  String get yourAddressText;

  /// No description provided for @viewOnMapText.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMapText;

  /// No description provided for @cannotBeEmptyText.
  ///
  /// In en, this message translates to:
  /// **'Cannot be Empty'**
  String get cannotBeEmptyText;

  /// No description provided for @recommendationScreenHeadingText.
  ///
  /// In en, this message translates to:
  /// **'Discover the top Tradesmen near you!'**
  String get recommendationScreenHeadingText;

  /// No description provided for @recommendationScreenDescText.
  ///
  /// In en, this message translates to:
  /// **'Send your request to 10 tradespeople and interested ones will get in touch with you directly.'**
  String get recommendationScreenDescText;

  /// No description provided for @interestedTradesmanText.
  ///
  /// In en, this message translates to:
  /// **'Interested Tradesman'**
  String get interestedTradesmanText;

  /// No description provided for @nointerestedTradesmanText.
  ///
  /// In en, this message translates to:
  /// **'No Interested Tradesman'**
  String get nointerestedTradesmanText;

  /// No description provided for @interestedText.
  ///
  /// In en, this message translates to:
  /// **'Interested'**
  String get interestedText;

  /// No description provided for @writeJobDescriptionText.
  ///
  /// In en, this message translates to:
  /// **'Please write job description!'**
  String get writeJobDescriptionText;

  /// No description provided for @writeJobTitleText.
  ///
  /// In en, this message translates to:
  /// **'Please write job title!'**
  String get writeJobTitleText;

  /// No description provided for @photoShareAgreeText.
  ///
  /// In en, this message translates to:
  /// **'I agree to share my provided images to tradesmen!'**
  String get photoShareAgreeText;

  /// No description provided for @peaseAgreetoSharePhotoText.
  ///
  /// In en, this message translates to:
  /// **'Please confirm to share the images'**
  String get peaseAgreetoSharePhotoText;

  /// No description provided for @recommendationScreenBubbleInfoText1.
  ///
  /// In en, this message translates to:
  /// **'Send your request to 10 tradesmen. If they\naccept it, they will contact you to discuss the\njob.'**
  String get recommendationScreenBubbleInfoText1;

  /// No description provided for @recommendationScreenBubbleInfoText2.
  ///
  /// In en, this message translates to:
  /// **'Let’s find the best craftsmen\nin your area'**
  String get recommendationScreenBubbleInfoText2;

  /// No description provided for @recommendationScreenBubbleInfoText3.
  ///
  /// In en, this message translates to:
  /// **'Let’s find the best craftsmen\nin your area'**
  String get recommendationScreenBubbleInfoText3;

  /// No description provided for @addingPicturesHelpsBetterQuotesText.
  ///
  /// In en, this message translates to:
  /// **'Adding pictures helps tradesmen give better quotes'**
  String get addingPicturesHelpsBetterQuotesText;

  /// No description provided for @howwouldYourateTradesmenText.
  ///
  /// In en, this message translates to:
  /// **'How would you rate the overall experience of tradesman?'**
  String get howwouldYourateTradesmenText;

  /// No description provided for @otpVerificationText.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerificationText;

  /// No description provided for @resendText.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendText;

  /// No description provided for @verifytext.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifytext;

  /// No description provided for @did_not_recieve_codeText.
  ///
  /// In en, this message translates to:
  /// **'I did\'nt recieve a code.'**
  String get did_not_recieve_codeText;

  /// No description provided for @otpVerificationScreentext.
  ///
  /// In en, this message translates to:
  /// **'Enter a Verification code we just sent \non your email address.'**
  String get otpVerificationScreentext;

  /// No description provided for @createNewPasswordDescText.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from \nprevious used password '**
  String get createNewPasswordDescText;

  /// No description provided for @forgotPasswordDescText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! it occurs, Please enter the \nemail address linked with your account.'**
  String get forgotPasswordDescText;

  /// No description provided for @sendCodeText.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCodeText;

  /// No description provided for @onBoardScreen1Heading.
  ///
  /// In en, this message translates to:
  /// **'Find the Right Help, Fast'**
  String get onBoardScreen1Heading;

  /// No description provided for @onBoardScreen2Heading.
  ///
  /// In en, this message translates to:
  /// **'Your Task, Our Experts'**
  String get onBoardScreen2Heading;

  /// No description provided for @onBoardScreen3Heading.
  ///
  /// In en, this message translates to:
  /// **'Get Your Tasks Done with \nEase'**
  String get onBoardScreen3Heading;

  /// No description provided for @onBoardScreen1Description.
  ///
  /// In en, this message translates to:
  /// **'Post your task and connect with skilled \nprofessionals nearby'**
  String get onBoardScreen1Description;

  /// No description provided for @onBoardScreen2Description.
  ///
  /// In en, this message translates to:
  /// **'From plumbing to painting, find trusted \ncraftsmen for every job'**
  String get onBoardScreen2Description;

  /// No description provided for @onBoardScreen3Description.
  ///
  /// In en, this message translates to:
  /// **'Simply upload, and let skilled professionals \nhandle the rest'**
  String get onBoardScreen3Description;

  /// No description provided for @signupSuccessDialogText.
  ///
  /// In en, this message translates to:
  /// **'You have succesfully registered \nand login.'**
  String get signupSuccessDialogText;

  /// No description provided for @tradesmenJobrequestMessageText.
  ///
  /// In en, this message translates to:
  /// **'I saw your profile and was impressed with your previous work. Would you be interested in helping with my kitchen renovation project?'**
  String get tradesmenJobrequestMessageText;

  /// No description provided for @deleteAccountDescText.
  ///
  /// In en, this message translates to:
  /// **'Deleting your profile will erase all account details, and you won’t be able to log in again.'**
  String get deleteAccountDescText;

  /// No description provided for @orderCompletedDescText.
  ///
  /// In en, this message translates to:
  /// **'Your order is complete, and you’ve done an absolutely fantastic job keep up the amazing work!'**
  String get orderCompletedDescText;

  /// No description provided for @eULAText.
  ///
  /// In en, this message translates to:
  /// **'This Agreement governs the use by the licensee (you) of the AuftragNow application (the Application), which is provided to the users by DMN Technology (hereafter DMN Technology or we). By using this Application, you assert that you have read and agree to this End User License Agreement (hereafter EULA or the Agreement). This EULA forms a legally binding agreement between you and DMN Technology. Please refrain from using this Application if you do not agree with this EULA'**
  String get eULAText;

  /// No description provided for @lisenceText.
  ///
  /// In en, this message translates to:
  /// **'LICENSE DMN Technology grants you a non-exclusive, limited, personal, revocable (in whole or in part) license to use the Application on a single Device, pursuant to this Agreement. You agree not to install, use or run the Application on any device other than a Device, or to enable others to do so. Subject to the limited rights expressly granted herein, DMN Technology reserves all its rights, titles, and interests in and to the Application, including all of its related intellectual property rights. No rights are granted to the User hereunder other than as expressly set forth herein. Although the Application is intended for your personal use only, you are responsible for anyone using the Application through your Device (whether you gave them permission or not), and for ensuring they understand and agree to this Agreement. This Agreement does not allow the Application to exist on more than one Device at a time, and you may not make the Application available over a network where it could be used by multiple Devices or multiple computers at the same time. This Agreement does not grant you any rights to use DMN Technology proprietary interfaces and other intellectual property rights in the design, development, manufacture, licensing or distribution of third-party devices and accessories, or third-party software Applications for use with the Device. The Application and/or Device may not be used for commercial or illegal purposes, in a way that may harm other people, companies, or their properties, or in any unauthorised or improper manner as might be specified from time to time in this Agreement or otherwise. You shall not (enable others to) modify, copy, decompile, reverse engineer, disassemble, attempt to derive the source code of, decrypt, or create derivative works based on the Application, including in particular its source and/or object code, or any part, feature, function, or user interface thereof, without DMN Technology\'s prior written consent (except as and only to the extent any foregoing restriction is prohibited by applicable law or to the extent as may be permitted by licensing terms governing use of open-source components that may be included with the Application). Similarly, you may not host, intercept or emulate any part of the Device or of the Application; You shall not (enable others to) use the Application to store, transmit, access or otherwise use any infringing, libellous, or otherwise unlawful or tortious materials, or to store, transmit, access or otherwise use any materials in violation of third-party rights, in particular privacy and/or intellectual property rights; you recognise that DMN Technology is not in any way responsible for any such use by (others enabled by) you, nor for any harassing, threatening, defamatory, offensive, infringing, or illegal messages or transmissions that you may receive as a result of using the Application and/or the Device; You shall not (enable others to) exploit the Application and/or the Device in any unauthorised way whatsoever or in any way harmful to you, the Application and/or Device or others, including but not limited to, using it to store, transmit, access or otherwise use any viruses, adware, spyware, worms, trojan horses or any other malware or harmful or malicious code, or by trespass or burdening network capacity; You shall not (enable others to) interfere with or disrupt the integrity or performance of the Application, its source and/or object code, or Third-Party Data contained therein; You shall not (enable others to) attempt to gain unauthorised access to the Application, its source and/or object code or its related systems or networks; You shall not remove, circumvent, disable, damage, or otherwise interfere with security-related features of the Device or Application, features that prevent or restrict use or copying of any Content accessible through the Application, features that enforce limitations on the use of the Application, or delete the copyright or other IP rights notices on the Application or Content, or attempt to circumvent any Content filtering techniques we employ, or attempt to access any Content or features of the Application that you are not authorised to access; You shall not (enable others to) modify, rent, lend, lease, sell, resell, license, sublicense, (re)distribute, make available, or create derivative works based on the Application and/or the Device or any part thereof, in any manner; You are solely responsible for the Content accessed through the Application and the consequences thereof. You recognise and agree that any Content is accessed at your own risk. You declare, represent, and warrant that your use of the Application is in compliance with the requirements of any applicable laws and regulations and does not infringe any third-party right, in particular intellectual property rights of third parties, including, but not limited to, copyright and related rights, trademark, patent, trade secret, moral right, privacy right, right of publicity, or any other intellectual property or proprietary right. Any Content data file, text, software, music phonographs, audio files, photos, videos, or any other form of audiovisual data displayed by, stored on, accessed, or otherwise used through the Application belongs to the respective Content owners. Such Content may be protected by copyright or other intellectual property laws and treaties and may be subject to terms and conditions of the third party providing such Content. The Application may be used to play back Content so long as such use is limited to the playback of non-copyrighted Content, Content in which the User owns the copyright, or Content that the User is authorised or legally permitted to playback or otherwise use. You must clear all Content or other Third-Party Data, and any other sensitive and/or personal information stored on your Device prior to selling or otherwise transferring your Device. You shall not use the Application and/or Device to engage in or to facilitate any activity that, directly or indirectly, (threatens to) exploit(s) or harm(s) children, nor to facilitate or engage in activity that is fraudulent, false, or misleading. DMN Technology reserves all rights and remedies against any Users who breach these representations and warranties. The Application is licensed to you for use on your Device only in the Designated Countries. At its sole discretion, DMN Technology may make available future updates and/or upgrades to the Application for your Device. The terms and conditions set out in this Agreement shall apply to any software updates and/or upgrades provided by DMN Technology that replace and/or supplement the original Application on your Device, unless such update and/or upgrade is accompanied by a separate license stipulating that its terms will apply, to the extent set out therein. By using the Application, you agree that DMN Technology may automatically download and install updates or upgrades to the Application onto your Device. Except for Essential Updates, you can turn off such automatic updates and/or upgrades in the settings, if applicable.'**
  String get lisenceText;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyText.
  ///
  /// In en, this message translates to:
  /// **'This page outlines our policies regarding the collection, use, and disclosure of Personal Information. By choosing to use our Service, you acknowledge that no personal information is collected or saved by us. This Privacy Policy explains our commitment to not collecting or storing your information. The terms used in this Privacy Policy have the same meanings as those in our Terms and Conditions, available through the AuftragNow App unless otherwise defined here.'**
  String get privacyPolicyText;

  /// No description provided for @privacyPolicyHeading1Text.
  ///
  /// In en, this message translates to:
  /// **'Information Collection and Use'**
  String get privacyPolicyHeading1Text;

  /// No description provided for @privacyPolicyHeading2Text.
  ///
  /// In en, this message translates to:
  /// **'Log Data'**
  String get privacyPolicyHeading2Text;

  /// No description provided for @privacyPolicyHeading3Text.
  ///
  /// In en, this message translates to:
  /// **'Cookies'**
  String get privacyPolicyHeading3Text;

  /// No description provided for @privacyPolicyHeading4Text.
  ///
  /// In en, this message translates to:
  /// **'Service Providers'**
  String get privacyPolicyHeading4Text;

  /// No description provided for @privacyPolicyHeading5Text.
  ///
  /// In en, this message translates to:
  /// **'E-mail Contact'**
  String get privacyPolicyHeading5Text;

  /// No description provided for @privacyPolicyHeading6Text.
  ///
  /// In en, this message translates to:
  /// **'Security of Data'**
  String get privacyPolicyHeading6Text;

  /// No description provided for @privacyPolicyHeading7Text.
  ///
  /// In en, this message translates to:
  /// **'Links to Other Sites'**
  String get privacyPolicyHeading7Text;

  /// No description provided for @privacyPolicyHeading8Text.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get privacyPolicyHeading8Text;

  /// No description provided for @privacyPolicyHeading9Text.
  ///
  /// In en, this message translates to:
  /// **'Updating This Privacy Policy'**
  String get privacyPolicyHeading9Text;

  /// No description provided for @privacyPolicyHeading10Text.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacyPolicyHeading10Text;

  /// No description provided for @privacyPolicyPoint1Text.
  ///
  /// In en, this message translates to:
  /// **'Our Service does not collect any personal information from its users. Therefore, we do not use or require any personal information for the use of our Service.'**
  String get privacyPolicyPoint1Text;

  /// No description provided for @privacyPolicyPoint2Text.
  ///
  /// In en, this message translates to:
  /// **'We do not collect Log Data. Users can access and use our Service without concerns of their data being logged or stored.'**
  String get privacyPolicyPoint2Text;

  /// No description provided for @privacyPolicyPoint3Text.
  ///
  /// In en, this message translates to:
  /// **'Our app does not use cookies directly. Since no personal information is collected, there are no cookies sent or stored on your device related to our Service.'**
  String get privacyPolicyPoint3Text;

  /// No description provided for @privacyPolicyPoint4Text.
  ///
  /// In en, this message translates to:
  /// **'We do not employ third-party companies or individuals for our Service. Therefore, there is no sharing, accessing, or use of your personal information by any third parties.'**
  String get privacyPolicyPoint4Text;

  /// No description provided for @privacyPolicyPoint5Text.
  ///
  /// In en, this message translates to:
  /// **'If you contact us via e-mail, we do not retain any personal data provided in your emails. Communication is solely for addressing your inquiries or feedback.'**
  String get privacyPolicyPoint5Text;

  /// No description provided for @privacyPolicyPoint6Text.
  ///
  /// In en, this message translates to:
  /// **'Since we do not collect any personal information, there are no risks associated with the security of your data in relation to our Service.'**
  String get privacyPolicyPoint6Text;

  /// No description provided for @privacyPolicyPoint7Text.
  ///
  /// In en, this message translates to:
  /// **'Our Service may contain links to other sites that are not operated by us. We advise you to review the Privacy Policy of these websites as we do not control and are not responsible for any content, privacy policies, or practices of any third-party sites or services.'**
  String get privacyPolicyPoint7Text;

  /// No description provided for @privacyPolicyPoint8Text.
  ///
  /// In en, this message translates to:
  /// **'Our Service does not target or collect information from anyone under the age of 15, as no personal information is collected from any user.'**
  String get privacyPolicyPoint8Text;

  /// No description provided for @privacyPolicyPoint9Text.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy may be updated periodically to reflect any changes to our practices concerning the non-collection of personal information. We encourage you to review this page periodically for any updates.'**
  String get privacyPolicyPoint9Text;

  /// No description provided for @privacyPolicyPoint10Text.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or suggestions about our Privacy Policy, please do not hesitate to contact us at info@auftragnow.com'**
  String get privacyPolicyPoint10Text;

  /// No description provided for @thisQuestionIsCompulsToAnsText.
  ///
  /// In en, this message translates to:
  /// **'This Question is compulsory to Answer'**
  String get thisQuestionIsCompulsToAnsText;

  /// No description provided for @toMore10TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 10 tradesmen to get additional asnwers'**
  String get toMore10TradesmenText;

  /// No description provided for @toMore9TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 9 tradesmen to get additional asnwers'**
  String get toMore9TradesmenText;

  /// No description provided for @toMore8TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 8 tradesmen to get additional asnwers'**
  String get toMore8TradesmenText;

  /// No description provided for @toMore7TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 7 tradesmen to get additional asnwers'**
  String get toMore7TradesmenText;

  /// No description provided for @toMore6TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 6 tradesmen to get additional asnwers'**
  String get toMore6TradesmenText;

  /// No description provided for @toMore5TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 5 tradesmen to get additional asnwers'**
  String get toMore5TradesmenText;

  /// No description provided for @toMore4TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 4 tradesmen to get additional asnwers'**
  String get toMore4TradesmenText;

  /// No description provided for @toMore3TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 3 tradesmen to get additional asnwers'**
  String get toMore3TradesmenText;

  /// No description provided for @toMore2TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 2 tradesmen to get additional asnwers'**
  String get toMore2TradesmenText;

  /// No description provided for @toMore1TradesmenText.
  ///
  /// In en, this message translates to:
  /// **'to more 1 tradesmen to get additional asnwers'**
  String get toMore1TradesmenText;

  /// No description provided for @messageNotSentText.
  ///
  /// In en, this message translates to:
  /// **'Message not Sent'**
  String get messageNotSentText;

  /// No description provided for @loadMoreText.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMoreText;

  /// No description provided for @nowText.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get nowText;

  /// No description provided for @startContractNowText.
  ///
  /// In en, this message translates to:
  /// **'Start Contract Now'**
  String get startContractNowText;

  /// No description provided for @markAsCompleteText.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get markAsCompleteText;

  /// No description provided for @jobHasBeenDoneText.
  ///
  /// In en, this message translates to:
  /// **'Job has been done'**
  String get jobHasBeenDoneText;

  /// No description provided for @jobText.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get jobText;

  /// No description provided for @areYouSureToCompleteThisContractText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to complete this contract?'**
  String get areYouSureToCompleteThisContractText;

  /// No description provided for @jobhasbeenCompletedText.
  ///
  /// In en, this message translates to:
  /// **'Job has been Completed!'**
  String get jobhasbeenCompletedText;

  /// No description provided for @yourJobstartedActiveNowActiveText.
  ///
  /// In en, this message translates to:
  /// **'Your Job is started and Active Now'**
  String get yourJobstartedActiveNowActiveText;

  /// No description provided for @chatIsClosedText.
  ///
  /// In en, this message translates to:
  /// **'Chat is Closed'**
  String get chatIsClosedText;

  /// No description provided for @taptoStartConversationText.
  ///
  /// In en, this message translates to:
  /// **'Tap to Start Conversation'**
  String get taptoStartConversationText;

  /// No description provided for @goBackText.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBackText;

  /// No description provided for @atLeast12CharactersText.
  ///
  /// In en, this message translates to:
  /// **'at least 12 characters'**
  String get atLeast12CharactersText;

  /// No description provided for @lowercaseText.
  ///
  /// In en, this message translates to:
  /// **'lowercase'**
  String get lowercaseText;

  /// No description provided for @uppercaseText.
  ///
  /// In en, this message translates to:
  /// **'uppercase'**
  String get uppercaseText;

  /// No description provided for @specialSymbolsText.
  ///
  /// In en, this message translates to:
  /// **'special symbols'**
  String get specialSymbolsText;

  /// No description provided for @numbersText.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbersText;

  /// No description provided for @pleaseEnterYourEmailText.
  ///
  /// In en, this message translates to:
  /// **'please Enter Your Email'**
  String get pleaseEnterYourEmailText;

  /// No description provided for @emailCannotBeEmptyText.
  ///
  /// In en, this message translates to:
  /// **'email Cannot Be Empty'**
  String get emailCannotBeEmptyText;

  /// No description provided for @newUserText.
  ///
  /// In en, this message translates to:
  /// **'new user'**
  String get newUserText;

  /// No description provided for @youCanNowLoginText.
  ///
  /// In en, this message translates to:
  /// **'you can now Login!'**
  String get youCanNowLoginText;

  /// No description provided for @bycreatingaccountyouAgreetoourText.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to Bitte geben Sie eine Bewertung abour'**
  String get bycreatingaccountyouAgreetoourText;

  /// No description provided for @andText.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get andText;

  /// No description provided for @nameCannotBeEmptyText.
  ///
  /// In en, this message translates to:
  /// **'name Cannot Be Empty'**
  String get nameCannotBeEmptyText;

  /// No description provided for @phoneCannotBeEmptyText.
  ///
  /// In en, this message translates to:
  /// **'phone Cannot Be Empty'**
  String get phoneCannotBeEmptyText;

  /// No description provided for @passwordCannotBeEmptyText.
  ///
  /// In en, this message translates to:
  /// **'password Cannot Be Empty'**
  String get passwordCannotBeEmptyText;

  /// No description provided for @confirmPasswordCannotBeEmptyText.
  ///
  /// In en, this message translates to:
  /// **'confirm Password Cannot Be Empty'**
  String get confirmPasswordCannotBeEmptyText;

  /// No description provided for @pleaseEnterValidPhoneText.
  ///
  /// In en, this message translates to:
  /// **'please enter a valid phone'**
  String get pleaseEnterValidPhoneText;

  /// No description provided for @pleaseFollowPasswordRulesText.
  ///
  /// In en, this message translates to:
  /// **'please Follow Password Rules'**
  String get pleaseFollowPasswordRulesText;

  /// No description provided for @passwordDoNotMatchText.
  ///
  /// In en, this message translates to:
  /// **'password Do Not Match'**
  String get passwordDoNotMatchText;

  /// No description provided for @typeaMessageText.
  ///
  /// In en, this message translates to:
  /// **'Type a Message...'**
  String get typeaMessageText;

  /// No description provided for @howyourExperiencewithtradesman.
  ///
  /// In en, this message translates to:
  /// **'How has your experience been with the tradesman?'**
  String get howyourExperiencewithtradesman;

  /// No description provided for @canYoutellusMore.
  ///
  /// In en, this message translates to:
  /// **'Can you tell us more?'**
  String get canYoutellusMore;

  /// No description provided for @pleaseExplaininyourownWordsText.
  ///
  /// In en, this message translates to:
  /// **'Please Explain in your own words'**
  String get pleaseExplaininyourownWordsText;

  /// No description provided for @reviewCannotbeemptyText.
  ///
  /// In en, this message translates to:
  /// **'review cannot be empty'**
  String get reviewCannotbeemptyText;

  /// No description provided for @pleaseGiveSomeRatingText.
  ///
  /// In en, this message translates to:
  /// **'please Give Some Rating'**
  String get pleaseGiveSomeRatingText;

  /// No description provided for @discardChangesText.
  ///
  /// In en, this message translates to:
  /// **'Discard changes!'**
  String get discardChangesText;

  /// No description provided for @areYouSureToEndJobPostingProcessText.
  ///
  /// In en, this message translates to:
  /// **'are you sure to End Job Posting Process?'**
  String get areYouSureToEndJobPostingProcessText;

  /// No description provided for @stepText.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get stepText;

  /// No description provided for @tellUsMoreAboutYourNeed.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about your need'**
  String get tellUsMoreAboutYourNeed;

  /// No description provided for @jobhasbeenpostedsuccessfullyText.
  ///
  /// In en, this message translates to:
  /// **'Your job has been posted successfully!'**
  String get jobhasbeenpostedsuccessfullyText;

  /// No description provided for @jobisnowliveandreadyText.
  ///
  /// In en, this message translates to:
  /// **'Your job is now live and ready to attract skilled professionals.'**
  String get jobisnowliveandreadyText;

  /// No description provided for @postingyourJobText.
  ///
  /// In en, this message translates to:
  /// **'Posting your Job...'**
  String get postingyourJobText;

  /// No description provided for @dragtomovePinText.
  ///
  /// In en, this message translates to:
  /// **'Drag to move pin to exact location'**
  String get dragtomovePinText;

  /// No description provided for @photosOfConstructionPlansOptional.
  ///
  /// In en, this message translates to:
  /// **'Photos of construction plans (optional)'**
  String get photosOfConstructionPlansOptional;

  /// No description provided for @max15MbFileText.
  ///
  /// In en, this message translates to:
  /// **'Max. 15 files, Max. 2 MB per file'**
  String get max15MbFileText;

  /// No description provided for @uploadFilesFromGalleryText.
  ///
  /// In en, this message translates to:
  /// **'upload files from Gallery'**
  String get uploadFilesFromGalleryText;

  /// No description provided for @pleaseLoginToSeeprofileText.
  ///
  /// In en, this message translates to:
  /// **'Please Login to See Your Profile'**
  String get pleaseLoginToSeeprofileText;

  /// No description provided for @selectText.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectText;

  /// No description provided for @requestHasSentText.
  ///
  /// In en, this message translates to:
  /// **'Request has sent'**
  String get requestHasSentText;

  /// No description provided for @activeWithinText.
  ///
  /// In en, this message translates to:
  /// **'active within'**
  String get activeWithinText;

  /// No description provided for @activeWithinOfText.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get activeWithinOfText;

  /// No description provided for @reviewedOnText.
  ///
  /// In en, this message translates to:
  /// **'Reviewed on'**
  String get reviewedOnText;

  /// No description provided for @seeourPrivacyPlolicyText.
  ///
  /// In en, this message translates to:
  /// **'See our Privacy Policy'**
  String get seeourPrivacyPlolicyText;

  /// No description provided for @youCanAdjustYourNotificationSettingText.
  ///
  /// In en, this message translates to:
  /// **'You can adjust your notification settings anytime.'**
  String get youCanAdjustYourNotificationSettingText;

  /// No description provided for @updatesOnJobsText.
  ///
  /// In en, this message translates to:
  /// **'Updates on Jobs'**
  String get updatesOnJobsText;

  /// No description provided for @markAllAsReadText.
  ///
  /// In en, this message translates to:
  /// **'mark all as read'**
  String get markAllAsReadText;

  /// No description provided for @nointerestedTradesmanDescriptionText.
  ///
  /// In en, this message translates to:
  /// **'No tradesman has expressed interest in your job yet. You can start a conversation once someone shows interest.'**
  String get nointerestedTradesmanDescriptionText;

  /// No description provided for @chatBoxIsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'You have not started chatting with tradesman yet. Start a chat to get you job done soon.'**
  String get chatBoxIsEmptyDescription;

  /// No description provided for @noRecommendedText.
  ///
  /// In en, this message translates to:
  /// **'No Recommended'**
  String get noRecommendedText;

  /// No description provided for @zeroAnswers.
  ///
  /// In en, this message translates to:
  /// **'0 Answers'**
  String get zeroAnswers;

  /// No description provided for @addressText.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressText;

  /// No description provided for @postcodeText.
  ///
  /// In en, this message translates to:
  /// **'postcode'**
  String get postcodeText;

  /// No description provided for @cityText.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityText;

  /// No description provided for @countryText.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryText;

  /// No description provided for @appliedText.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get appliedText;

  /// No description provided for @therequesthasbeenapproved.
  ///
  /// In en, this message translates to:
  /// **'The Request has been Accepted, now you an start Chat'**
  String get therequesthasbeenapproved;

  /// No description provided for @therequesthasbeendeclined.
  ///
  /// In en, this message translates to:
  /// **'The Request has been Declined'**
  String get therequesthasbeendeclined;

  /// No description provided for @weakText.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weakText;

  /// No description provided for @moderateText.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateText;

  /// No description provided for @goodText.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get goodText;

  /// No description provided for @strongText.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strongText;

  /// No description provided for @loginRequiredText.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequiredText;

  /// No description provided for @pleaseLoginToPostJobDescText.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in. Please log in to post your job. Once logged in, your post will be published.'**
  String get pleaseLoginToPostJobDescText;

  /// No description provided for @customRequestMessageText.
  ///
  /// In en, this message translates to:
  /// **'I saw your profile and was impressed with your previous work. Would you be interested doing this work?'**
  String get customRequestMessageText;

  /// No description provided for @allNotificationsMarkedAsReadText.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get allNotificationsMarkedAsReadText;

  /// No description provided for @filesLargerThan2MBSkippedText.
  ///
  /// In en, this message translates to:
  /// **'Files more than 2MB are Skipped'**
  String get filesLargerThan2MBSkippedText;

  /// No description provided for @youCanOnlyUploadUpTo.
  ///
  /// In en, this message translates to:
  /// **'you can only upload upto'**
  String get youCanOnlyUploadUpTo;

  /// No description provided for @ximages.
  ///
  /// In en, this message translates to:
  /// **'images'**
  String get ximages;

  /// No description provided for @onlyInfoText.
  ///
  /// In en, this message translates to:
  /// **'Only'**
  String get onlyInfoText;

  /// No description provided for @imagesCanBeAddMoreText.
  ///
  /// In en, this message translates to:
  /// **'images can be add more'**
  String get imagesCanBeAddMoreText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
