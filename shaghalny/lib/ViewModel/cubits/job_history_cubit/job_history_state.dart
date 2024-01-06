part of 'job_history_cubit.dart';

@immutable
abstract class JobHistoryState {}

class JobHistoryInitial extends JobHistoryState {}

class GetJobHistoryLoading extends JobHistoryState {}
class GetJobHistorySuccess extends JobHistoryState {}

