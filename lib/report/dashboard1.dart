import 'package:flutter/material.dart';
import '../shared_widgets.dart';
import '/api/api_dashboard.dart';
import 'sales_line_chart.dart';


class Dashboard1Page extends StatefulWidget {
  @override
  _Dashboard1PageState createState() => _Dashboard1PageState();
}

class _Dashboard1PageState extends State<Dashboard1Page> {
  double _totalSales = 0.0; // Variable to store total sales
  double _todaySales = 0.0; // Variable to store today's sales
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchSalesData(); // Fetch sales data when the page loads
  }

  Future<void> _fetchSalesData() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch both total_sales and today_sales
    final salesData = await SecSalesDashboardAPI.fetchSalesData();

    setState(() {
      _totalSales = salesData['total_sales']!;
      _todaySales = salesData['today_sales']!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.buildAppBar(context, "Sales Delivery"),
      drawer: SharedWidgets.buildDrawer(context),
      bottomNavigationBar: SharedWidgets.buildBottomNavigationBar(context, 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total and Today's Sales Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                      'Total Sales',
                      _isLoading ? 'Loading...' : '${_totalSales.toInt()}',
                      Colors.green),
                  _buildStatCard(
                      'Today\'s Sales',
                      _isLoading ? 'Loading...' : '${_todaySales.toInt()}',
                      Colors.blue),
                ],
              ),
            ),
            // Sales Chart Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Container(
                  height: 400,
                  child: SalesLineChart(), // Line chart widget for sales data
                ),
              ),
            ),
            // Recent Activity List (Optional)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Recent Activity #$index'),
                      subtitle: Text('Details about activity'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
