import 'package:flutter/material.dart';
import '../shared_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SoProfile extends StatelessWidget {
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

  // Controllers for editable fields
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _dealerCodeController = TextEditingController();
  TextEditingController _adjustDateController = TextEditingController();
  TextEditingController _slabDateController = TextEditingController();

  String? _username; // To hold the fetched username
  String? _selectedStatus; // Selected dropdown value for status
  String? _selectedAdjust; // Dropdown for adjust
  String? _selectedSlabPass; // Dropdown for slab_pass

  final List<String> _statusOptions = ['Active', 'Inactive'];
  final List<String> _adjustOptions = ['1', '0'];
  final List<String> _slabPassOptions = ['1', '0'];

  @override
  void dispose() {
    _empCodeController.dispose();
    _passwordController.dispose();
    _dealerCodeController.dispose();
    _adjustDateController.dispose();
    _slabDateController.dispose();
    super.dispose();
  }

  Future<void> fetchEmployeeData(String empCode) async {
    setState(() {
      _isLoading = true;
      _employeeData = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://sajeeb2ndsales.com/api_flutter/sec_sales/ss_user.php?PBI_ID=$empCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _employeeData = data[0];
            _username = _employeeData!['username']; // Store the username

            // Populate controllers with fetched data
            _passwordController.text = _employeeData!['password'] ?? '';
            _selectedStatus = _employeeData!['status'] ?? 'Active';
            _selectedAdjust = _employeeData!['adjust'] ?? 'No';
            _selectedSlabPass = _employeeData!['slab_pass'] ?? 'Fail';
            _dealerCodeController.text = _employeeData!['dealer_code'] ?? '';
            _adjustDateController.text = _employeeData!['adjust_date'] ?? '';
            _slabDateController.text = _employeeData!['slab_date'] ?? '';
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

  Future<void> updateEmployeeData() async {
    if (_username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username is missing. Please search first.')),
      );
      return;
    }

    final updatedData = {
      'username': _username, // Pass the stored username
      'password': _passwordController.text,
      'status': _selectedStatus,
      'adjust': _selectedAdjust,
      'dealer_code': _dealerCodeController.text,
      'adjust_date': _adjustDateController.text,
      'slab_pass': _selectedSlabPass,
      'slab_date': _slabDateController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://sajeeb2ndsales.com/api_flutter/sec_sales/update_so_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Profile updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update data.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toIso8601String().split('T').first; // Format date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.buildAppBar(context, "SO Profile"),
      drawer: SharedWidgets.buildDrawer(context),
      bottomNavigationBar: SharedWidgets.buildBottomNavigationBar(context, 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  FocusScope.of(context).unfocus();
                  final empCode = _empCodeController.text.trim();
                  if (empCode.isNotEmpty) {
                    fetchEmployeeData(empCode);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter emp code')),
                    );
                  }
                },
                child: Text('Search'),
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _employeeData != null && !_employeeData!.containsKey('error')
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modify Employee Details:',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  buildTextField('Password', _passwordController),
                  buildDropdownField('Status', _statusOptions, _selectedStatus, (value) => setState(() => _selectedStatus = value)),
                  buildDropdownField('Adjust', _adjustOptions, _selectedAdjust, (value) => setState(() => _selectedAdjust = value)),
                  buildDropdownField('Slab Pass', _slabPassOptions, _selectedSlabPass, (value) => setState(() => _selectedSlabPass = value)),
                  buildTextField('Dealer Code', _dealerCodeController),
                  buildDateField('Adjust Date', _adjustDateController),
                  buildDateField('Slab Date', _slabDateController),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: updateEmployeeData,
                    child: Text('Update'),
                  ),
                ],
              )
                  : _employeeData?.containsKey('error') == true
                  ? Text(
                _employeeData!['error'],
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
                  : Text('Enter employee code to search.',
                  style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> options, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => selectDate(context, controller),
          ),
        ),
      ),
    );
  }


}
