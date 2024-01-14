import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_mobile/constant.dart';
import 'package:to_do_mobile/screens/auth/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_mobile/screens/home_page/home_page_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login Todo",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: emailInput,
              decoration: InputDecoration(hintText: "Email"),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: passwordInput,
              obscureText: true,
              decoration: InputDecoration(hintText: "Password"),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  //login user

                  //Get all input from text fields
                  String email = emailInput.text;
                  String password = passwordInput.text;

                  //connect to api
                  var request = http.MultipartRequest(
                      'POST', Uri.parse('$BASE_URL/login'));

                  //set header
                  request.headers.addAll({'Accept': 'application/json'});
                  //insert form data into the request
                  request.fields.addAll({
                    'email': email,
                    'password': password,
                  });

                  //wait for api to send response
                  http.StreamedResponse response = await request.send();

                  //"{'Accept': 'application/json'}"
                  //200 =  OK
                  if (response.statusCode == 200) {
                    //user logged in
                    final data = await response.stream.bytesToString();
                    Map map = jsonDecode(data) as Map<String, dynamic>;

                    //save token
                    await prefs.setInt('UID', map['data']['id']);

                    //visual feedback
                    SnackBar snackBar = SnackBar(
                      content: Text("Successfully logged in."),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    //handle after login
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) {
                          return MyHomePage(title: "Home");
                        },
                      ),
                    );
                  } else {
                    print(response.reasonPhrase);
                  }
                },
                child: Text("Login")),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return RegisterScreen();
                      },
                    ),
                  );
                },
                child: Text("Go to Register Screen")),
          ],
        ),
      ),
    );
  }
}
