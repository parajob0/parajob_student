part of 'id_scan_cubit.dart';

@immutable
abstract class IdScanState {}

class IdScanInitial extends IdScanState {}

class IdScanSuccess extends IdScanState {}
class IdScanError extends IdScanState {}

class UploadIDSuccess extends IdScanState {}
class UploadIDLoading extends IdScanState {}
class UploadIDError extends IdScanState {}

class ShowFrontEditButton extends IdScanState {}
class ShowBackEditButton extends IdScanState {}
