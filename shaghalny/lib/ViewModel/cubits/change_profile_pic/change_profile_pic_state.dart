part of 'change_profile_pic_cubit.dart';

@immutable
abstract class ChangeProfilePicState {}

class ChangeProfilePicInitial extends ChangeProfilePicState {}


class UploadNewProfilePicLoading extends ChangeProfilePicState {}

class UploadNewProfilePicSuccess extends ChangeProfilePicState {}

class UploadNewProfilePicFail extends ChangeProfilePicState {}
class ChangeLoadingSuccess extends ChangeProfilePicState {}
class UpdatePicInUserModelSuccess extends ChangeProfilePicState {}
class SetSelectedImageSuccess extends ChangeProfilePicState {}

