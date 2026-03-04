import 'package:workforceclientapp/Models/NotificationModel.dart';
import 'package:workforceclientapp/Models/Pagination2.dart';

class NotificationList {
  List<NotificationModel>? notificationsList = [];
  Pagination2? pagination;

  NotificationList({required this.notificationsList, required this.pagination});
}
