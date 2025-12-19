import 'package:bloc/bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/get_loans_bloc/get_loans_event.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/get_loans_bloc/get_loans_state.dart';

class GetLoansBloc extends Bloc<GetLoansEvent, GetLoansState> {
  final ExpenseRepository expenseRepository;

  GetLoansBloc(this.expenseRepository) : super(GetLoansInitial()) {
    on<GetLoans>((event, emit) async {
      emit(GetLoansLoading());
      try {
        List<Loan> loans = await expenseRepository.getLoans();
        emit(GetLoansSuccess(loans));
      } catch (e) {
        emit(GetLoansFailure());
      }
    });
  }
}
