import 'package:flutter/material.dart';
import '../shared_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class SoRouteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _empCodeController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _employeeData;
  List<Map<String, dynamic>> _salesData = [];


  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchEmployeeData(String empCode) async {
    setState(() {
      _isLoading = true;
      _employeeData = null; // Reset data before new fetch
      _salesData = []; // Reset sales data
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://sajeeb2ndsales.com/api_flutter/sec_sales/report_so_route.php?PBI_ID=$empCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _employeeData = data[0]; // Assuming API returns an array
            _salesData = List<Map<String, dynamic>>.from(
                data.skip(1)); // Sales data from subsequent rows
          });
        } else {
          setState(() {
            _employeeData = {'error': 'No employee found with this code'};
          });
        }
      } else {
        setState(() {
          _employeeData = {'error': 'Failed to fetch data'};
        });
      }
    } catch (e) {
      setState(() {
        _employeeData = {'error': 'Error: $e'};
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.buildAppBar(context, "SO Route Schedule"),
      drawer: SharedWidgets.buildDrawer(context),
      bottomNavigationBar: SharedWidgets.buildBottomNavigationBar(context, 0),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter employee code:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _empCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Employee Code',
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {

                  // Close the keyboard
                  FocusScope.of(context).unfocus();

                  final empCode = _empCodeController.text.trim();

                  if (empCode.isNotEmpty) {
                    fetchEmployeeData(empCode);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please enter emp code')),
                    );
                  }
                },
                child: Text('Search'),
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _employeeData != null
                  ? _employeeData!.containsKey('error')
                  ? Text(
                _employeeData!['error'],
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Details:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('ID: ${_employeeData!['PBI_ID']}'),
                  Text('Name: ${_employeeData!['PBI_NAME']}'),
                  Text(
                      'Department: ${_employeeData!['PBI_DEPARTMENT']}'),
                  Text(
                      'Designation: ${_employeeData!['PBI_DESIGNATION']}'),
                  Text('Mobile: ${_employeeData!['PBI_MOBILE']}'),
                  SizedBox(height: 16),
                  Text(
                    'Route Schedule:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),
                  _salesData.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics:
                    NeverScrollableScrollPhysics(), // Prevent nested scrolling
                    itemCount: _salesData.length,
                    itemBuilder: (context, index) {
                      final data1 = _salesData[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              'Working Day: ${data1['working_day']}'),
                          subtitle: Text(
                              'Route: ${data1['route_names']}, Contribution: ${data1['con_per']}%'),
                        ),
                      );
                    },
                  )
                      : Text('No sales data available'),
                ],
              )
                  : Text(
                'Enter employee code and date range to search.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}