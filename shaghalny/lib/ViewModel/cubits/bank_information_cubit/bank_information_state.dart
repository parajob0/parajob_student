part of 'bank_information_cubit.dart';

@immutable
abstract class BankInformationState {}

class BankInformationInitial extends BankInformationState {}

class BankInformationSuccess extends BankInformationState {}
class BankInformationError extends BankInformationState {}

class BankNumberErrorMessage extends BankInformationState {}

class AddBankDataSuccess extends BankInformationState {}
class AddBankDataError extends BankInformationState {}