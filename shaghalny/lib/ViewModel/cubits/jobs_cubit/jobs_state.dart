part of 'jobs_cubit.dart';

@immutable
abstract class JobsState {}

class JobsInitial extends JobsState {}


class FillJobsSuccess extends JobsState {}

class FillJobsLoading extends JobsState {}

class ChangeApprovedJobStateSuccess extends JobsState {}
class AddToAppliedJobsSuccess extends JobsState {}
class DeleteJobFromCubitSuccess extends JobsState {}
class DeleteJobWhenTimeEndsSuccess extends JobsState {}
class DeleteJobWhenTimeEndsFail extends JobsState {}
class AddToJobHistorySuccess extends JobsState {}
class ChangeJobStateSuccess extends JobsState {}








