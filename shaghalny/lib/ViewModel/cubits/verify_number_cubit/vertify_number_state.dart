part of 'vertify_number_cubit.dart';

@immutable
abstract class VertifyNumberState {}

class VertifyNumberInitial extends VertifyNumberState {}

class SendOTPPhoneNumberLoading extends VertifyNumberState {}
class SendOTPPhoneNumberFail extends VertifyNumberState {}
class SendOTPPhoneNumberSuccess extends VertifyNumberState {}

class VerifyEmailAndPhoneLoading extends VertifyNumberState {}
class VerifyOTPPhoneNumberSuccess extends VertifyNumberState {}
class VerifyOTPPhoneNumberFail extends VertifyNumberState {}

class ChangePhoneErrorMessage extends VertifyNumberState {}

class PhoneNumberChanged extends VertifyNumberState {}

class GetUserEmailByPhoneNumberSuccess extends VertifyNumberState {}

class ResetPasswordEmailSentSucc extends VertifyNumberState {}
class ResetPasswordEmailSentFail extends VertifyNumberState {}
class ResetPasswordEmailSentLoading extends VertifyNumberState {}

class SetErrorMessage extends VertifyNumberState {}
class ChangeSendOTPLoadingIndecator extends VertifyNumberState {}
class ChangeVerifyNumberLoadingIndecator extends VertifyNumberState {}
class ChangeSendAgainEmailLoadingIndecator extends VertifyNumberState {}
