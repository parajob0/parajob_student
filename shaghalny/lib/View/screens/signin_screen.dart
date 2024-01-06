import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shaghalny/View/components/core/buttons.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/View/screens/verify_number.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/utils/page_route.dart';
import 'package:shaghalny/utils/snackbar.dart';

import '../../ViewModel/cubits/sign_in_cubit/sign_in_cubit.dart';
import '../../ViewModel/database/cache_helper/cache_helper.dart';
import '../../color_const.dart';
import '../components/core/text_field.dart';
import '../components/signin_screen/dont_have_account.dart';
import '../components/signin_screen/remember_me.dart';
import 'approval_screen.dart';
import 'bottom_navigation_screen.dart';
import 'home_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({Key? key}) : super(key: key);
 static GlobalKey<FormState> emailKey = new GlobalKey<FormState>();
 static  GlobalKey<FormState> passwordKey = new GlobalKey<FormState>();

  static TextEditingController emailController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SignInCubit signInCubit = BlocProvider.of<SignInCubit>(context, listen: true);
    JobsCubit jobsCubit = BlocProvider.of<JobsCubit>(context, listen: true);
    PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: primary,
            body: SingleChildScrollView(
              child: Container(
                // width: 1.sw,
                height: 1.sh - 0.04.sh,
                padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50.h),
                        CustomText(
                          text: "Welcome back",
                          weight: FontWeight.w600,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 40.h),
                        BlocConsumer<SignInCubit, SignInState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return DefaultTextField(
                              hintText: "Enter your email",
                              formKey: emailKey,
                              controller: emailController,
                              onchange: (val) {
                                print(val);
                              },
                              onTap: () async {
                                if (emailController.text.isEmpty &&
                                    passwordController.text.isEmpty) {
                                  String? email =
                                  await CacheHelper.getData(key: 'email');
                                  String? password =
                                  await CacheHelper.getData(key: 'password');
                                  if (email != null && password != null) {
                                    emailController.text = email;
                                    passwordController.text = password;
                                    print("enable remember me");
                                  }
                                }
                              },
                              errorBorder: signInCubit.emailErrorBorder,
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                        BlocConsumer<SignInCubit, SignInState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return DefaultTextField(
                              formKey: passwordKey,
                              hintText: "Enter your password",
                              isSecure: true,
                              controller: passwordController,
                              onchange: (val) {
                                print(val);
                              },
                              errorBorder: signInCubit.passwordErrorBorder,
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                        BlocConsumer<SignInCubit, SignInState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return RememberMe(
                              value: signInCubit.rememberMe,
                              cubit: signInCubit,
                            );
                          },
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0.h),
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 8.h),
                          BlocConsumer<SignInCubit, SignInState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return CustomText(
                                text: signInCubit.errorMessage,
                                weight: FontWeight.w400,
                                size: 14.sp,
                                color: Colors.red,
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                          BlocConsumer<SignInCubit, SignInState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return BlocConsumer<JobsCubit, JobsState>(
                                listener: (context, state) {
                                  // TODO: implement listener
                                },
                                builder: (context, state) {
                                  return PrimaryButton(
                                      text: 'Sign in',
                                      fontSize: 13,
                                      onTap: () async {
                                        bool email = false;
                                        bool password = false;
                                        signInCubit.changeLoadingIndecatorState(true);
                                        if (emailController.text.isNotEmpty) {
                                          signInCubit.changeEmailErrorMessage(false);
                                          email = true;
                                        }
                                        else {
                                          signInCubit.changeEmailErrorMessage(true);
                                        }

                                        if (passwordController.text.isNotEmpty) {
                                          signInCubit.changePasswordErrorMessage(false);
                                          password = true;
                                        }
                                        else {
                                          signInCubit.changePasswordErrorMessage(true);
                                        }

                                        signInCubit.changeErrorMessage();

                                        if (email && password) {
                                          // TODO submit
                                          await signInCubit.signInWithEmailAndPassword(
                                              jobsCubit: jobsCubit,
                                              preferenceCubit: preferenceCubit,
                                              email: emailController.text,
                                              password: passwordController.text,
                                              context: context).then((value) async {
                                            if (value) {
                                              //TODO NAVIGATE TO HOME SCREEN AFTER SIGN IN
                                              if(preferenceCubit.userModel!.isBanned){
                                                snackbarMessage("This user is banned from using the app", context);
                                                signInCubit.changeLoadingIndecatorState(false);
                                              }
                                              else if(!preferenceCubit.userModel!.isApproved && preferenceCubit.userModel!.accountName != ""){
                                                signInCubit.changeLoadingIndecatorState(false);
                                                AppNavigator.customNavigator(context: context, screen: const ApprovalScreen(), finish: true);
                                              }
                                              else{
                                                if (signInCubit.rememberMe) {
                                                  await CacheHelper.put(
                                                      key: 'email',
                                                      value: emailController.text);
                                                  await CacheHelper.put(
                                                      key: 'password',
                                                      value: passwordController.text);
                                                  GetStorage().write('email', emailController.text);
                                                }
                                                // await jobsCubit.fillJobs(context);
                                                signInCubit.changeLoadingIndecatorState(false);
                                                AppNavigator.customNavigator(context: context, screen: BottomNavigation(index: 0,), finish: true);
                                              }
                                            }
                                            else {
                                              // TODO SIGN IN WITH EMAIL FAILED SHOW ERROR MESSAGE
                                              signInCubit.setErrorMessage("User doesn't exists");
                                              signInCubit.changeLoadingIndecatorState(false);
                                              // snackbarMessage("Email doesn't exist", context);
                                              print("Email doesn't exist");
                                            }
                                          });
                                        }
                                        else {
                                          signInCubit.changeLoadingIndecatorState(
                                              false);
                                        }
                                      });
                                },
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          BlocConsumer<SignInCubit, SignInState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return BlocConsumer<PreferenceCubit, PreferenceState>(
                                listener: (context, state) {
                                  // TODO: implement listener
                                },
                                builder: (context, state) {
                                  var preferenceCubit = PreferenceCubit.get(context);
                                  return TertiaryButton(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Logo(
                                          Logos.google,
                                          size: 24.h,
                                        ),
                                        SizedBox(width: 10.w),
                                        CustomText(
                                          text: "Sign in with Google",
                                          weight: FontWeight.w600,
                                          size: 10.sp,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      //TODO NEXT DESTINATION AFTER SIGNING IN WITH GOOGLE
                                      await signInCubit.signInWithGoogle(preferenceCubit: preferenceCubit, jobsCubit: jobsCubit, context: context).then((
                                          value) {});
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 16.h),

                          if(Platform.isIOS)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                BlocConsumer<SignInCubit, SignInState>(
                                  listener: (context, state) {
                                    // TODO: implement listener
                                  },
                                  builder: (context, state) {
                                    return BlocConsumer<PreferenceCubit, PreferenceState>(
                                      listener: (context, state) {
                                        // TODO: implement listener
                                      },
                                      builder: (context, state) {
                                        var preferenceCubit = PreferenceCubit.get(context);

                                        // return SignInButton(
                                        //   Buttons.Apple,
                                        //   text: "Sign in with Apple",
                                        //   onPressed: () async{
                                        //     //TODO NEXT DESTINATION AFTER SIGNING IN WITH GOOGLE
                                        //     await signInCubit.signInWithApple(preferenceCubit: preferenceCubit, jobsCubit: jobsCubit, context: context).then((
                                        //         value) {});
                                        //   },
                                        // );

                                        return TertiaryButton(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Logo(
                                                Logos.apple,
                                                size: 24.h,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10.w),
                                              CustomText(
                                                text: "Sign in with Apple",
                                                weight: FontWeight.w600,
                                                size: 10.sp,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                          onTap: () async {
                                            //TODO NEXT DESTINATION AFTER SIGNING IN WITH GOOGLE
                                            await signInCubit.signInWithApple(preferenceCubit: preferenceCubit, jobsCubit: jobsCubit, context: context).then((
                                                value) {});
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          dontHaveAnAccount(context,preferenceCubit),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // floatingActionButton: Padding(
            //   padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0.w),
            //   child: Column(
            //     // mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       SizedBox(height: 8.h),
            //       BlocConsumer<SignInCubit, SignInState>(
            //         listener: (context, state) {
            //           // TODO: implement listener
            //         },
            //         builder: (context, state) {
            //           return CustomText(
            //             text: signInCubit.errorMessage,
            //             weight: FontWeight.w400,
            //             size: 14.sp,
            //             color: Colors.red,
            //           );
            //         },
            //       ),
            //       SizedBox(height: 8.h),
            //       BlocConsumer<SignInCubit, SignInState>(
            //         listener: (context, state) {
            //           // TODO: implement listener
            //         },
            //         builder: (context, state) {
            //           return BlocConsumer<JobsCubit, JobsState>(
            //             listener: (context, state) {
            //               // TODO: implement listener
            //             },
            //             builder: (context, state) {
            //               return PrimaryButton(
            //                   text: 'Sign in',
            //                   onTap: () async {
            //                     bool email = false;
            //                     bool password = false;
            //                     signInCubit.changeLoadingIndecatorState(true);
            //                     if (emailController.text.isNotEmpty) {
            //                       signInCubit.changeEmailErrorMessage(false);
            //                       email = true;
            //                     }
            //                     else {
            //                       signInCubit.changeEmailErrorMessage(true);
            //                     }
            //
            //                     if (passwordController.text.isNotEmpty) {
            //                       signInCubit.changePasswordErrorMessage(false);
            //                       password = true;
            //                     }
            //                     else {
            //                       signInCubit.changePasswordErrorMessage(true);
            //                     }
            //
            //                     signInCubit.changeErrorMessage();
            //
            //                     if (email && password) {
            //                       // TODO submit
            //                       await signInCubit.signInWithEmailAndPassword(
            //                         jobsCubit: jobsCubit,
            //                           preferenceCubit: preferenceCubit,
            //                           email: emailController.text,
            //                           password: passwordController.text,
            //                           context: context).then((value) async {
            //                         if (value) {
            //                           //TODO NAVIGATE TO HOME SCREEN AFTER SIGN IN
            //                           if(preferenceCubit.userModel!.isBanned){
            //                             snackbarMessage("This user is banned from using the app", context);
            //                             signInCubit.changeLoadingIndecatorState(false);
            //                           }
            //                           else if(!preferenceCubit.userModel!.isApproved){
            //                             signInCubit.changeLoadingIndecatorState(false);
            //                             AppNavigator.customNavigator(context: context, screen: const ApprovalScreen(), finish: true);
            //                           }
            //                           else{
            //                             if (signInCubit.rememberMe) {
            //                               await CacheHelper.put(
            //                                   key: 'email',
            //                                   value: emailController.text);
            //                               await CacheHelper.put(
            //                                   key: 'password',
            //                                   value: passwordController.text);
            //                               GetStorage().write('email', emailController.text);
            //                             }
            //                             // await jobsCubit.fillJobs(context);
            //                             signInCubit.changeLoadingIndecatorState(false);
            //                             AppNavigator.customNavigator(context: context, screen: BottomNavigation(index: 0,), finish: true);
            //                           }
            //                         }
            //                         else {
            //                           // TODO SIGN IN WITH EMAIL FAILED SHOW ERROR MESSAGE
            //                           signInCubit.setErrorMessage("User doesn't exists");
            //                           signInCubit.changeLoadingIndecatorState(false);
            //                           // snackbarMessage("Email doesn't exist", context);
            //                           print("Email doesn't exist");
            //                         }
            //                       });
            //                     }
            //                     else {
            //                       signInCubit.changeLoadingIndecatorState(
            //                           false);
            //                     }
            //                   });
            //             },
            //           );
            //         },
            //       ),
            //       SizedBox(height: 16.h),
            //       BlocConsumer<SignInCubit, SignInState>(
            //         listener: (context, state) {
            //           // TODO: implement listener
            //         },
            //         builder: (context, state) {
            //           return BlocConsumer<PreferenceCubit, PreferenceState>(
            //             listener: (context, state) {
            //               // TODO: implement listener
            //             },
            //             builder: (context, state) {
            //               var preferenceCubit = PreferenceCubit.get(context);
            //               return TertiaryButton(
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Logo(
            //                       Logos.google,
            //                       size: 24.h,
            //                     ),
            //                     SizedBox(width: 10.w),
            //                     CustomText(
            //                       text: "Sign in with Google",
            //                       weight: FontWeight.w600,
            //                       size: 16.sp,
            //                       color: Colors.white,
            //                     ),
            //                   ],
            //                 ),
            //                 onTap: () async {
            //                   //TODO NEXT DESTINATION AFTER SIGNING IN WITH GOOGLE
            //                   await signInCubit.signInWithGoogle(preferenceCubit: preferenceCubit, jobsCubit: jobsCubit, context: context).then((
            //                       value) {});
            //                 },
            //               );
            //             },
            //           );
            //         },
            //       ),
            //       SizedBox(height: 16.h),
            //       BlocConsumer<SignInCubit, SignInState>(
            //         listener: (context, state) {
            //           // TODO: implement listener
            //         },
            //         builder: (context, state) {
            //           return BlocConsumer<PreferenceCubit, PreferenceState>(
            //             listener: (context, state) {
            //               // TODO: implement listener
            //             },
            //             builder: (context, state) {
            //               var preferenceCubit = PreferenceCubit.get(context);
            //               return TertiaryButton(
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     CustomText(
            //                       text: "Sign in with Apple",
            //                       weight: FontWeight.w600,
            //                       size: 16.sp,
            //                       color: Colors.white,
            //                     ),
            //                   ],
            //                 ),
            //                 onTap: () async {
            //                   //TODO NEXT DESTINATION AFTER SIGNING IN WITH GOOGLE
            //                   await signInCubit.signInWithApple(preferenceCubit: preferenceCubit, jobsCubit: jobsCubit, context: context).then((
            //                       value) {});
            //                 },
            //               );
            //             },
            //           );
            //         },
            //       ),
            //       SizedBox(height: 16.h),
            //       dontHaveAnAccount(context,preferenceCubit),
            //     ],
            //   ),
            // ),
            // floatingActionButtonLocation:
            // FloatingActionButtonLocation.centerFloat,
          ),
          BlocConsumer<SignInCubit, SignInState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return (signInCubit.loadingIndecator == true)
                  ? const LoadingIndicator()
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}