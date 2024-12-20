import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/api/api_dashboard.dart';

class SalesLineChart extends StatefulWidget {
  @override
  _SalesLineChartState createState() => _SalesLineChartState();
}

class _SalesLineChartState extends State<SalesLineChart> {
  List<FlSpot> _chartData = [];
  double _maxY = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    setState(() {
      _isLoading = true;
    });
    final chartData = await SecSalesDashboardAPI.fetchChartData(); // Fetch chart data from API
    setState(() {
      _chartData = chartData;
      _maxY = _chartData.map((spot) => spot.y).fold(0, (prev, next) => next > prev ? next : prev); // Update maxY
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_chartData.isEmpty) {
      return Center(child: Text('No data available for the current month.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          maxY: _maxY + (_maxY * 0.1), // Add 10% padding to the max Y value
          minY: 0, // Set the minimum Y value to 0
          lineBarsData: [
            LineChartBarData(
              spots: _chartData,
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
              ),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}'); // Y-axis labels
                },
                reservedSize: 30,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}'); // X-axis as day numbers
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
