import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/ViewModel/cubits/balance_screen/balance_screen_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/sign_in_cubit/sign_in_cubit.dart';
import '/View/screens/signin_screen.dart';
import '/ViewModel/database/cache_helper/cache_helper.dart';
import '/color_const.dart';
import '/utils/page_route.dart';
import '/view/components/core/alert_message.dart';
import '/view/screens/signup_screen.dart';

class AlertToLogOut extends StatelessWidget {
  const AlertToLogOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var preferenceCubit = PreferenceCubit.get(context);
    var balanceCubit = BalanceScreenCubit.get(context);
    var cubit = SignInCubit.get(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.05),
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          // TODO: implement listener
          if(state is SignOutWithEmailSuccess){
            // cubit.changeLoadingIndecatorState(false);
            AppNavigator.customNavigator(context: context, screen: SigninScreen(), finish: true);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              AlertDialogWithDeleteButton(
                hintText: "",
                height: 0,
                messageText: "Are you sure that you want to log out of your account?",
                buttonText: "Log Out",
                onTap: () async {
                  cubit.changeLoadingIndecatorState(true);
                  await CacheHelper.setData(key: 'uid', value: 'ROkuqkbItLHg7b2Z2HYL');
                  await GetStorage().write('email', "newUser");
                  await cubit.googleSignOut();
                  await cubit.emailSignOut();
                  balanceCubit.clearAllData();
                  preferenceCubit.clearCurrentUserModel();
                  cubit.changeLoadingIndecatorState(false);
                },),
              if(cubit.loadingIndecator)
                LoadingIndicator(),
            ],
          );
        },
      ),
    );
  }
}
