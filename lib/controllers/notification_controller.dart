import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/model/notification/notification_data.dart';
import 'package:water/repository/notification_repository.dart' as notificationRepo;

class NotificationController extends ControllerMVC {
  NotificationData? notificationData;

  void getNotificationListsApi() async {
    notificationRepo.getNotificationList().then((value) {
      notificationData = NotificationData.fromJson(value.data);
      setState(() {});
    }).catchError((e) {
      commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }

  void getNotificationDeleteApi() async {
    notificationRepo.getNotificationDelete().then((value) {
      notificationData!.notification = [];
      setState(() {});
    }).catchError((e) {
      commonAlertNotification("Error", message: UtilsHelper.getString(null, "something_went_wrong"));
    }).whenComplete(() {});
  }

}