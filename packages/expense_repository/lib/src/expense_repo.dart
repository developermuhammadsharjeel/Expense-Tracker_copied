import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);
  Future<List<Category>> getCategory();
  Future<void> createExpense(Expense expense);
  Future<List<Expense>> getExpenses();
  Future<void> createLoan(Loan loan);
  Future<List<Loan>> getLoans();
  Future<void> updateLoan(Loan loan);
}
