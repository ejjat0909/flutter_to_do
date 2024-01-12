import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isDone = !isDone;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
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
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isDone = !isDone;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
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
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isDone = !isDone;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
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
            ),
          ),
        ),
      ],
    );
  }
}
