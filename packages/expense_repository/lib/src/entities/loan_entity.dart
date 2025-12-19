import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loan.dart';

class LoanEntity {
  String loanId;
  LoanType type;
  String personName;
  int amount;
  DateTime date;
  bool isDraft;
  String? description;

  LoanEntity({
    required this.loanId,
    required this.type,
    required this.personName,
    required this.amount,
    required this.date,
    required this.isDraft,
    this.description,
  });

  Map<String, Object?> toDocument() {
    return {
      'loanId': loanId,
      'type': type.toString().split('.').last,
      'personName': personName,
      'amount': amount,
      'date': date,
      'isDraft': isDraft,
      'description': description,
    };
  }

  static LoanEntity fromDocument(Map<String, dynamic> doc) {
    return LoanEntity(
      loanId: doc['loanId'],
      type: doc['type'] == 'given' ? LoanType.given : LoanType.received,
      personName: doc['personName'],
      amount: doc['amount'],
      date: (doc['date'] as Timestamp).toDate(),
      isDraft: doc['isDraft'],
      description: doc['description'],
    );
  }
}
