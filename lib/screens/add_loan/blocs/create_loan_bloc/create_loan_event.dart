import 'package:expense_repository/expense_repository.dart';

sealed class CreateLoanEvent {}

class CreateLoan extends CreateLoanEvent {
  final Loan loan;

  CreateLoan(this.loan);
}

class UpdateLoan extends CreateLoanEvent {
  final Loan loan;

  UpdateLoan(this.loan);
}
