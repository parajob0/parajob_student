part of 'sign_job_contract_cubit.dart';

@immutable
abstract class SignJobContractState {}

class SignJobContractInitial extends SignJobContractState {}

class SetJobId extends SignJobContractState {}

class AddContractSuccess extends SignJobContractState {}

class AddContractFail extends SignJobContractState {}

class ChangeContractLoadingIndicator extends SignJobContractState {}
class ChangeCheckedValue extends SignJobContractState {}

