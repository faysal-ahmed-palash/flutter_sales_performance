import 'package:flutter/material.dart';
import 'package:sales_performance/report/dashboard1.dart';
import 'shared_widgets.dart';
import 'report/so_performance.dart';
import 'report/so_route_list.dart';

class ReportPage extends StatelessWidget {
  final List<Map<String, dynamic>> reports = [
    {
      'title': 'Sales Live Delivery Chart',
      'page': Dashboard1Page(), // Page to navigate
    },
    {
      'title': 'So Date wise Performance Report',
      'page': SoPerformanceDateWise(), // Page to navigate
    },
    {
      'title': 'Todays Target Report',
      'page': SoRouteList(),
    },
    {
      'title': 'Another Report (Coming Soon)',
      'page': null, // Placeholder for future reports
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.buildAppBar(context, "Report Page"),
      drawer: SharedWidgets.buildDrawer(context),
      bottomNavigationBar: SharedWidgets.buildBottomNavigationBar(context, 0),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Reports',
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
