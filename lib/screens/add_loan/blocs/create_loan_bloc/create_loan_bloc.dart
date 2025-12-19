import 'package:bloc/bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_event.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_state.dart';

class CreateLoanBloc extends Bloc<CreateLoanEvent, CreateLoanState> {
  final ExpenseRepository expenseRepository;

  CreateLoanBloc(this.expenseRepository) : super(CreateLoanInitial()) {
    on<CreateLoan>((event, emit) async {
      emit(CreateLoanLoading());
      try {
        await expenseRepository.createLoan(event.loan);
        emit(CreateLoanSuccess());
      } catch (e) {
        emit(CreateLoanFailure());
      }
    });

    on<UpdateLoan>((event, emit) async {
      emit(CreateLoanLoading());
      try {
        await expenseRepository.updateLoan(event.loan);
        emit(CreateLoanSuccess());
      } catch (e) {
        emit(CreateLoanFailure());
      }
    });
  }
}
