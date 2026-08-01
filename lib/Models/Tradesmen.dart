import 'package:get/get.dart';
import 'package:workforceclientapp/Models/ServiceArea.dart';
import 'package:workforceclientapp/Models/Services.dart';
import 'package:workforceclientapp/Models/TradesmenProfile.dart';

class Tradesmen {
  int? id;
  String? name;
  String? profileImg;
  String? memberSince;
  int? reviewsCount;
  int? jobsCompleted;
  String? rating;
  TradesmenProfile? tradesmenProfile;
  ServiceArea? serviceArea;
  List<Services>? servicesList;
  RxString status = "not sent".obs;

  Tradesmen(
      {this.id,
      this.name,
      this.profileImg,
      this.rating,
      this.tradesmenProfile,
      this.serviceArea,
      this.memberSince,
      this.servicesList,
      this.jobsCompleted,
      this.reviewsCount});

  factory Tradesmen.fromJson(Map<String, dynamic> json) {
    List<Services> servicesList1 = [];
    if (json.containsKey('categories')) {
      if (json['categories'] != null) {
        Iterable l = json['categories'];
        servicesList1 =
            List<Services>.from(l.map((model) => Services.fromJson(model)));
      }
    }
    return Tradesmen(
        id: json['id'],
        name: json['name'],
        profileImg: json['profile_img'],
        memberSince: json['member_since'],
        serviceArea: json['service_area'] == null
            ? null
            : ServiceArea.fromJson(json['service_area']),
        tradesmenProfile: json['trade_person_profile'] == null
            ? null
            : TradesmenProfile.fromJson(json['trade_person_profile']),
        rating: json['rating'],
        reviewsCount: json['reviews_count'],
        jobsCompleted: json['jobs_completed'] ?? 0,
        servicesList: servicesList1);
  }
}
