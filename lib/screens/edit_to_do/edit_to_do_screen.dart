import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_mobile/constant.dart';
import 'package:to_do_mobile/models/todo.dart';
import 'package:http/http.dart' as http;

class EditToDoScreen extends StatefulWidget {
  final Todo todo;
  final Function() callback;
  const EditToDoScreen({super.key, required this.todo, required this.callback});

  @override
  State<EditToDoScreen> createState() => _EditToDoScreenState();
}

class _EditToDoScreenState extends State<EditToDoScreen> {
  TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  late Future<Todo?> futureTodo;

  Future<Todo?> fetchTodo() async {
    prefs = await SharedPreferences.getInstance();
    final int? uid = prefs.getInt('UID');

    //prepare request
    var request = http.MultipartRequest(
        'GET', Uri.parse('$BASE_URL/read?id=${widget.todo.id}'));
    //add headers
    request.headers
        .addAll({'Accept': 'application/json', 'user-id': uid.toString()});
    //send request to server
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      Map map = jsonDecode(data) as Map<String, dynamic>;
      Map<String, dynamic> mapData = map['data'];
      //convert each item in the list into a Todo object
      Todo todo = Todo.fromJson(mapData);
      return todo;
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future updateTodo(String desc) async {
    prefs = await SharedPreferences.getInstance();
    final int? uid = prefs.getInt('UID');

    //prepare request
    var request = http.Request('PUT', Uri.parse('$BASE_URL/update'));
    //add headers
    request.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
      'user-id': uid.toString()
    });
    //set url encoded body
    request.bodyFields = {
      'description': desc,
      'title': widget.todo.title ?? '',
      'id': widget.todo.id.toString(),
      'is_checked': widget.todo.isChecked! ? '1' : '0',
    };
    //send request to server
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      Map map = jsonDecode(data) as Map<String, dynamic>;
      Map<String, dynamic> mapData = map['data'];
      print(mapData['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo Updated')),
      );

      //trigger callback to refresh the list
      widget.callback();
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.description!;
    futureTodo = fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Edit to do"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: FutureBuilder(
            future: futureTodo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        //get textfield val
                        String desc = titleController.text;

                        if (desc == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Description field must not be empty')),
                          );
                          return;
                        }

                        //connect to api
                        await updateTodo(desc);
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error : ${snapshot.error}');
              }

              //default
              //default widget
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
