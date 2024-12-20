import 'package:flutter/material.dart';
import 'package:sales_performance/setup_list.dart';
import '../home.dart';
import 'report/employeeInfo.dart';
import 'report.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedWidgets {


  // Reusable AppBar
  static PreferredSizeWidget buildAppBar(BuildContext context, String title) {

    // session user name
    Future<void> logoutUser(BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      Navigator.pushReplacementNamed(context, '/login');
    }

    return AppBar(
      title: Text(title),
      titleSpacing: 0,
      centerTitle: false,
      backgroundColor: Colors.green,
      toolbarHeight: 60, // default 60
      toolbarOpacity: 1,
      elevation: 50,
      actions: [
        IconButton(
          onPressed: () {
            MySnackBar("Comments Press", context);
          },
          icon: Icon(Icons.comment),
        ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () => logoutUser(context),
        ),
      ],
    );
  }

  // Reusable Drawer
  static Widget buildDrawer(BuildContext context) {

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              accountName: Text("Faysal",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                "palash884@gmail.com",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: ClipOval(
                child: Image.network(
                  "https://faysaltech.com/profile/assets/images/avatar.jpg",
                  fit: BoxFit.cover,
                  width: 60.0,
                  height: 60.0,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
            },
          ),
          ListTile(
            title: Text("Dashboard"),
            leading: Icon(Icons.report),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeInfoPage()),);
            },
          ),
          ListTile(
            title: Text("Setup"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SetupPage()),);
            },
          ),
          ListTile(
            title: Text("Report"),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage()),);
            },
          ),
        ],
      ),
    );
  }

  // Reusable BottomNavigationBar
  static Widget buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setup"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Report"),
      ],
      onTap: (int index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SetupPage()),
          );
        }
        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReportPage()),
          );
        }
      },
    );
  }
}

// Mock Snackbar Function
void MySnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
