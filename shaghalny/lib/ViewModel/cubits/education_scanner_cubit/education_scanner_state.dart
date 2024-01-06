part of 'education_scanner_cubit.dart';

@immutable
abstract class EducationScannerState {}

class EducationScannerInitial extends EducationScannerState {}

class EducationScannerSuccess extends EducationScannerState {}
class EducationScannerError extends EducationScannerState {}

class UploadEducationIDSuccess extends EducationScannerState {}
class UploadEducationIDError extends EducationScannerState {}
