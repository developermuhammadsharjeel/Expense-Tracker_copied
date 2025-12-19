import '../entities/loan_entity.dart';

enum LoanType { given, received }

class Loan {
  String loanId;
  LoanType type;
  String personName;
  int amount;
  DateTime date;
  bool isDraft;
  String? description;

  Loan({
    required this.loanId,
    required this.type,
    required this.personName,
    required this.amount,
    required this.date,
    required this.isDraft,
    this.description,
  });

  static final empty = Loan(
    loanId: '',
    type: LoanType.given,
    personName: '',
    amount: 0,
    date: DateTime.now(),
    isDraft: true,
  );

  LoanEntity toEntity() {
    return LoanEntity(
      loanId: loanId,
      type: type,
      personName: personName,
      amount: amount,
      date: date,
      isDraft: isDraft,
      description: description,
    );
  }

  static Loan fromEntity(LoanEntity entity) {
    return Loan(
      loanId: entity.loanId,
      type: entity.type,
      personName: entity.personName,
      amount: entity.amount,
      date: entity.date,
      isDraft: entity.isDraft,
      description: entity.description,
    );
  }
}
