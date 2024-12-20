import 'package:flutter/material.dart';
import '../shared_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



class SoPerformanceDateWise extends StatelessWidget {
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
  final TextEditingController _fDateController = TextEditingController();
  final TextEditingController _tDateController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _employeeData;
  List<Map<String, dynamic>> _salesData = [];


  @override
  void initState() {
    super.initState();

    // Set default dates
    DateTime now = DateTime.now();
    DateTime firstDateOfMonth = DateTime(now.year, now.month, 1);
    _fDateController.text = DateFormat('yyyy-MM-dd').format(firstDateOfMonth); // First day of the current month
    _tDateController.text = DateFormat('yyyy-MM-dd').format(now); // Today's date
  }

  Future<void> fetchEmployeeData(String empCode, String fDate,
      String tDate) async {
    setState(() {
      _isLoading = true;
      _employeeData = null; // Reset data before new fetch
      _salesData = []; // Reset sales data
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://sajeeb2ndsales.com/api_flutter/sec_sales/so_performance.php?PBI_ID=$empCode&f_date=$fDate&t_date=$tDate'),
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

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(
            picked); // Set selected date in format
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SharedWidgets.buildAppBar(context, "SO Performance"),
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
              SizedBox(height: 8),
              TextField(
                controller: _fDateController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'From Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _fDateController),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _tDateController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'To Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _tDateController),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Close the keyboard
                  FocusScope.of(context).unfocus();

                  final empCode = _empCodeController.text.trim();
                  final fDate = _fDateController.text.trim();
                  final tDate = _tDateController.text.trim();

                  if (empCode.isNotEmpty && fDate.isNotEmpty &&
                      tDate.isNotEmpty) {
                    fetchEmployeeData(empCode, fDate, tDate);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please enter all required fields')),
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
                    'Sales Data:',
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
                      final sales = _salesData[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              'Visit Date: ${sales['visit_date']}'),
                          subtitle: Text(
                              'Target: ${sales['target']}, DO: ${sales['do_amt']}, DO%: ${sales['do_per']}'),
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