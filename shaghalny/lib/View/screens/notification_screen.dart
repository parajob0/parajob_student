import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/View/screens/check_in_out.dart';
import 'package:shaghalny/View/screens/jobs_screen.dart';
import 'package:shaghalny/View/screens/profile_screen.dart';
import 'package:shaghalny/View/screens/warning_notification_screen.dart';
import '/View/components/core/custom_text.dart';

import '../../ViewModel/cubits/notifications_cubit/notifications_cubit.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../color_const.dart';
import '../../utils/notification_service.dart';
import '../components/notifications_screen/notification_container.dart';
import 'apply_for_job_screen.dart';
import 'bottom_navigation_screen.dart';

class NotificationScreen extends StatelessWidget {

   const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    NotificationsCubit notiCubit = BlocProvider.of<NotificationsCubit>(context, listen: true);

    return Scaffold(
      backgroundColor: primary,
      body: Builder(
        builder: (context) {
          Timestamp now = Timestamp.now();
          return notiCubit.gotNotifications
              ? notiCubit.notificationModel.isNotEmpty
              ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                    builder: (context) {
                      Duration d = now.toDate().difference(notiCubit.notificationModel[notiCubit.notificationModel.length - 1].date.toDate());
                      return Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 60.h, 0.w, 8.h),
                        child: CustomText(
                            text: d.inDays > 1 ? d.inHours > 24 && d.inHours < 48 ? "Yesterday" : "Earlier" : "Today",
                            weight: FontWeight.w500,
                            size: 14.sp,
                            color: Colors.white.withOpacity(0.7)),
                      );
                    }
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notiCubit.notificationModel.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.sp),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {

                      Duration date = now.toDate().difference(notiCubit.notificationModel[index].date.toDate());

                      return InkResponse(
                        onTap: (){
                          if(notiCubit.notificationModel[index].type == 'contract') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyForJobScreen(model: notiCubit.notificationModel[index].jobModel!)));
                          }
                          //todo finish the navigation here
                          else if(notiCubit.notificationModel[index].type == 'qr'){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyForJobScreen(model: notiCubit.notificationModel[index].jobModel!)));
                          }
                          else if(notiCubit.notificationModel[index].type == 'warning'){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WarningNotificationScreen()));
                          }
                          else if(notiCubit.notificationModel[index].type == 'accept'){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation(index: 1)));
                          }
                          else if(notiCubit.notificationModel[index].type == 'level'){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation(index: 3)));
                          }
                          notiCubit.changeNotificationStatus(notiCubit.notificationModel[index], notiCubit.notificationModel[index].id);
                        },
                        child: NotificationContainer(
                          notificationType: notiCubit
                              .notificationModel[index].type,
                          imageUrl: notiCubit.notificationModel[index].jobModel != null ? notiCubit.notificationModel[index]
                              .jobModel!.employerModel.image : '',
                          employer: notiCubit.notificationModel[index].jobModel != null ? notiCubit.notificationModel[index]
                              .jobModel!.employerModel.name : '',
                          position: notiCubit.notificationModel[index].jobModel!= null ?  notiCubit.notificationModel[index]
                              .jobModel!.position: '',
                          level: preferenceCubit.userModel!.level as int,
                          isClicked: notiCubit.notificationModel[index].isOpened,
                          date: date.inSeconds > 60 ? date.inMinutes > 60 ? date.inHours > 24 && date.inHours < 48 ? "${date.inHours}h" : " ${notiCubit.notificationModel[index].date.toDate().day} ${DateFormat('MMMM').format(notiCubit.notificationModel[index].date.toDate())} ${notiCubit.notificationModel[index].date.toDate().year}" : "${date.inMinutes}m" : "${date.inSeconds}s",
                        ),
                      );
                    }),
              ],
            ),
          )
              : Center(
            child: CustomText(
                text: "No Notifications yet",
                weight: FontWeight.w600,
                size: 16.sp,
                color: Colors.white.withOpacity(0.7)),
          )
              : const Center(
            child: CircularProgressIndicator(
              color: secondary,
            ),
          );
        }
      ),
      //
      // body: BlocProvider(
      //   create: (context) =>
      //   NotificationsCubit()
      //     ..getNotifications(userId: preferenceCubit.userModel!.id.toString(), prefCubit: preferenceCubit),
      //   child: BlocConsumer<NotificationsCubit, NotificationsState>(
      //     listener: (context, state) {
      //       // TODO: implement listener
      //     },
      //     builder: (context, state) {
      //       NotificationsCubit notiCubit = NotificationsCubit.get(context);
      //
      //       // notiCubit.getUnseenNotifications(notiCubit.notificationModel);
      //
      //       Timestamp now = Timestamp.now();
      //
      //       return notiCubit.gotNotifications
      //           ? notiCubit.notificationModel.isNotEmpty
      //           ? SingleChildScrollView(
      //         physics: const BouncingScrollPhysics(),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Builder(
      //                 builder: (context) {
      //                   Duration d = now.toDate().difference(notiCubit.notificationModel[notiCubit.notificationModel.length - 1].date.toDate());
      //                   return Padding(
      //                     padding: EdgeInsets.fromLTRB(24.w, 60.h, 0.w, 8.h),
      //                     child: CustomText(
      //                         text: d.inHours < 24 ? d.inHours > 24 && d.inHours < 48 ? "Yesterday" : "Earlier" : "Today",
      //                         weight: FontWeight.w500,
      //                         size: 14.sp,
      //                         color: Colors.white.withOpacity(0.7)),
      //                   );
      //                 }
      //             ),
      //             ListView.builder(
      //                 physics: const NeverScrollableScrollPhysics(),
      //                 itemCount: notiCubit.notificationModel.length,
      //                 shrinkWrap: true,
      //                 padding: EdgeInsets.all(0.sp),
      //                 scrollDirection: Axis.vertical,
      //                 itemBuilder: (BuildContext context, int index) {
      //
      //                   Duration date = now.toDate().difference(notiCubit.notificationModel[index].date.toDate());
      //
      //                   return InkResponse(
      //                     onTap: (){
      //                       if(notiCubit.notificationModel[index].type == 'contract') {
      //                         Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyForJobScreen(model: notiCubit.notificationModel[index].jobModel!)));
      //                       }
      //                       //todo finish the navigation here
      //                       else if(notiCubit.notificationModel[index].type == 'qr'){}
      //                       else if(notiCubit.notificationModel[index].type == 'warning'){}
      //                       else if(notiCubit.notificationModel[index].type == 'accept'){
      //                         Navigator.push(context, MaterialPageRoute(builder: (context) => const JobsScreen()));
      //                       }
      //                       else if(notiCubit.notificationModel[index].type == 'level'){
      //                         Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
      //                       }
      //                       notiCubit.changeNotificationStatus(notiCubit.notificationModel[index], notiCubit.notificationModel[index].id);
      //                     },
      //                     child: NotificationContainer(
      //                       notificationType: notiCubit
      //                           .notificationModel[index].type,
      //                       imageUrl: notiCubit.notificationModel[index].jobModel != null ? notiCubit.notificationModel[index]
      //                           .jobModel!.employerModel.image : '',
      //                       employer: notiCubit.notificationModel[index].jobModel != null ? notiCubit.notificationModel[index]
      //                           .jobModel!.employerModel.name : '',
      //                       position: notiCubit.notificationModel[index].jobModel!= null ?  notiCubit.notificationModel[index]
      //                           .jobModel!.position: '',
      //                       level: preferenceCubit.userModel!.level as int,
      //                       isClicked: notiCubit.notificationModel[index].isOpened,
      //                       date: date.inMinutes > 60 ? date.inHours > 24 ? "${date.inDays}d" : "${date.inHours}h" : "${date.inMinutes}m",
      //                     ),
      //                   );
      //                 }),
      //           ],
      //         ),
      //       )
      //           : Center(
      //         child: CustomText(
      //             text: "No Notifications yet",
      //             weight: FontWeight.w600,
      //             size: 16.sp,
      //             color: Colors.white.withOpacity(0.7)),
      //       )
      //           : const Center(
      //         child: CircularProgressIndicator(
      //           color: secondary,
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}