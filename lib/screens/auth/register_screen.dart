import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_mobile/constant.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Register Todo",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: nameInput,
              decoration: InputDecoration(hintText: "Name"),
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
                  //Get all input from text fields
                  String name = nameInput.text;
                  String email = emailInput.text;
                  String password = passwordInput.text;

                  //connect to api
                  var request = http.MultipartRequest(
                      'POST', Uri.parse('$BASE_URL/register'));

                  //set header
                  request.headers.addAll({'Accept': 'application/json'});
                  //insert form data into the request
                  request.fields.addAll({
                    'name': name,
                    'email': email,
                    'password': password,
                  });

                  //wait for api to send response
                  http.StreamedResponse response = await request.send();

                  //"{'Accept': 'application/json'}"
                  //200 =  OK
                  if (response.statusCode == 200) {
                    final data = await response.stream.bytesToString();
                    Map map = jsonDecode(data) as Map<String, dynamic>;
                    print(map);

                    //visual feedback
                    SnackBar snackBar = SnackBar(
                      content: Text(map['message']),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    print(response.reasonPhrase);
                  }
                },
                child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
