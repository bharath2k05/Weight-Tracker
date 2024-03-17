import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data_retrieval_page.dart'; 
import 'signin_page.dart'; 

class HomePage extends StatefulWidget {
  final String loggedInUsername;
  final String accessToken;
  final String refreshToken;

  const HomePage({
    Key? key,
    required this.loggedInUsername,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  Future<void> submitData() async {
    final String weight = weightController.text.trim();
    final String age = ageController.text.trim();
    final String height = heightController.text.trim();

    
    final String timestamp = DateTime.now().toIso8601String();


    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/track/add_weight_entry/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
      body: {
        'weight': weight,
        'age': age,
        'height': height,
        'timestamp': timestamp, 
      },
    );

    if (response.statusCode == 201) {
      
      weightController.clear();
      ageController.clear();
      heightController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data submitted successfully'),
        ),
      );
    } else {
      
    }
  }

  void navigateToDataRetrievalPage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DataRetrievalPage(
        accessToken: widget.accessToken,
        refreshToken: widget.refreshToken,
        loggedInUsername: widget.loggedInUsername,
      ),
    ),
  );
}


  void signOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Icon(Icons.fitness_center, size: 30), 
          SizedBox(width: 10), 
          Expanded( 
            child: Text(
              'Weight Tracker',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            InkWell(
              onTap: navigateToDataRetrievalPage,
              child: Row(
                children: [
                  Icon(Icons.list),
                  SizedBox(width: 5),
                  Text('View Data'),
                ],
              ),
            ),
            SizedBox(width: 18),
            InkWell(
              onTap: signOut,
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 4),
                  Text('Sign Out'),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
    body: Center(
      child: Container(
        width: 300, 
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter your metrics', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: submitData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}