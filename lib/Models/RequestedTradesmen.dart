import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/TradesmenRequest.dart';

class RequestedTradesmen {
  List<TradesmenRequest>? tradesmenRequestList;
  Pagination? pagination;

  RequestedTradesmen(
      {required this.tradesmenRequestList, required this.pagination});
}
