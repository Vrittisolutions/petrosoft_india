

/*class PushNotificationService {

  final FirebaseMessaging _fcm;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  PushNotificationService(this._fcm);

  Future initialise() async {
    initializeNotification();

    String messageTitle = "Empty";
    String messageTitle1 = "Empty";
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
        onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          messageTitle = message["notification"]["title"];
          String title= messageTitle.replaceAll("\"","");
          showNotification(title);

        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          messageTitle1 = message["notification"]["title"];
          String title= messageTitle1.replaceAll("\"","");
          messageTitle = message["notification"]["body"];
          showNotification(title);
        }


    );
    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _fcm.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
  }
  void initializeNotification() async {
    try {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings();
      var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
      await _fcm.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }
  void showNotification(String title) async {
    // title.Replace('"', ' ').Trim();
    await _demoNotification(title);
  }

  Future<void> _demoNotification(String title) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        // sound: 'sound',
        showProgress: true,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, "", platformChannelSpecifics);
  }
}*/


