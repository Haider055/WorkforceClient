import 'package:workforceclientapp/Models/Chat.dart';
import 'package:workforceclientapp/Models/Pagination.dart';

class ChatsList {
  List<Chat> list;
  Pagination? pagination;

  ChatsList({required this.list, required this.pagination});
}
