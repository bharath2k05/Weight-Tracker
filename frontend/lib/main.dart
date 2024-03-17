// // main.dart
// import 'package:flutter/material.dart';
// import 'screens/home_page.dart'; 
// import 'screens/data_retrieval_page.dart'; 
// import 'screens/signin_page.dart'; 

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
//       // initialRoute: '/login', 
//       routes: {
//         '/login': (context) => SignInPage(),
//         '/home': (context) => HomePage(), 
//         '/dataRetrieval': (context) => DataRetrievalPage(), 
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
