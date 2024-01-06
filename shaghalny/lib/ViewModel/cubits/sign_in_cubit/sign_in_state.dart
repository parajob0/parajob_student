part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}


class SignInWithGoogleLoading extends SignInState {}
class SignInWithGoogleSucccess extends SignInState {}
class SignInWithGoogleFail extends SignInState {}

class SignInWithAppleLoading extends SignInState {}
class SignInWithAppleSucccess extends SignInState {}
class SignInWithAppleFail extends SignInState {}


class SignInWithEmailAndPasswordSuccess extends SignInState {}
class SignInWithEmailAndPasswordFail extends SignInState {}


class CreateNewUserSuccess extends SignInState {}
class CreateNewUserFail extends SignInState {}

class ChangeRememberMeValue extends SignInState {}

class SignOutWithGoogleSuccess extends SignInState {}
class SignOutWithEmailSuccess extends SignInState {}


class ChangeErrorMessage extends SignInState {}
class GetErrorMessage extends SignInState {}
class SetErrorMessage extends SignInState {}
class ChangeLoadingIndecatorState extends SignInState {}

class GetCurrentUserSuccess extends SignInState {}
class GetCurrentUserFail extends SignInState {}


