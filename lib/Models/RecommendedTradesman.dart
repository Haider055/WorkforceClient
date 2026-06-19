import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/Tradesmen.dart';

class RecommendedTradesman {
  List<Tradesmen> tradesmenList;
  Pagination? pagination;

  RecommendedTradesman({
    required this.tradesmenList,
    required this.pagination,
  });
}
