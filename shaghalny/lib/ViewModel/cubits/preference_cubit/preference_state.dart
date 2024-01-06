part of 'preference_cubit.dart';

@immutable
abstract class PreferenceState {}

class PreferenceInitial extends PreferenceState {}

class GetUserSuccess extends PreferenceState {}
class GetUserError extends PreferenceState {}

class GetAdminSuccess extends PreferenceState {}
class GetAdminError extends PreferenceState {}

class CityChanged extends PreferenceState {}

class ChangeProfilePic extends PreferenceState {}

