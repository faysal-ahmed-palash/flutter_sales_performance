import 'package:flutter/material.dart';
import 'dart:math';
import '../shared_widgets.dart';

class LoanEmiCalculator extends StatefulWidget {
  @override
  _LoanEmiCalculatorState createState() => _LoanEmiCalculatorState();
}

class _LoanEmiCalculatorState extends State<LoanEmiCalculator> {
  final TextEditingController _loanAmountController = TextEditingController(text: '1000000');
  final TextEditingController _loanTenureController = TextEditingController(text: '36');
  final TextEditingController _interestRateController = TextEditingController(text: '12');

  String _emiResult = "";

  void _calculateEMI() {
    // Close the keyboard
    FocusScope.of(context).unfocus();

    double loanAmount = double.tryParse(_loanAmountController.text) ?? 0;
    int loanTenure = int.tryParse(_loanTenureController.text) ?? 0;
    double annualInterestRate = double.tryParse(_interestRateController.text) ?? 0;

    if (loanAmount > 0 && loanTenure > 0 && annualInterestRate > 0) {
      double monthlyInterestRate = annualInterestRate / (12 * 100);
      int totalMonths = loanTenure;

      // EMI Calculation
      double emi = (loanAmount * monthlyInterestRate * pow(1 + monthlyInterestRate, totalMonths)) /
          (pow(1 + monthlyInterestRate, totalMonths) - 1);

      // Total Return Amount
      double totalReturnAmount = emi * totalMonths;

      // Total Interest Amount
      double totalInterestAmount = totalReturnAmount - loanAmount;

      setState(() {
        _emiResult =
        "Your EMI is: BDT ${emi.toStringAsFixed(2)}\n"
            "Total Return : BDT ${totalReturnAmount.toStringAsFixed(2)}\n"
            "Total Interest : BDT ${totalInterestAmount.toStringAsFixed(2)}";
      });
    } else {
      setState(() {
        _emiResult = "Please enter valid inputs.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.buildAppBar(context, "EMI Calculator"),
      drawer: SharedWidgets.buildDrawer(context),
      bottomNavigationBar: SharedWidgets.buildBottomNavigationBar(context, 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _loanAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Loan Amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _loanTenureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Loan Tenure (months)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Annual Interest Rate (%)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _calculateEMI,
                child: Text("Calculate EMI"),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                _emiResult,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
