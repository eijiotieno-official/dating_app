import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dating_app/main.dart';

class NotificationListenerService {
  static ReceivedAction? initialAction;

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == "READ") {
      MainApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/home', (route) => (route.settings.name != '/home') || route.isFirst,
          arguments: receivedAction);
    }
  }
}
