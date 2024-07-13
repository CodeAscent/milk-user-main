import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/display_format.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Widgets/empty_notification_screen.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/controllers/notification_controller.dart';
import 'package:water/model/notification/notification.dart';
import 'package:water/repository/notification_repository.dart';

import 'shimmers/address_list_shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends StateMVC<NotificationScreen> {
  _NotificationScreenState() : super(NotificationController()) {
    con = controller as NotificationController;
  }

  late NotificationController con;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      con.getNotificationListsApi();
      notificationCount.value = 0;
      setState(() { });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      bottomNavigationBar: con.notificationData != null &&
              (con.notificationData?.notification?.length ?? 0) > 0
          ? Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  con.getNotificationDeleteApi();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UtilsHelper.getString(null, "clear"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsHelper.the_sans_font_family,
                            color: MyColor.textPrimaryLightColor,
                          ),
                    )
                  ],
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => MyColor.commonColorSet2!),
                ),
              ),
            )
          : SizedBox(height: 0),
      body: con.notificationData != null &&
          (con.notificationData?.notification?.length ?? 0) == 0 ?
          EmptyNotificationScreen(onTap: () {
            // Navigator.of(context).pushReplacementNamed(RoutePath.home_screen);
            Navigator.pop(context);
          }) : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: headerWidget(
              title: UtilsHelper.getString(context, 'notification'),
              onPress: () {
                Navigator.of(context).pop();
              },
              context: context,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 27,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    con.notificationData == null
                        ? AddressListShimmer()
                        : ((con.notificationData?.notification?.length ?? 0) == 0
                            ? Center(
                                child: Text(
                                  UtilsHelper.getString(
                                      context, 'data_not_available'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontFamily: lang == 'en'
                                            ? 'Helvetica'
                                            : 'TheSans',
                                      ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.zero,
                                itemCount: con.notificationData?.notification
                                        ?.length ?? 0,
                                itemBuilder: (context, index) {
                                  NotificationItem notificationItem = con
                                      .notificationData!.notification![index];
                                  return Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: Container(
                                          color: MyColor.coreBackgroundColor,
                                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notificationItem.title ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                      fontFamily: lang == 'en'
                                                          ? 'Helvetica'
                                                          : 'TheSans',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: MyColor
                                                          .textPrimaryDarkColor,
                                                    ),
                                              ),
                                              SizedBox(height: 8),
                                              // Icon(Icons.keyboard_arrow_down),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      notificationItem
                                                              .message ??
                                                          "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                            fontFamily: lang ==
                                                                    'en'
                                                                ? 'Helvetica'
                                                                : 'TheSans',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            // color: MyColor.textPrimaryDarkColor,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                    getDayFormat(
                                                        notificationItem
                                                            .createdAt,
                                                        ddMMYYYYFormat),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall
                                                        ?.copyWith(
                                                          fontFamily:
                                                              lang == 'en'
                                                                  ? 'Helvetica'
                                                                  : 'TheSans',
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: MyColor
                                                              .textPrimaryDarkColor,
                                                        ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 17,
                                      )
                                    ],
                                  );
                                },
                              )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
