import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_mobile/constant.dart';
import 'package:to_do_mobile/models/todo.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_mobile/screens/edit_to_do/edit_to_do_screen.dart';

class ItemContainer extends StatefulWidget {
  final Todo todo;
  final Function() callback;
  const ItemContainer({
    super.key,
    required this.todo,
    required this.callback,
  });

  @override
  State<ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
  bool isDone = false;
  bool isOpenOptions = false;
  bool? isChecked = false;
  late SharedPreferences prefs;

  Future _deleteTodo() async {
    prefs = await SharedPreferences.getInstance();
    final int? uid = prefs.getInt('UID');

    //prepare request
    var request = http.Request(
        'DELETE', Uri.parse('$BASE_URL/delete?id=${widget.todo.id}'));
    //add headers
    request.headers.addAll({'user-id': uid.toString()});

    //send request to server
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      Map map = jsonDecode(data) as Map<String, dynamic>;
      Map<String, dynamic> mapData = map['data'];
      print(mapData['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo Deleted')),
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
    isChecked = widget.todo.isChecked;
  }

  // alert dialog
  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete To Do?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _deleteTodo();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteDialog();
      },
      onTap: () {
        // go to edit page
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) {
              return EditToDoScreen(
                todo: widget.todo,
                callback: widget.callback,
              );
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.lightBlue[200],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.todo.description ?? "",
              textAlign: TextAlign.left,
              style: TextStyle(
                decoration:
                    // inline if else (ternary operator)
                    isDone ? TextDecoration.lineThrough : TextDecoration.none,
                // if (isDone){
                //  TextDecoration.lineThrough
                // } else {
                // TextDecoration.none
                // }
              ),
            ),
            Checkbox(
              // tristate: true,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value;
                  isDone = !isDone;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
