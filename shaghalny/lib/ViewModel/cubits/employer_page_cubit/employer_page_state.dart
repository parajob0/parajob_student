part of 'employer_page_cubit.dart';

@immutable
abstract class EmployerPageState {}

class EmployerPageInitial extends EmployerPageState {}

class GetEmployerDataSuccess extends EmployerPageState {}
class GetEmployerDataError extends EmployerPageState {}

class GetReviewsSuccess extends EmployerPageState {}
class GetReviewsError extends EmployerPageState {}

class GetReviewsPositivePercentage extends EmployerPageState {}
