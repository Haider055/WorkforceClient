import 'package:get/get.dart';
import 'package:workforceclientapp/Models/PostedJobAnswers.dart';

class PostedJobDetail {
  int? id;
  String? title;
  String? desc;
  String? location;
  String? lat;
  String? lng;
  String? city;
  String? state;
  String? country;
  String? postcode;
  RxString? status = "".obs;
  int? serviceId;
  RxString? tradespersonRequestsCount = "".obs;
  RxInt? tradespersonApplicationsCount = 0.obs;
  RxInt? inContactTradesmenCount = 0.obs;
  String? serviceName;
  int? requiredConnects;
  List<PostedJobAnswers>? jobAnswers = [];
  List<String>? imageList = [];
  String? createdAt;
  String? humanReadableCreatedAt;

  PostedJobDetail({
    this.id,
    this.title,
    this.desc,
    this.location,
    this.lat,
    this.lng,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.status,
    this.tradespersonRequestsCount,
    this.tradespersonApplicationsCount,
    this.inContactTradesmenCount,
    this.serviceId,
    this.serviceName,
    this.requiredConnects,
    this.createdAt,
    this.humanReadableCreatedAt,
    this.jobAnswers,
    this.imageList,
  });

  factory PostedJobDetail.fromJson(Map<String, dynamic> json) {
    List<PostedJobAnswers>? jobAnswersList = [];
    List<String>? imagesList = [];

    if (json.keys.contains('answers')) {
      Iterable l = json['answers'];
      jobAnswersList = List<PostedJobAnswers>.from(
          l.map((model) => PostedJobAnswers.fromJson(model)));
    }
    if (json.keys.contains('attachments')) {
      List<dynamic> attachmentList = json['attachments'];
      for (var i = 0; i < attachmentList.length; i++) {
        imagesList.add(attachmentList[i]);
      }
    }

    return PostedJobDetail(
      id: json['id'],
      title: json['title'],
      desc: json['description'],
      location: json['location'],
      lat: json['lat'],
      lng: json['lng'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postcode: json['postcode'],
      serviceId: json['service']['id'],
      serviceName: json['service']['name'],
      status: json['status'].toString().obs,
      requiredConnects: json['required_connects'],
      createdAt: json['created_at'],
      humanReadableCreatedAt: json['human_readable_created_at'],
      tradespersonRequestsCount:
          (json['tradesperson_requests_count']?.toString() ?? "").obs,
      inContactTradesmenCount: ((json['in_contacts_count'] ?? 0) as int).obs,
      tradespersonApplicationsCount:
          ((json['applications_count'] ?? 0) as int).obs,
      jobAnswers: jobAnswersList,
      imageList: imagesList,
    );
  }
}
