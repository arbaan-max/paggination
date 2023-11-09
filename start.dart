import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:store/debug/app_bloc_observer.dart';
import 'package:store/firebase_options.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// [startApplication] is the entry point of the application.
/// It creates the [MaterialApp] and starts the [runApp] function.
/// It also adds the [AppBlocObserver] to debug.
/// It is used to debug the application.
Future<void> startApplication(FutureOr<Widget> Function() builder) async {
  /// insureInitialization is used to insure that the initialization of the application is done.
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
  }

  /// [Firebase] is service that provides the backend services for the application.
  /// [initializeApp] is used to initialize the firebase app.
  /// [DefaultFirebaseOptions] is used to initialize the firebase app with the default options.
  /// [currentPlatform] is platform that the application is running on.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// firebase messaging for background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  /// [FlutterError.onError] are used to handle errors.
  FlutterError.onError =
      (details) => log(details.exceptionAsString(), stackTrace: details.stack);

  /// [AppBlocObserver] is used to debug the application.
  Bloc.observer = AppBlocObserver();

  /// [HydratedBloc.storage] is used to store the data of the application.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  final _ = await builder();
  return runApp(_);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// [displayNotification] is used to display the notification.
Future<void> displayNotification(RemoteMessage message) async {
  log('displayNotification ${message.toMap()}', name: 'displayNotification');

  try {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const androidNotificationDetails = AndroidNotificationDetails(
      'tingting-store',
      'TingTing-Store',
      channelDescription: 'TingTing Store Notification Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('tingting_store'),
      playSound: true,
      ongoing: true,
      enableLights: true,
      styleInformation: BigTextStyleInformation(
        'Ting-Ting Store Notification',
      ),
    );

    const iOSNotificationDetails = DarwinNotificationDetails();
    const macOSNotificationDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
      macOS: macOSNotificationDetails,
    );

    /// [show] is used to show the notification.
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  } on Exception catch (_) {
    throw Exception('Notification Display Error Occured!');
  }
}

// [_firebaseMessagingBackgroundHandler] is a top-level function that's
/// called when the app is in the background or terminated.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (_) {
    throw Exception('Firebase Initialization Error Occured!');
  }
}
