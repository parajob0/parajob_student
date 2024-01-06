part of 'pic_id_cubit.dart';

@immutable
abstract class PicState {}

class PicInitial extends PicState {}

class TakePicSuccess extends PicState {}
class TakePicError extends PicState {}

class UploadPicIDSuccess extends PicState {}
class UploadPicIDLoading extends PicState {}
class UploadPicIDError extends PicState {}

class ShowEditButton extends PicState {}
