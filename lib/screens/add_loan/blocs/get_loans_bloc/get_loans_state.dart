import 'package:expense_repository/expense_repository.dart';

sealed class GetLoansState {}

final class GetLoansInitial extends GetLoansState {}

final class GetLoansFailure extends GetLoansState {}

final class GetLoansLoading extends GetLoansState {}

final class GetLoansSuccess extends GetLoansState {
  final List<Loan> loans;

  GetLoansSuccess(this.loans);
}
