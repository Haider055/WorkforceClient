import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Models/BlockedUser.dart';
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class BlockPeopleController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxList<BlockedChat> blockedList = <BlockedChat>[].obs;
  Pagination? pagination;

  @override
  void onInit() {
    super.onInit();
    loadBlockedChats(1);
  }

  Future<void> loadBlockedChats(int page) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      }
      isLoadingMore.value = true;
      final result = await pleaseGetBlockedChats(Get.context!, page);
      if (result != null) {
        if (page == 1) {
          blockedList.value = result.list;
        } else {
          blockedList.addAll(result.list);
        }
        pagination = result.pagination;
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (pagination == null) return;
    if (!(pagination!.hasMore ?? false)) return;
    if (isLoadingMore.value) return;
    await loadBlockedChats((pagination!.currentPage ?? 1) + 1);
  }

  Future<BlockedChatsList?> pleaseGetBlockedChats(
      BuildContext context, int page) async {
    try {
      List<BlockedChat> list = [];

      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/blocks?page=$page'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            List<dynamic> dataList = jsonData['data'];
            for (var item in dataList) {
              if (item != null && item is Map<String, dynamic>) {
                list.add(BlockedChat.fromJson(item));
              }
            }
          }

          Pagination? pagination;
          if (jsonData.keys.contains('pagination')) {
            pagination = Pagination.fromJson(jsonData['pagination']);
          }

          return BlockedChatsList(list: list, pagination: pagination);
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return BlockedChatsList(list: list, pagination: null);
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return null;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return BlockedChatsList(list: list, pagination: null);
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      debugPrint('pleaseGetBlockedChats error: $e');
      return null;
    }
  }

  Future<bool> pleaseUnblockUser(BuildContext context, int userId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${Constants.baseUrl}/blocks/$userId'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          Fluttertoast.showToast(
              msg: jsonData['message'] ?? "User unblocked successfully");
          return true;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return false;
      } else {
        String msg = jsonData['message'] ?? Strings.somethingWentWrong(context);
        Fluttertoast.showToast(msg: msg);
        return false;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      debugPrint('pleaseUnblockUser error: $e');
      return false;
    }
  }

  Future<void> unblockAndRemove(
      BuildContext context, BlockedChat blocked) async {
    final success = await pleaseUnblockUser(context, blocked.userId ?? 0);
    if (success) {
      blockedList.remove(blocked);
      Get.find<AllChatsContoller>().refreshData();
    }
  }
}
