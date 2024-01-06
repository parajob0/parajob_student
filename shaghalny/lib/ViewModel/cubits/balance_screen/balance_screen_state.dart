part of 'balance_screen_cubit.dart';

@immutable
abstract class BalanceScreenState {}

class BalanceScreenInitial extends BalanceScreenState {}

class ChartViewSuccess extends BalanceScreenState {}

class GetDaySuccess extends BalanceScreenState {}

class PreviousSuccess extends BalanceScreenState {}
class NextSuccess extends BalanceScreenState {}


class GetJobHistorySuccess extends BalanceScreenState {}

class FilterByMonthSuccess extends BalanceScreenState {}
class FilterByYearSuccess extends BalanceScreenState {}
class FilterByWeekSuccess extends BalanceScreenState {}
class GetJobHistoryLoading extends BalanceScreenState {}

class GetWeekData extends BalanceScreenState {}
class GetMonthData extends BalanceScreenState {}
class GetYearData extends BalanceScreenState {}
class ResetData extends BalanceScreenState {}



