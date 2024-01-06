part of 'sign_up_cubit.dart';


abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}
class SignUpDataSuccess extends SignUpState {}

class AddDataSuccess extends SignUpState {}
class AddDataError extends SignUpState {}

class AddCityAreaSuccess extends SignUpState {}
class AddCityAreaError extends SignUpState {}

class AddBasicDataSuccess extends SignUpState {}
class AddBasicDataError extends SignUpState {}

class AddRemainSuccess extends SignUpState {}
class AddRemainError extends SignUpState {}