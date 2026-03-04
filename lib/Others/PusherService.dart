// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';
// import 'dart:developer';

// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:workforceclientapp/Others/Commons.dart';
// import 'package:workforceclientapp/Others/Constants.dart';
// import 'package:http/http.dart' as http;

// class PusherService {
//   PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

//   String APP_ID = "APP_ID";
//   String API_KEY = Constants.baseUrl;
//   String SECRET = "SECRET";
//   String API_CLUSTER = "mt1";

//   Future<void> initPusher() async {
//     pusher = PusherChannelsFlutter.getInstance();
//     final token = await Commons.getUserToken();
//     print(Constants.pusherAPIkey);
//     print(token);
//     try {
//       await pusher.init(
//         apiKey: Constants.pusherAPIkey,
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
//       await pusher.connect();
//     } catch (e) {
//       print('Pusher init error: $e');
//     }
//   }
// }
