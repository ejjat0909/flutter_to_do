import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_mobile/constant.dart';
import 'package:to_do_mobile/models/todo.dart';
import 'package:to_do_mobile/screens/create_to_do/create_to_do_screen.dart';
import 'package:to_do_mobile/screens/home_page/components/item_container.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  late Future<List<Todo>> futureTodos;

  Future<List<Todo>> fetchTodos() async {
    prefs = await SharedPreferences.getInstance();
    final int? uid = prefs.getInt('UID');

    //prepare request
    var request = http.MultipartRequest('GET', Uri.parse('$BASE_URL/readAll'));
    //add headers
    request.headers
        .addAll({'Accept': 'application/json', 'user-id': uid.toString()});
    //send request to server
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      Map map = jsonDecode(data) as Map<String, dynamic>;
      List<dynamic> list = map['data'];
      //convert each item in the list into a Todo object
      List<Todo> todos = list.map((item) => Todo.fromJson(item)).toList();

      return todos;
    } else {
      print(response.reasonPhrase);
    }

    return [];
  }

  void _createCallback(Todo? newTodo) {
    setState(() {
      futureTodos = fetchTodos();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureTodos = fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        child: FutureBuilder(
          future: futureTodos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    Todo todo = snapshot.data![index];
                    return ItemContainer(
                      todo: todo,
                      callback: () => _createCallback(null),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('Error :  ${snapshot.error}');
            }

            //default widget
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) {
                return CreateToDoScreen(callback: _createCallback);
              },
            ),
          );
        },
        tooltip: 'Create To do',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
