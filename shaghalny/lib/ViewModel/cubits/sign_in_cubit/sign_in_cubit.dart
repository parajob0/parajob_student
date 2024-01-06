import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import '../../../View/screens/approval_screen.dart';
import '/View/screens/signup_screen.dart';
import '/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import '/utils/page_route.dart';
import '/utils/snackbar.dart';
import '../../../View/screens/bottom_navigation_screen.dart';
import '../../database/cache_helper/cache_helper.dart';
import '../preference_cubit/preference_cubit.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  static SignInCubit get(context) => BlocProvider.of<SignInCubit>(context);
  bool? emailErrorBorder = false;
  bool? passwordErrorBorder = false;
  bool rememberMe = false;
  bool loadingIndecator = false;
  String errorMessage = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void changeEmailErrorMessage(bool val) {
    emailErrorBorder = val;
    emit(ChangeErrorMessage());
  }

  void changePasswordErrorMessage(bool val) {
    passwordErrorBorder = val;
    emit(ChangeErrorMessage());
  }

  void changeErrorMessage() {
    if (emailErrorBorder == true && passwordErrorBorder == true) {
      errorMessage = "Wrong email and password!";
    } else if (emailErrorBorder == true) {
      errorMessage = "Wrong email!";
    } else if (passwordErrorBorder == true) {
      errorMessage = "Wrong password";
    } else {
      errorMessage = "";
    }

    emit(ChangeErrorMessage());
  }

  void changeLoadingIndecatorState(bool x) {
    loadingIndecator = x;
    emit(ChangeLoadingIndecatorState());
  }

  void setErrorMessage(String s) {
    errorMessage = s;
    emit(SetErrorMessage());
  }

  void changeRememberMeValue() {
    rememberMe = !rememberMe;
    emit(ChangeRememberMeValue());
  }

  Future<void> signInWithGoogle(
      {required PreferenceCubit preferenceCubit,
      required JobsCubit jobsCubit,
      required context}) async {
    try {
      debugPrint("\n\n in sign in with google function \n\n");
      emit(SignInWithGoogleLoading());
      changeLoadingIndecatorState(true);
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential authResult =
          await _auth.signInWithCredential(authCredential);

      User? user = authResult.user;
      String email = user?.email ?? "";
      String uid = user?.uid ?? "";
      String name = user?.displayName ?? "";

      debugPrint("\n\n email -> $email");
      debugPrint("\n\n uid -> $uid");
      debugPrint("\n\n name -> $name");
      var prefereceCubit = PreferenceCubit.get(context);
      prefereceCubit.userModel?.email = email;

      List<String> names = name.split(" ");

      if (names.length > 1) {
        prefereceCubit.userModel?.firstName = (name.split(" ")[0]);
        prefereceCubit.userModel?.lastName = (name.split(" ")[1]);
      } else {
        prefereceCubit.userModel?.firstName = (name.split(" ")[0]);
        prefereceCubit.userModel?.lastName = "";
      }
      prefereceCubit.userModel!.id = uid;
      prefereceCubit.userModel!.externalSignIn = true;

      debugPrint(
          "\n\n user id from google sign in screen --> ${prefereceCubit.userModel!.id} \n\n");
      // UserModel.setFirstName;
      // UserModel.setLastName(name.split(" ")[1]);
      // UserModel.setID(uid);
      // UserModel.setSignedInUsingGoogle(true);

      bool does_User_exist = await doesUserExist(uid: uid);
      print("does_User_exist");
      print(does_User_exist);
      //TODO save uid in cache_helper " With Google"
      await CacheHelper.put(key: 'uid', value: uid);

      // false -> add new phone number and create account
      // true  -> just login
      if (does_User_exist) {
        // get phone number
        print(does_User_exist);
        bool is_phone_empty = await isPhoneNumberEmpty(uid: uid);

        if (is_phone_empty) {
          // if phone number is empty -> navigate to signupScreen
          AppNavigator.customNavigator(
              context: context, screen: SignupScreen(), finish: false);
        } else {
          // else -> navigate to BottomNavigation
          print("-----------------------");
          print(uid);
          print("-----------------------");
          GetStorage().write('uid', uid);
          GetStorage().write('email', email);

          await preferenceCubit.getUser(id: uid ?? "");
          await jobsCubit.fillJobs(preferenceCubit, context);

          if (prefereceCubit.userModel!.isBanned) {
            snackbarMessage("This user is banned from using the app", context);
            changeLoadingIndecatorState(false);
            // emit(SignInWithGoogleFail());
          } else if (!preferenceCubit.userModel!.isApproved && preferenceCubit.userModel!.accountName != "") {
            changeLoadingIndecatorState(false);
            AppNavigator.customNavigator(
                context: context, screen: const ApprovalScreen(), finish: true);
          } else {
            AppNavigator.customNavigator(
                context: context,
                screen: BottomNavigation(
                  index: 0,
                ),
                finish: true);
          }
          snackbarMessage("signin successfully", context);
        }
      } else {
        //TODO GET ALL DATA FROM USER AND CRAETE NEW ACCOUNT
        print(uid);

        // we need to crate account when user users signInWithGoogle
        // to save id from google auth
        await createNewUser(
            uid: uid, email: email, phoneNumber: "", name: "", first_name: prefereceCubit.userModel!.firstName.toString(), last_name: prefereceCubit.userModel!.lastName.toString());
        snackbarMessage("User created", context);

        GetStorage().write('uid', uid);
        GetStorage().write('email', email);
        AppNavigator.customNavigator(
            context: context, screen: SignupScreen(), finish: false);
      }
      changeLoadingIndecatorState(false);

      emit(SignInWithGoogleSucccess());
    } catch (e) {
      print("error");
      changeLoadingIndecatorState(false);
      print(e.toString());
      emit(SignInWithGoogleFail());
    }
  }

  Future<void> signInWithApple(
      {required PreferenceCubit preferenceCubit,
      required JobsCubit jobsCubit,
      required context}) async {
    try {
      emit(SignInWithAppleLoading());



      AuthorizationResult authorizationResult =
      await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (authorizationResult.status) {
        case AuthorizationStatus.authorized:
          print("authorized");
          try {
            AppleIdCredential appleCredentials = authorizationResult.credential!;
            OAuthProvider oAuthProvider = OAuthProvider("apple.com");
            OAuthCredential oAuthCredential = oAuthProvider.credential(
                idToken: String.fromCharCodes(appleCredentials.identityToken!),
                accessToken:
                String.fromCharCodes(appleCredentials.authorizationCode!));
            debugPrint(appleCredentials.email);
            debugPrint(appleCredentials.fullName.toString());
            UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
            if (userCredential.user != null) {
              String email = appleCredentials.email ?? "";
              String uid = userCredential.user!.uid ?? "";
              var name = appleCredentials.fullName ?? "";

              debugPrint("\n\n user credentials\n");
              debugPrint("\n\n eeemail -> ${userCredential.user!.email}");
              debugPrint("\n\n uid -> $uid");
              debugPrint("\n\n name -> ${userCredential.user!.displayName}");


              debugPrint("apple credentials\n");
              debugPrint("\n\n eeemail -> ${appleCredentials.email}");
              debugPrint("\n\n uid -> $uid");
              debugPrint("\n\n user -> ${appleCredentials.user}");
              debugPrint("\n\n given name -> ${appleCredentials.fullName!.givenName}");
              debugPrint("\n\n family name -> ${appleCredentials.fullName!.familyName}");


              var prefereceCubit = PreferenceCubit.get(context);
              prefereceCubit.userModel?.email = email;

              // List<String> names = name.split(" ");
              //
              // if (names.length > 1) {
              //   prefereceCubit.userModel?.firstName = (name.split(" ")[0]);
              //   prefereceCubit.userModel?.lastName = (name.split(" ")[1]);
              // } else {
              //   prefereceCubit.userModel?.firstName = (name.split(" ")[0]);
              //   prefereceCubit.userModel?.lastName = "";
              // }

              if(appleCredentials.fullName!.familyName != null){
                prefereceCubit.userModel?.firstName = appleCredentials.fullName!.givenName;
                prefereceCubit.userModel?.lastName = appleCredentials.fullName!.familyName;
              }
              else if(appleCredentials.fullName!.givenName != null){
                prefereceCubit.userModel?.firstName = appleCredentials.fullName!.givenName;
                prefereceCubit.userModel?.lastName = "";
              }
              else{
                prefereceCubit.userModel?.firstName = "";
                prefereceCubit.userModel?.lastName = "";
              }

              prefereceCubit.userModel!.id = uid;
              prefereceCubit.userModel!.externalSignIn = true;

              debugPrint(
                  "\n\n user id from apple sign in screen --> ${prefereceCubit.userModel!.id} \n\n");
              // UserModel.setFirstName;
              // UserModel.setLastName(name.split(" ")[1]);
              // UserModel.setID(uid);
              // UserModel.setSignedInUsingGoogle(true);

              bool does_User_exist = await doesUserExist(uid: uid);
              debugPrint("does_User_exist");
              print(does_User_exist);
              //TODO save uid in cache_helper " With Google"
              await CacheHelper.put(key: 'uid', value: uid);

              // false -> add new phone number and create account
              // true  -> just login
              if (does_User_exist) {
                // get phone number
                print(does_User_exist);
                bool is_phone_empty = await isPhoneNumberEmpty(uid: uid);

                if (is_phone_empty) {
                  // if phone number is empty -> navigate to signupScreen
                  AppNavigator.customNavigator(
                      context: context, screen: SignupScreen(), finish: false);
                } else {
                  // else -> navigate to BottomNavigation
                  print("-----------------------");
                  print(uid);
                  print("-----------------------");
                  GetStorage().write('uid', uid);
                  GetStorage().write('email', email);

                  await preferenceCubit.getUser(id: uid ?? "");
                  await jobsCubit.fillJobs(preferenceCubit, context);

                  if (prefereceCubit.userModel!.isBanned) {
                    snackbarMessage("This user is banned from using the app", context);
                    changeLoadingIndecatorState(false);
                    // emit(SignInWithGoogleFail());
                  } else if (!preferenceCubit.userModel!.isApproved && preferenceCubit.userModel!.accountName != "") {
                    changeLoadingIndecatorState(false);
                    AppNavigator.customNavigator(
                        context: context, screen: const ApprovalScreen(), finish: true);
                  } else {
                    AppNavigator.customNavigator(
                        context: context,
                        screen: BottomNavigation(
                          index: 0,
                        ),
                        finish: true);
                  }
                  snackbarMessage("signin successfully", context);
                }
              } else {
                //TODO GET ALL DATA FROM USER AND CRAETE NEW ACCOUNT
                print(uid);

                // we need to crate account when user users signInWithGoogle
                // to save id from google auth
                await createNewUser(
                    uid: uid, email: email, phoneNumber: "", name: "", first_name: prefereceCubit.userModel!.firstName.toString(),
                    last_name: prefereceCubit.userModel!.lastName.toString());
                snackbarMessage("User created", context);

                GetStorage().write('uid', uid);
                GetStorage().write('email', email);
                AppNavigator.customNavigator(
                    context: context, screen: SignupScreen(), finish: false);
              }
              changeLoadingIndecatorState(false);

              emit(SignInWithAppleSucccess());
            }
            else{
              debugPrint("\n\n user credentials is null \n\n");
            }
          } catch (e) {
            print("apple auth failed $e");
          }

          break;
        case AuthorizationStatus.error:
          debugPrint("error  ${authorizationResult.error}");

          changeLoadingIndecatorState(false);
          emit(SignInWithAppleFail());
          break;
        case AuthorizationStatus.cancelled:
          print("cancelled");

          changeLoadingIndecatorState(false);
          emit(SignInWithAppleFail());
          break;
        default:
          print("none of the above: default");
          break;
      }


      // final appleProvider = AppleAuthProvider();
      // UserCredential user =
      // await FirebaseAuth.instance.signInWithProvider(appleProvider);
      //
      // String email = user.user!.email ?? "";
      // String uid = user.user!.uid ?? "";
      // String name = user.user!.displayName ?? "";
      //
      // debugPrint("email --> $email");
      // debugPrint("uid --> $uid");
      // debugPrint("name --> $name");
      //
      // var prefereceCubit = PreferenceCubit.get(context);
      // prefereceCubit.userModel?.email = email;
      //
      // List<String> names = name.split(" ");
      //
      // if (names.length > 1) {
      //   prefereceCubit.userModel?.firstName = (name.split(" ")[0]);
      //   prefereceCubit.userModel?.lastName = (name.split(" ")[1]);
      // } else {
      //   prefereceCubit.userModel?.firstName = (name.split(" ")[0]);
      //   prefereceCubit.userModel?.lastName = "";
      // }
      // prefereceCubit.userModel!.id = uid;
      // prefereceCubit.userModel!.externalSignIn = true;
      //
      // debugPrint(
      //     "\n\n user id from apple sign in screen --> ${prefereceCubit.userModel!.id} \n\n");
      // // UserModel.setFirstName;
      // // UserModel.setLastName(name.split(" ")[1]);
      // // UserModel.setID(uid);
      // // UserModel.setSignedInUsingGoogle(true);
      //
      // bool does_User_exist = await doesUserExist(uid: uid);
      // debugPrint("does_User_exist");
      // print(does_User_exist);
      // //TODO save uid in cache_helper " With Google"
      // await CacheHelper.put(key: 'uid', value: uid);
      //
      // // false -> add new phone number and create account
      // // true  -> just login
      // if (does_User_exist) {
      //   // get phone number
      //   print(does_User_exist);
      //   bool is_phone_empty = await isPhoneNumberEmpty(uid: uid);
      //
      //   if (is_phone_empty) {
      //     // if phone number is empty -> navigate to signupScreen
      //     AppNavigator.customNavigator(
      //         context: context, screen: SignupScreen(), finish: false);
      //   } else {
      //     // else -> navigate to BottomNavigation
      //     print("-----------------------");
      //     print(uid);
      //     print("-----------------------");
      //     GetStorage().write('uid', uid);
      //     GetStorage().write('email', email);
      //
      //     await preferenceCubit.getUser(id: uid ?? "");
      //     await jobsCubit.fillJobs(preferenceCubit, context);
      //
      //     if (prefereceCubit.userModel!.isBanned) {
      //       snackbarMessage("This user is banned from using the app", context);
      //       changeLoadingIndecatorState(false);
      //       // emit(SignInWithGoogleFail());
      //     } else if (!preferenceCubit.userModel!.isApproved) {
      //       changeLoadingIndecatorState(false);
      //       AppNavigator.customNavigator(
      //           context: context, screen: const ApprovalScreen(), finish: true);
      //     } else {
      //       AppNavigator.customNavigator(
      //           context: context,
      //           screen: BottomNavigation(
      //             index: 0,
      //           ),
      //           finish: true);
      //     }
      //     snackbarMessage("signin successfully", context);
      //   }
      // } else {
      //   //TODO GET ALL DATA FROM USER AND CRAETE NEW ACCOUNT
      //   print(uid);
      //
      //   // we need to crate account when user users signInWithGoogle
      //   // to save id from google auth
      //   await createNewUser(
      //       uid: uid, email: email, phoneNumber: "", name: "", first_name: prefereceCubit.userModel!.firstName.toString(), last_name: prefereceCubit.userModel!.lastName.toString());
      //   snackbarMessage("User created", context);
      //
      //   GetStorage().write('uid', uid);
      //   GetStorage().write('email', email);
      //   AppNavigator.customNavigator(
      //       context: context, screen: SignupScreen(), finish: false);
      // }
      // changeLoadingIndecatorState(false);
      //
      // emit(SignInWithAppleSucccess());
    } catch (e) {
      print("error");
      changeLoadingIndecatorState(false);
      print(e.toString());
      emit(SignInWithAppleFail());
    }
  }

  Future<bool> signInWithEmailAndPassword(
      {required JobsCubit jobsCubit,
      required String email,
      required String password,
      required context,
      required PreferenceCubit preferenceCubit}) async {
    try {
      debugPrint("\n\n\n email--> $email");
      debugPrint("password--> $password \n\n\n");

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password)
          .then((value) async {
        String? uid = value.user?.uid;
        //TODO save uid in cache_helper " With Email and Password";
        // await getCurrentUser(uid);
        await CacheHelper.put(key: 'uid', value: uid);

        debugPrint("\n\n\n $uid \n\n\n");

        await preferenceCubit.getUser(id: uid ?? "");
        await jobsCubit.fillJobs(preferenceCubit, context);
        // save user in model
        // print("Here1");
        // var prefrenceCubit = PreferenceCubit.get(context);
        // print("Here2");
        // await prefrenceCubit.getUser();
        // await getCurrentUser(uid);

        GetStorage().write('uid', uid);
        GetStorage().write('email', email);

        print(value.user?.email);
        print("Sign in Succ");
      });
      emit(SignInWithEmailAndPasswordSuccess());
      return true;
    } catch (e) {
      emit(SignInWithEmailAndPasswordFail());
      return false;
    }
  }

// SHOULD BE MODIFIED LATER
  Future<void> createNewUser(
      {required String uid,
      required String email,
      required String phoneNumber,
      required String name,
      String first_name = "",
        String last_name = "",
      }) async {
    await FirebaseFirestore.instance.collection("User").doc(uid).set({
      "account_name": name,
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "phone_number": phoneNumber,
      "user_id": uid,
      "is_approved": false,
    }).then((value) {
      print("User Added");
      emit(CreateNewUserSuccess());
    }).catchError((e) {
      print(e.toString());
      emit(CreateNewUserFail());
    });
  }

  Future<bool> doesUserExist({required String uid}) async {
    bool exists = false;
    await FirebaseFirestore.instance
        .collection('User')
        .where('user_id', isEqualTo: uid)
        .get()
        .then((value) {
      print(value.docs);
      if (value.docs.isEmpty) {
        exists = false;
      } else {
        exists = true;
      }
    }).catchError((e) {
      print(e.toString());
    });
    return exists;
  }

  Future<bool> isPhoneNumberEmpty({required String uid}) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('User')
        .where('user_id', isEqualTo: uid)
        .get();

    data.docs.forEach((element) {
      element.get('phone_number');
    });
    if (data.docs[0].get('phone_number') == "") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
    print("google signOut done");
    emit(SignOutWithGoogleSuccess());
  }

  Future<void> emailSignOut() async {
    await FirebaseAuth.instance.signOut();
    print("email signOut done");
    emit(SignOutWithEmailSuccess());
  }
}
