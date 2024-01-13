import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_mobile/screens/edit_to_do/edit_to_do_screen.dart';

class ItemContainer extends StatefulWidget {
  const ItemContainer({
    super.key,
  });

  @override
  State<ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
  bool isDone = false;
  bool isOpenOptions = false;
  bool? isChecked = false;

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
              onPressed: () {
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
                title: 'Item to do',
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
              "Item to do",
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
