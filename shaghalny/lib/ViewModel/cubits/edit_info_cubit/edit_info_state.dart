part of 'edit_info_cubit.dart';


abstract class EditInfoState {}

class EditInfoInitial extends EditInfoState {}


class EditMainInfoSuccess extends EditInfoState {}
class EditMainInfoLoading extends EditInfoState {}
class AddMainDataSuccess extends EditInfoState {}
class AddMainDataError extends EditInfoState {}

class EditPaymentInfoSuccess extends EditInfoState {}
class EditPaymentInfoLoading extends EditInfoState {}
class AddPaymentDataSuccess extends EditInfoState {}
class AddPaymentDataError extends EditInfoState {}