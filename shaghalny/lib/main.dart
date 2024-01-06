import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_background/flutter_background.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shaghalny/View/screens/edit_personal_info.dart';
import 'package:shaghalny/ViewModel/cubits/change_profile_pic/change_profile_pic_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/check_in_out_cubit/check_in_out_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/data_cubit/data_cubit.dart';

import 'package:get_storage/get_storage.dart';
import 'package:shaghalny/View/screens/Alerts/complaint_submitted.dart';
import 'package:shaghalny/View/screens/Alerts/congrats.dart';
import 'package:shaghalny/View/screens/Alerts/contract_signed_successfully.dart';
import 'package:shaghalny/View/screens/Alerts/delete_account.dart';
import 'package:shaghalny/View/screens/Alerts/delete_application.dart';
import 'package:shaghalny/View/screens/Alerts/log_out.dart';
import 'package:shaghalny/View/screens/Alerts/save_changes.dart';
import 'package:shaghalny/View/screens/Alerts/sign_the_contract.dart';
import 'package:shaghalny/View/screens/Alerts/to_apply_for_job.dart';
import 'package:shaghalny/View/screens/Alerts/to_complete_info.dart';
import 'package:shaghalny/View/screens/check_in_out.dart';
import 'package:shaghalny/View/screens/education_screen.dart';
import 'package:shaghalny/View/screens/warning_screen.dart';
// import 'package:workmanager/workmanager.dart';
import '/utils/notification_service.dart';
import 'View/components/core/timer_button.dart';
import 'View/screens/apply_for_job_screen.dart';
import 'View/screens/balance_screen.dart';
import 'View/screens/bank_information_screen.dart';
import 'View/screens/basic_info_signup_screen.dart';
import 'View/screens/bottom_navigation_screen.dart';
import 'View/screens/contract_screen.dart';
import 'View/screens/education_scanner.dart';
import 'View/screens/employer_page_screen.dart';
import 'View/screens/forget_password_screen.dart';
import 'View/screens/home_screen.dart';
import 'View/screens/id_confirmation_screen.dart';
import 'View/screens/on_boarding/on_boarding_screen.dart';
import 'View/screens/reviews_screen.dart';
import 'View/screens/signin_screen.dart';
import 'View/screens/signup_screen.dart';
import 'View/screens/splash_screen.dart';
import 'View/screens/test_screen.dart';
import 'View/screens/verify_number.dart';
import 'View/screens/warning_notification_screen.dart';
import 'ViewModel/cubits/ID_scan_cubit/id_scan_cubit.dart';
import 'ViewModel/cubits/apply_for_job_cubit/apply_for_job_cubit.dart';
import 'ViewModel/cubits/balance_screen/balance_screen_cubit.dart';
import 'ViewModel/cubits/bank_information_cubit/bank_information_cubit.dart';
import 'ViewModel/cubits/bloc_observer.dart';
import 'ViewModel/cubits/complaints_review_cubit/complaint_review_cubit.dart';
import 'ViewModel/cubits/edit_info_cubit/edit_info_cubit.dart';
import 'ViewModel/cubits/education_scanner_cubit/education_scanner_cubit.dart';
import 'ViewModel/cubits/education_screen_cubit/education_cubit.dart';
import 'ViewModel/cubits/employer_page_cubit/employer_page_cubit.dart';
import 'ViewModel/cubits/home_cubit/home_cubit.dart';
import 'ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'ViewModel/cubits/notifications_cubit/notifications_cubit.dart';
import 'ViewModel/cubits/pic_id_cubit/pic_id_cubit.dart';
import 'ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'ViewModel/cubits/profile_cubit/profile_cubit.dart';
import 'ViewModel/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'ViewModel/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'ViewModel/cubits/verify_number_cubit/vertify_number_cubit.dart';
import 'ViewModel/database/cache_helper/cache_helper.dart';
import 'color_const.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

bool shouldUseFirebaseEmulator = false;
late final FirebaseApp app;
late final FirebaseAuth auth;

// @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     print("Task executing :" + taskName);
//     return Future.value(true);
//   });
// }


Future main() async {



  WidgetsFlutterBinding.ensureInitialized();
  // HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory: await getTemporaryDirectory(),
  // );

  // NotificationService().initNotification();


  app = await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  auth = FirebaseAuth.instanceFor(app: app);
  if (shouldUseFirebaseEmulator) {
    await auth.useAuthEmulator('localhost', 9099);
  }
  await GetStorage.init();
  await CacheHelper.init();


  // await Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  // );

  // runApp(const MyApp());

  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(MultiBlocProvider(
        providers: [
          GetStorage().read('uid') != null ?
          BlocProvider(
              create: (context) => PreferenceCubit()
                ..getUser(id: GetStorage().read('uid'))
                ..getAdmin())
          : BlocProvider(
              create: (context) => PreferenceCubit()
                ..getUser()
                ..getAdmin()),
          GetStorage().read('uid') != null ?
          BlocProvider(create: (context) => NotificationsCubit()..getNotifications(userId: GetStorage().read('uid'), prefCubit: PreferenceCubit.get(context)))
          : BlocProvider(create: (context) => NotificationsCubit()),
          // BlocProvider(create: (context) => NotificationsCubit()),
          BlocProvider(create: (context) => IdScanCubit()),
          BlocProvider(create: (context) => CheckInOutCubit()),
          BlocProvider(create: (context) => SignUpCubit()),
          BlocProvider(create: (context) => EducationCubit()),
          BlocProvider(create: (context) => ComplaintReviewCubit()),
          BlocProvider(create: (context) => EditInfoCubit()),
          BlocProvider(create: (context) => PicCubit()),
          BlocProvider(create: (context) => BankInformationCubit()),
          BlocProvider(create: (context) => SignInCubit()),
          BlocProvider(create: (context) => HomeCubit()),
          BlocProvider(create: (context) => ApplyForJobCubit()),
          BlocProvider(create: (context) => EducationScannerCubit()),
          BlocProvider(create: (context) => VertifyNumberCubit()),
          BlocProvider(create: (context) => BalanceScreenCubit(PreferenceCubit.get(context))),
          BlocProvider(create: (context) => ChangeProfilePicCubit()),
          BlocProvider(create: (context) => JobsCubit()),
          BlocProvider(create: (context) => DataCubit()),
          BlocProvider(create: (context) => ProfileCubit()),
          // BlocProvider(create: (context) => ChangeProfilePicCubit()),

        ],
        child: const MyApp(),
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  GetStorage().remove('email');
    // GetStorage().remove('uid');
    String email = GetStorage().read('email') ?? "newUser";
    String id = GetStorage().read('uid') ?? "oldUser";
    // print(email);
    // print(id);
    // debugPrint("\n\n firebase id ==> ${FirebaseAuth.instance.currentUser!.uid.} \n\n");

    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Parajob',
            // home:  WarningNotificationScreen(),
            home: email == "newUser"
                ? id == "oldUser"
                    // ? BlocProvider(
                    //     create: (context) => PreferenceCubit()
                    //       ..getUser()
                    //       ..getAdmin(),
                    //     child: Splash(newUser: true),
                    //   )
                    // : BlocProvider(
                    //     create: (context) => PreferenceCubit()
                    //       ..getUser()
                    //       ..getAdmin(),
                    //     child: Splash(newUser: false),
                    //   )

                ? Splash(newUser: true)
            : Splash(newUser: false)
                : Splash(newUser: false, toNavigation: true,));
      },
    );
  }
}
