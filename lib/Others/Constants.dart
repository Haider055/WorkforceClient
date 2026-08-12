import 'dart:io';
import 'package:get/get.dart';
import 'package:simple_flutter_reverb/simple_flutter_reverb.dart';

class Constants {
  static const String baseUrl = "https://auftragnow.com/api";
  // static const String baseUrl = "https://service.ghostbear.pw/api";
  static const String googleMapsAPIkey =
      "AIzaSyBZz4unF-wEdjkLUM6jOI8TSKu8E-CisnM";
  static const String pusherAPIkey = "key-x8y7z6w5v4u3t2s1r0q9p8n7m6l5k4j3";

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static String signupEmail = "";
  static String signupPassword = "";

  static List<Map<String, dynamic>> questionsList = [];
  static String selectedServiceName = "";
  static String jobTitle = "";
  static int selectedServiceId = 0;
  static int jobPostingSteps = 0;
  static RxInt currentJobPostingStep = 0.obs;
  static String jobPostingAddress = "";
  static String jobPostingCountry = "";
  static String jobPostingCity = "";
  static String jobPostingState = "";
  static String jobPostingPostcode = "";
  static String jobPostingLat = "";
  static String jobPostingLng = "";
  static String jobDescription = "";
  static List<File> selectedImages = [];
  static String fromWhere = "";
  static String emailToVerify = "";
  static int remainingRequestsCount = 0;
  static RxInt unReadcount = 0.obs;
  static RxInt unreadNotificationsCount = 0.obs;
  static RxBool fromNotifications = false.obs;
  static RxBool titleTVFocus = true.obs;
  static RxBool descTVFocus = true.obs;

  static int lastPostedJobId = 0;
  static late final SimpleFlutterReverb reverb;
  // static Message message;
}
