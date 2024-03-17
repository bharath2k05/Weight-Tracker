// // main.dart
// import 'package:flutter/material.dart';
// import 'screens/home_page.dart'; // Import the home page
// import 'screens/data_retrieval_page.dart'; // Import the data retrieval page
// import 'screens/signin_page.dart'; // Import the sign-in page

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fitness Code',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // initialRoute: '/login', // Specify the initial route
//       routes: {
//         '/login': (context) => SignInPage(), // Route for the sign-in page
//         '/home': (context) => HomePage(), // Route for the home page
//         '/dataRetrieval': (context) => DataRetrievalPage(), // Route for the data retrieval page
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'screens/signin_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
    );
  }
}
