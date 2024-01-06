part of 'apply_for_job_cubit.dart';

@immutable
abstract class ApplyForJobState {}

class ApplyForJobInitial extends ApplyForJobState {}
class CheckFrontIdSuccess extends ApplyForJobState {}

class CheckuniversityIdSuccess extends ApplyForJobState {}

class CheckPicWithIdSuccess extends ApplyForJobState {}

class ApplyForJobLoading extends ApplyForJobState {}
class ApplyForJobSuccess extends ApplyForJobState {}
class ApplyForJobFail extends ApplyForJobState {}

class ChangeApplyForJobLoadingIndicator extends ApplyForJobState {}

class DeleteJobLoading extends ApplyForJobState {}
class DeleteJobSuccess extends ApplyForJobState {}
class DeleteJobFail extends ApplyForJobState {}

class AddToJobsAppliedUsersSuccess extends ApplyForJobState {}

class AddToJobsAppliedUsersFail extends ApplyForJobState {}
class DeleteFromJobsAppliedUsers extends ApplyForJobState {}
class DeleteFromJobsApprovedUsers extends ApplyForJobState {}
