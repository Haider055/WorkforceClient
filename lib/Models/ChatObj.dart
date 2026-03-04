import 'package:workforceclientapp/Models/Message.dart';
import 'package:workforceclientapp/Models/Pagination2.dart';

class ChatObj {
  List<Message>? list;
  Pagination2? pagination;

  ChatObj({required this.list, required this.pagination});
}
