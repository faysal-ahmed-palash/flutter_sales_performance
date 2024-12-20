import 'package:flutter/material.dart';
import 'package:sales_performance/setup/loan_emi.dart';
import 'shared_widgets.dart';
import '/setup/so_profile.dart';
import '/setup/loan_emi.dart';

class SetupPage extends StatelessWidget {
  final List<Map<String, dynamic>> reports = [
    {
      'title': 'SO Profile',
      'page': SoProfile(), // Page to navigate
    },
    {
      'title': 'EMI Calculator',
      'page': LoanEmiCalculator(), // Page to navigate
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.buildAppBar(context, "Setup Page"),
      drawer: SharedWidgets.buildDrawer(context),
      bottomNavigationBar: SharedWidgets.buildBottomNavigationBar(context, 0),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MIS Setup',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(reports[index]['title']),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        if (reports[index]['page'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => reports[index]['page'],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("This report is not yet available."),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
