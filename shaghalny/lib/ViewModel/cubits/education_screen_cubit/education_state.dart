part of 'education_cubit.dart';


abstract class EducationState {}

class EducationScreenInitial extends EducationState {}
class EducationScreenLoading extends EducationState {}
class EducationScreenDataSuccess extends EducationState {}

class AddEducationDataSuccess extends EducationState {}
class AddEducationDataError extends EducationState {}
