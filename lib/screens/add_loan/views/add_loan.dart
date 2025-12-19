import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_bloc.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_event.dart';
import 'package:expenses_tracker/screens/add_loan/blocs/create_loan_bloc/create_loan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddLoan extends StatefulWidget {
  const AddLoan({super.key});

  @override
  State<AddLoan> createState() => _AddLoanState();
}

class _AddLoanState extends State<AddLoan> {
  TextEditingController amountController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late Loan loan;
  bool isLoading = false;
  bool isDraft = true;
  LoanType selectedType = LoanType.given;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    loan = Loan.empty;
    loan.loanId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateLoanBloc, CreateLoanState>(
      listener: (context, state) {
        if (state is CreateLoanSuccess) {
          Navigator.pop(context, loan);
        } else if (state is CreateLoanLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Add Loan'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Loan Details",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  
                  // Loan Type Selection
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<LoanType>(
                          title: const Row(
                            children: [
                              Icon(Icons.call_made, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Loan Given (Money lent to someone)'),
                            ],
                          ),
                          value: LoanType.given,
                          groupValue: selectedType,
                          onChanged: (LoanType? value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                        RadioListTile<LoanType>(
                          title: const Row(
                            children: [
                              Icon(Icons.call_received, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Loan Received (Money borrowed)'),
                            ],
                          ),
                          value: LoanType.received,
                          groupValue: selectedType,
                          onChanged: (LoanType? value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Person Name
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: personNameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.user,
                          size: 16,
                          color: Colors.grey,
                        ),
                        hintText: selectedType == LoanType.given 
                            ? 'Person\'s name (to whom money is lent)'
                            : 'Person\'s name (from whom money is borrowed)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: amountController,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.dollarSign,
                          size: 16,
                          color: Colors.grey,
                        ),
                        hintText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: dateController,
                      textAlignVertical: TextAlignVertical.center,
                      readOnly: true,
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: loan.date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );

                        if (newDate != null) {
                          setState(() {
                            dateController.text =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            loan.date = newDate;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.clock,
                          size: 16,
                          color: Colors.grey,
                        ),
                        hintText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: descriptionController,
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.noteSticky,
                          size: 16,
                          color: Colors.grey,
                        ),
                        hintText: 'Description (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Draft Mode Checkbox
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      title: const Text('Save as Draft'),
                      subtitle: const Text(
                        'Draft loans won\'t affect your balance until saved',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: isDraft,
                      onChanged: (bool? value) {
                        setState(() {
                          isDraft = value ?? true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: kToolbarHeight,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : TextButton(
                            onPressed: () {
                              if (personNameController.text.isEmpty ||
                                  amountController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all required fields'),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                loan.type = selectedType;
                                loan.personName = personNameController.text;
                                loan.amount = int.parse(amountController.text);
                                loan.isDraft = isDraft;
                                loan.description = descriptionController.text.isEmpty
                                    ? null
                                    : descriptionController.text;
                              });

                              context.read<CreateLoanBloc>().add(CreateLoan(loan));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
