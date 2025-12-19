sealed class CreateLoanState {}

final class CreateLoanInitial extends CreateLoanState {}

final class CreateLoanSuccess extends CreateLoanState {}

final class CreateLoanFailure extends CreateLoanState {}

final class CreateLoanLoading extends CreateLoanState {}
