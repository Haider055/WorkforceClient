import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/PostedJobDetail.dart';

class PostedOrders {
  List<PostedJobDetail>? postedJobsList;
  Pagination? pagination;

  PostedOrders({required this.postedJobsList, required this.pagination});

}
