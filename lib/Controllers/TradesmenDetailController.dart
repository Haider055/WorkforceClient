import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/Portfolio.dart';
import 'package:workforceclientapp/Models/Reviews.dart';
import 'package:workforceclientapp/Models/Services.dart';
import 'package:workforceclientapp/Models/Tradesmen.dart';
import 'package:workforceclientapp/Models/TradesmenReview.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class TradesmenDetailController extends GetxController {
  late SharedPreferences _prefs;

  final searchController = TextEditingController().obs;
  RxInt portfolioBackColor = MyColors.themeRedColor.obs;
  RxInt reviewsBackColor = MyColors.silverColor.obs;
  RxInt portfolioTextColor = MyColors.whiteColor.obs;
  RxInt reviewsTextColor = MyColors.darkGrayColor.obs;
  RxString selectedOption = "portfolio".obs;
  RxList<Services> professionsList = <Services>[].obs;
  TradesmenReview? tradesmenReview;
  RxList<Reviews>? reviewList = <Reviews>[].obs;
  RxList<Portfolio>? portfolioList;

  final RxBool loadMore = true.obs;
  final RxBool loadingReviews = true.obs;
  RxBool loading = true.obs;
  RxInt tradesmenId = 0.obs;
  RxInt totalReviews = 0.obs;
  RxInt totalPortfolio = 0.obs;

  Tradesmen? tradesmen;

  @override
  void onInit() {
    super.onInit();
    tradesmenId.value = Get.arguments['tradesmenId'];
    if (tradesmenId == -1) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return;
    }
    getTradesmenObject();
  }

  Future<Tradesmen?> pleaseGetTradesmenDetail(int id) async {
    Tradesmen? tradesmen;
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/tradeperson/$id'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('trade_person')) {
              // List<dynamic> servicesList = jsonData['services'];
              tradesmen = Tradesmen.fromJson(dataObj['trade_person']);
            }
          }

          return tradesmen;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return tradesmen;
        }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return tradesmen;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<TradesmenReview?> pleaseGetTradesmenReviews(int id, int page) async {
    TradesmenReview? tradesmenReview;
    List<Reviews> list = [];
    Pagination pagination = Pagination();
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/tradeperson/reviews/$id?page=$page'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            Iterable l = jsonData['data'];
            list =
                List<Reviews>.from(l.map((model) => Reviews.fromJson(model)));
          }
          if (jsonData.keys.contains('pagination')) {
            pagination = Pagination.fromJson(jsonData['pagination']);
          }
          tradesmenReview =
              TradesmenReview(reviewsList: list, pagination: pagination);

          return tradesmenReview;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return tradesmenReview;
        }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return tradesmenReview;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Portfolio>> pleaseGetTradesmenPortfolio(int id) async {
    List<Portfolio> list = [];
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/tradeperson/portfolio/$id'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.containsKey('portfolios')) {
              if (dataObj['portfolios'] != null) {
                Iterable l = dataObj['portfolios'];
                list = List<Portfolio>.from(
                    l.map((model) => Portfolio.fromJson(model)));
              }
            }
          }

          return list;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return list;
        }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return list;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void getTradesmenObject() async {
    try {
      tradesmen = await pleaseGetTradesmenDetail(tradesmenId.value);
      if (tradesmen != null) {
        if (tradesmen!.servicesList != null) {
          for (var i = 0; i < tradesmen!.servicesList!.length; i++) {
            professionsList.add(tradesmen!.servicesList!.elementAt(i));
          }
        }
        getTradesmenPortfolios(tradesmenId.value);
      } else {
        Fluttertoast.showToast(
            msg: Strings.somethingWentWrongGettingResults(Get.context!));
      }
    } catch (e) {
      e.printError();
    }
  }

  void getTradesmenReviews(int page) async {
    try {
      if (tradesmenId == -1) {
        Fluttertoast.showToast(
            msg: Strings.somethingWentWrongLoadingReviews(Get.context!));
        return;
      }
      tradesmenReview =
          await pleaseGetTradesmenReviews(tradesmenId.value, page);
      if (tradesmenReview != null) {
        if (tradesmenReview!.reviewsList != null) {
          reviewList!.addAll(tradesmenReview!.reviewsList!);
          if (tradesmenReview!.pagination != null) {
            totalReviews.value = tradesmenReview!.pagination!.total ?? 0;
          }
          loadMore.value = false;
          loadingReviews.value = false;
        }
      }
    } catch (e) {
      e.printError();
    }
  }

  void getTradesmenPortfolios(int tradesmenId) async {
    try {
      if (tradesmenId == -1) {
        Fluttertoast.showToast(
            msg: Strings.somethingWentWrongLoadingPortfolio(Get.context!));
        return;
      }
      portfolioList = <Portfolio>[].obs;
      portfolioList!.value = await pleaseGetTradesmenPortfolio(tradesmenId);
      totalPortfolio.value = portfolioList!.length;
      loading.value = false;
    } catch (e) {
      e.printError();
    }
  }
}
