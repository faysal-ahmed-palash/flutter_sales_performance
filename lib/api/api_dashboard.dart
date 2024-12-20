import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class SecSalesDashboardAPI {


  // Fetch total sales from API
  static Future<Map<String, double>> fetchSalesData() async {
    try {
      final response = await http.get(Uri.parse('https://sajeeb2ndsales.com/api_flutter/sec_sales/sales_info.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body); // Parse JSON array
        if (data.isNotEmpty) {
          return {
            'total_sales': double.parse(data[0]['total_sales'].toString()), // Extract total sales
            'today_sales': double.parse(data[0]['today_sales'].toString())  // Extract today's sales
          };
        }
        return {
          'total_sales': 0.0,
          'today_sales': 0.0
        }; // Default values if no data
      } else {
        throw Exception('Failed to fetch sales data');
      }
    } catch (e) {
      print('Error fetching sales data: $e');
      return {
        'total_sales': 0.0,
        'today_sales': 0.0
      };
    }
  }// end function

  // Fetch chart data from API
  static Future<List<FlSpot>> fetchChartData() async {
    try {
      final response = await http.get(Uri.parse('https://sajeeb2ndsales.com/api_flutter/sec_sales/chart_sales_datewise.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          int dayNumber = int.parse(item['day_number'].toString());
          double amt = double.parse(item['amt'].toString());
          return FlSpot(dayNumber.toDouble(), amt);
        }).toList();
      } else {
        throw Exception('Failed to fetch chart data');
      }
    } catch (e) {
      print('Error fetching chart data: $e');
      return []; // Return empty list if there’s an error
    }
  } // end function
}
