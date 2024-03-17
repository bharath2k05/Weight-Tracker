import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 

class DataRetrievalPage extends StatefulWidget {
  final String accessToken;
  final String refreshToken;
  final String loggedInUsername;

  DataRetrievalPage({
    required this.accessToken,
    required this.refreshToken,
    required this.loggedInUsername,
  });

  @override
  _DataRetrievalPageState createState() => _DataRetrievalPageState();
}

class _DataRetrievalPageState extends State<DataRetrievalPage> {
  List<DataEntry> entries = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      
      final Map<String, String> headers = {
        'Authorization': 'Bearer ${widget.accessToken}',
      };

      
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/track/get_weight_entries/'),
        headers: headers, 
      );

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        print('Response Body: $responseBody');
        final List<dynamic> responseData = jsonDecode(response.body);
        List<DataEntry> dataEntries = responseData.map((data) => DataEntry.fromJson(data)).toList();

        
        dataEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        setState(() {
          entries = dataEntries;
          isLoading = false;
        });
      // } else if (response.statusCode == 401) {
      //   // Token expired, attempt to refresh the access token
      //   final refreshedToken = await _refreshAccessToken(widget.refreshToken);
      //   if (refreshedToken != null) {
      //     // Retry data fetching with the new access token
      //     await fetchData();
      //   } else {
      //     throw Exception("Failed to refresh access token");
      //   }
      // } else {
        // throw Exception("Failed to fetch data: ${response.reasonPhrase}");
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  // Future<String?> _refreshAccessToken(String refreshToken) async {
  //   final response = await http.post(
  //     Uri.parse('http://127.0.0.1:8000/track/refresh_token/'),
  //     body: {'refresh_token': refreshToken},
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     final newAccessToken = responseData['access_token'];
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('access_token', newAccessToken);
  //     return newAccessToken;
  //   } else {
  //     return null;
  //   }
  // }
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Weight Tracker Data'),
    ),
    body: isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : errorMessage != null
            ? Center(
                child: Text(errorMessage!),
              )
            : Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey.withOpacity(0.3); 
                    }),
                    dataRowColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey.withOpacity(
                          states.contains(MaterialState.selected)
                              ? 0.5
                              : 0.1); 
                    }),
                    columns: [
                      DataColumn(
                        label: Text('Weight (kg)'),
                        tooltip: 'The weight of the person',
                        numeric: true, 
                        onSort: (columnIndex, ascending) {
                          
                        },
                      ),
                      DataColumn(
                        label: Text('Age'),
                        tooltip: 'The age of the person',
                        numeric: true, 
                      ),
                      DataColumn(
                        label: Text('Height (cm)'),
                        tooltip: 'The height of the person',
                        numeric: true, 
                      ),
                      DataColumn(
                        label: Text('Timestamp'),
                        tooltip: 'The timestamp of the entry',
                      ),
                    ],
                    rows: entries.map((entry) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text('${entry.weight}'),
                            onTap: () {
                              
                            },
                          ),
                          DataCell(
                            Text('${entry.age}'),
                            onTap: () {
                              
                            },
                          ),
                          DataCell(
                            Text('${entry.height}'),
                            onTap: () {
                              
                            },
                          ),
                          DataCell(
                            Text('${entry.timestamp} UTC'),
                            onTap: () {
                              
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
  );
}

 String _formatDate(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

class DataEntry {
  final double weight;
  final int age;
  final double height;
  final DateTime timestamp;

  DataEntry({
    required this.weight,
    required this.age,
    required this.height,
    required this.timestamp,
  });

  factory DataEntry.fromJson(Map<String, dynamic> json) {
    return DataEntry(
      weight: json['weight'].toDouble(),
      age: json['age'],
      height: json['height'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']), 
    );
  }
}
