
part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class AllJobsSuccess extends HomeState {}
class AllJobsError extends HomeState {}
class LoadingAllJobs extends HomeState {}

class GetHighRatedJobSuccess extends HomeState {}
class GetHighRatedJobError extends HomeState {}

class GetRecommendJobSuccess extends HomeState {}
class GetRecommendJobError extends HomeState {}

class SpecialJobSuccess extends HomeState {}
class SpecialJobError extends HomeState {}


class GotNewJobsSuccess extends HomeState {}
class GotNewJobsError extends HomeState {}
