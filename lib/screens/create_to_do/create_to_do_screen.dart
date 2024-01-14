import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_mobile/constant.dart';
import 'package:to_do_mobile/models/todo.dart';

class CreateToDoScreen extends StatefulWidget {
  final Function(Todo) callback;
  const CreateToDoScreen({super.key, required this.callback});

  @override
  State<CreateToDoScreen> createState() => _CreateToDoScreenState();
}

class _CreateToDoScreenState extends State<CreateToDoScreen> {
  TextEditingController descInput = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Create to do"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                controller: descInput,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final int? uid = prefs.getInt('UID');
                  //get input
                  String desc = descInput.text;

                  //validate if input is empty, return from the fuicntion
                  if (desc == '') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Description must not be empty')));
                    //get out from function
                    return;
                  }

                  //connect to api
                  var request = http.MultipartRequest(
                      'POST', Uri.parse('$BASE_URL/create'));

                  //set header
                  request.headers.addAll({'Accept': 'application/json'});
                  //insert form data into the request
                  request.fields.addAll({
                    'user_id': uid.toString(),
                    'description': desc,
                  });

                  //wait for api to send response
                  http.StreamedResponse response = await request.send();

                  //"{'Accept': 'application/json'}"
                  //200 =  OK
                  if (response.statusCode == 200) {
                    final data = await response.stream.bytesToString();
                    Map map = jsonDecode(data) as Map<String, dynamic>;
                    //get todo data
                    Map<String, dynamic> todoData = map['data'];
                    //convert to Todo model
                    Todo newTodo = Todo.fromJson(todoData);

                    //trigger callback to refresh the list
                    widget.callback(newTodo);

                    //visual feedback
                    SnackBar snackBar = SnackBar(
                      content: Text("Todo created!"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    print(response.reasonPhrase);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
