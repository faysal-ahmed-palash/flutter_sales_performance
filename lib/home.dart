import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'report.dart';
import 'shared_widgets.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {

    // Access the session data directly
    String username = SessionManager().username;
    String fullName = SessionManager().fullName;

    return Scaffold(
      appBar: SharedWidgets.buildAppBar(context, "Home Page"),
      drawer: SharedWidgets.buildDrawer(context),
      bottomNavigationBar: SharedWidgets.buildBottomNavigationBar(context, 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              fullName.isNotEmpty ? 'Welcome, $fullName' : 'Welcome, $username',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(Icons.pie_chart),
              label: Text('Go To Report Page'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full-width button
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
