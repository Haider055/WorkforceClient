// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';
// import 'dart:developer';

// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:workforceclientapp/Others/Commons.dart';
// import 'package:workforceclientapp/Others/Constants.dart';
// import 'package:http/http.dart' as http;

// class PusherConfig {
//   late PusherChannelsFlutter _pusher;

//   String APP_ID = "APP_ID";
//   String API_KEY = Constants.baseUrl;
//   String SECRET = "SECRET";
//   String API_CLUSTER = "mt1";

//   Future<void> initPusher(onEvent,
//       {channelName = "private-chat", roomId}) async {
//     _pusher = PusherChannelsFlutter.getInstance();
//     final token = await Commons.getUserToken();

//     // try {
//     //   await _pusher.init(
//     //     apiKey: API_KEY,
//     //     cluster: API_CLUSTER,
//     //     onConnectionStateChange: onConnectionStateChange,
//     //     onError: onError,
//     //     onSubscriptionSucceeded: onSubscriptionSucceeded,
//     //     onEvent: onEvent,
//     //     onSubscriptionError: onSubscriptionError,
//     //     onDecryptionFailure: onDecryptionFailure,
//     //     onMemberAdded: onMemberAdded,
//     //     onMemberRemoved: onMemberRemoved,
//     //     authEndpoint: "${Constants.baseUrl}/broadcasting/auth",
//     //     onAuthorizer: (channelName, socketId, options) async {
//     //       try {
//     // final token = await Commons.getUserToken();
//     //         final authUrl = '${Constants.baseUrl}/broadcasting/auth';

//     //         final response = await http.post(
//     //           Uri.parse(authUrl),
//     //           headers: {
//     //             'Content-Type': 'application/x-www-form-urlencoded',
//     //             'Authorization': 'Bearer $token',
//     //           },
//     //           body: 'socket_id=$socketId&channel_name=$channelName',
//     //         );

//     //         if (response.statusCode == 200) {
//     //           final Map<String, dynamic> data = jsonDecode(response.body);
//     //           log("Authorization successful: $data");
//     //           return data;
//     //         } else {
//     //           log("Authorization failed: ${response.statusCode} ${response.body}");
//     //           return {}; // Returning empty map to prevent crash
//     //         }
//     //       } catch (e) {
//     //         log("Authorization error: $e");
//     //         return {}; // Return empty map on error
//     //       }
//     //     },
//     //   );

//     //   // Connect first
//     //   await _pusher.connect();

//     //   // Then subscribe to the channel
//     //   await _pusher.subscribe(
//     //     channelName: "$channelName.$roomId",
//     //   );
//     //   log("Subscribed to channel: $channelName.$roomId");
//     // } catch (e) {
//     //   log("Pusher initialization error: $e");
//     // }
//     try {
//       await _pusher.init(
//         apiKey: API_KEY,
//         cluster: 'mt1',
//         authEndpoint: 'https://auftragnow.com/api/broadcasting/auth',
//         authParams: {
//           'headers': {'Authorization': 'Bearer $token'}
//         },
//         useTLS: true,
//         activityTimeout: 3000,
//         pongTimeout: 1200,
//         maxReconnectionAttempts: 6,
//         maxReconnectGapInSeconds: 30,
//         onConnectionStateChange: (currentState, previousState) {
//           print('Connection State: $currentState');
//         },
//         onError: (message, code, e) {
//           print('Pusher Error: $message (Code: $code)');
//         },
//         onEvent: (event) {
//           print('Event: ${event.eventName} | Data: ${event.data}');
//         },
//         onSubscriptionSucceeded: (channelName, data) {
//           print('Subscribed to $channelName');
//         },
//       );
//       await _pusher.connect();
//     } catch (e) {
//       print('Pusher init error: $e');
//     }
//   }

//   void disconnect() {
//     _pusher.disconnect();
//   }

//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     log("Connection: $currentState");
//   }

//   void onError(String message, int? code, dynamic e) {
//     log("onError: $message code: $code exception: $e");
//   }

//   void onEvent(PusherEvent event) {
//     log("onEvent: $event");
//   }

//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     log("onSubscriptionSucceeded: $channelName data: $data");
//     final me = _pusher.getChannel(channelName)?.me;
//     log("Me: $me");
//   }

//   void onSubscriptionError(String message, dynamic e) {
//     log("onSubscriptionError: $message Exception: $e");
//   }

//   void onDecryptionFailure(String event, String reason) {
//     log("onDecryptionFailure: $event reason: $reason");
//   }

//   void onMemberAdded(String channelName, PusherMember member) {
//     log("onMemberAdded: $channelName user: $member");
//   }

//   void onMemberRemoved(String channelName, PusherMember member) {
//     print("onMemberRemoved: $channelName user: $member");
//   }

//   void onSubscriptionCount(String channelName, int subscriptionCount) {
//     log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
//   }

//   dynamic onAuthorizer(
//       String channelName, String socketId, dynamic options) async {
//     log(socketId.toString());
//     // ignore: prefer_typing_uninitialized_variables
//     var json;
//     String token = await Commons.getUserToken();

//     try {
//       var authUrl = '${Constants.baseUrl}/broadcasting/auth';
//       log('socket_id=' + socketId + '&channel_name=' + channelName);
//       // UserData userData = await StorageHelper.getUserData();
//       var result = await http.post(
//         Uri.parse(authUrl),
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//           'Authorization': 'Bearer $token',
//         },
//         body: 'socket_id=' + socketId + '&channel_name=' + channelName,
//       );
//       log("result: " + result.body.toString());
//       try {
//         json = jsonDecode(result.body);
//       } catch (e) {
//         return {};
//       }

//       log(json.toString());

//       return json;
//     } catch (e) {
//       log("Error :" + e.toString());
//     }
//   }
// }
