import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_bloc.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_event.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_state.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/get_loans_bloc/get_loans_bloc.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/get_loans_bloc/get_loans_event.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/get_loans_bloc/get_loans_state.dart';
import 'package:expenses_tracker/screens/add_loan/views/add_loan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoanListScreen extends StatelessWidget {
  const LoanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Loan Tracking'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var newLoan = await Navigator.push(
            context,
            MaterialPageRoute<Loan>(
              builder: (context) => BlocProvider(
                create: (context) => CreateLoanBloc(FirebaseExpenseRepo()),
                child: const AddLoan(),
              ),
            ),
          );
          if (newLoan != null) {
            context.read<GetLoansBloc>().add(GetLoans());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<GetLoansBloc, GetLoansState>(
        builder: (context, state) {
          if (state is GetLoansLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetLoansSuccess) {
            if (state.loans.isEmpty) {
              return const Center(
                child: Text(
                  'No loans yet.\nTap + to add a loan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // Calculate totals
            double totalGiven = 0;
            double totalReceived = 0;
            double savedGiven = 0;
            double savedReceived = 0;

            for (var loan in state.loans) {
              if (loan.type == LoanType.given) {
                totalGiven += loan.amount;
                if (!loan.isDraft) {
                  savedGiven += loan.amount;
                }
              } else {
                totalReceived += loan.amount;
                if (!loan.isDraft) {
                  savedReceived += loan.amount;
                }
              }
            }

            return Column(
              children: [
                // Summary Cards
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: 'Loans Given',
                              total: totalGiven,
                              saved: savedGiven,
                              color: Colors.red.shade100,
                              icon: Icons.call_made,
                              iconColor: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _SummaryCard(
                              title: 'Loans Received',
                              total: totalReceived,
                              saved: savedReceived,
                              color: Colors.green.shade100,
                              icon: Icons.call_received,
                              iconColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Net Balance Impact: \$${(savedReceived - savedGiven).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Loan List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.loans.length,
                    itemBuilder: (context, index) {
                      final loan = state.loans[index];
                      return _LoanCard(loan: loan);
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Failed to load loans'),
            );
          }
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double total;
  final double saved;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.title,
    required this.total,
    required this.saved,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Saved: \$${saved.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final Loan loan;

  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateLoanBloc, CreateLoanState>(
      listener: (context, state) {
        if (state is CreateLoanSuccess) {
          context.read<GetLoansBloc>().add(GetLoans());
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    loan.type == LoanType.given
                        ? Icons.call_made
                        : Icons.call_received,
                    color: loan.type == LoanType.given ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.personName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          loan.type == LoanType.given
                              ? 'Loan Given'
                              : 'Loan Received',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${loan.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(loan.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (loan.description != null && loan.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    loan.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              if (loan.isDraft)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Chip(
                        label: const Text(
                          'DRAFT',
                          style: TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.orange.shade100,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Not affecting balance',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Save Loan'),
                              content: const Text(
                                'Are you sure you want to save this loan? '
                                'This will affect your balance.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    final updatedLoan = Loan(
                                      loanId: loan.loanId,
                                      type: loan.type,
                                      personName: loan.personName,
                                      amount: loan.amount,
                                      date: loan.date,
                                      isDraft: false,
                                      description: loan.description,
                                    );
                                    context
                                        .read<CreateLoanBloc>()
                                        .add(UpdateLoan(updatedLoan));
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Save Now'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
