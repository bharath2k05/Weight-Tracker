import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 
import 'home_page.dart'; 

class SignInPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/track/login/'), 
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String accessToken = responseData['access_token'];
      final String refreshToken = responseData['refresh_token'];

      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);

      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(loggedInUsername: username, accessToken: accessToken, refreshToken: refreshToken)),
      );
    } else {
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign In Failed'),
          content: Text('Invalid username or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Weight Tracker'), 
    ),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 30), 
                SizedBox(width: 10), 
                Text(
                  'Weight Tracker',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), 
                ), 
              ],
            ),
            SizedBox(height: 20.0),
            
            Container(
              constraints: BoxConstraints(maxWidth: 400), 
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => signIn(context),
                    child: Text('Sign In'),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text('Create a new account'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/track/register/'), 
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 201) {
      
      Navigator.pop(context); 

      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Your account has been created successfully. You can now sign in.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text('Username Already Exists'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Register'),
    ),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 30),
                SizedBox(width: 10),
                Text(
                  'Weight Tracker',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            Container(
              width: 300, 
              child: Column(
                children: [
                  
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  
                  ElevatedButton(
                    onPressed: () => register(context),
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
