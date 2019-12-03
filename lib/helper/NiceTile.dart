import 'package:flutter/material.dart';

class NiceTile extends StatelessWidget {
  final String header;
  final double headerSize;
  final Widget child;
  NiceTile({@required this.child, this.header = "", this.headerSize = 11});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(fontSize: headerSize),
          ),
          Expanded(
            child: Align(
              child: child,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }
}
