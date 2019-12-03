// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/helper/NiceTile.dart';
import 'package:digital_clock/helper/WeatherTile.dart';
import 'package:digital_clock/helper/digit.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  String _timeString = ""; //10:10 in pixel
  // D   D : D   D
  // 9 1 9 4 9 1 9 = 42 pixels
  // Make sure digit data fit defined width & height!
  final canvasWidth = 42;
  final canvasHeight = 9; //9 pixel = height of digit
  final horizontalPadding = 25;
  // small caching
  bool firstCalc = false;
  double sizeW = 1;
  double sizeH = 1;
  double size = 1;
  double firstY = 1;
  double firstX = 1;

  String _temperatureString = "";
  String _temperatureRange = "";
  bool _is24HourFormat = true;
  WeatherCondition _weatherCondition = WeatherCondition.cloudy;

  /// code from repo
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime(firstLoad: true);
    _updateModel();

    for (int i = 0; i < canvasWidth * canvasHeight; i++) {
      _timeString += " ";
    }
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperatureString = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _weatherCondition = widget.model.weatherCondition;
      _is24HourFormat = widget.model.is24HourFormat;
    });

    print("different");
    _buildTimeString();
  }

  void _updateTime({bool firstLoad = false}) {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
    _buildTimeString(firstLoad: firstLoad);
  }
  // code from repo

  List<Widget> _buildDigitalClock(double maxWidth, double maxHeight) {
    if (!firstCalc) {
      sizeW = (maxWidth - horizontalPadding) / canvasWidth;
      sizeH = maxHeight / canvasHeight;
      size = sizeW < sizeH ? sizeW : sizeH;
      firstY = 5; //padding top
      firstX = ((maxWidth - horizontalPadding - size * canvasWidth) +
          size / 2); //22 dot left 22 dot right
    }

    List<Widget> out = [];
    for (int i = 0; i < canvasHeight; i++) {
      for (int j = 0; j < canvasWidth; j++) {
        out.add(
            _buildSinglePixel(maxWidth, maxHeight, i, j, size, firstX, firstY));
      }
    }

    if (!_is24HourFormat) {
      String ampm = _dateTime.hour > 12 ? "PM" : "AM";
      out.add(
        Positioned(
          child: Text(
            ampm,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          right: 10,
          bottom: 10,
        ),
      );
    }
    return out;
  }

  Widget _buildSinglePixel(double maxWidth, double maxHeight, int i, int j,
      double size, double firstX, double firstY) {
    double posX =
        (j - canvasWidth / 2) * size - (size / 2) + firstX + maxWidth / 2;
    double posY =
        (i - canvasHeight / 2) * size - (size / 2) + firstY + maxHeight / 2;

    return Positioned(
      top: posY,
      left: posX,
      child: _buildPixel(i * canvasWidth + j, size),
    );
  }

  bool isOn(int index) {
    // return true;
    return _timeString.length > index
        ? _timeString.substring(index, index + 1) == "#"
        : false;
  }

  List<String> _prevDigitList = ["", "", "", ""];

  void editAndBuild() {
    setState(() {
      _dateTime = _dateTime.add(Duration(minutes: 1));
    });
    _buildTimeString();
  }

  void _buildTimeString({bool firstLoad = false}) {
    String finalTimeString = "";
    List<String> digitList = []; //4 digit string from digit.dart
    DateTime time = _dateTime;
    if (!_is24HourFormat) {
      time = DateTime(time.year, time.month, time.day,
          time.hour > 12 ? time.hour - 12 : time.hour, time.minute);
    }

    if (time.hour < 10) {
      //single digit
      digitList.addAll([
        digit0,
        switchTime(time.hour.toString()),
      ]);
    } else {
      digitList.addAll(
        time.hour.toString().split("").map((val) => switchTime(val)),
      );
    }

    if (time.minute < 10) {
      //single digit
      digitList.addAll([
        digit0,
        switchTime(time.minute.toString()),
      ]);
    } else {
      digitList.addAll(
        time.minute.toString().split("").map((val) => switchTime(val)),
      );
    }

    for (int i = 0; i < canvasHeight; i++) {
      int start = i * 9; //width of digit
      finalTimeString += digitList[0].substring(start, start + 9);
      // print("$start ${start+9}");
      finalTimeString += " ";

      finalTimeString += digitList[1].substring(start, start + 9);

      //:
      if (i == 3 || i == 5) {
        finalTimeString += " ## ";
      } else {
        finalTimeString += "    ";
      }

      finalTimeString += digitList[2].substring(start, start + 9);
      finalTimeString += " ";

      finalTimeString += digitList[3].substring(start, start + 9);
    }

    //for first load, just direct setState without animation
    if (firstLoad) {
      setState(() {
        _prevDigitList = digitList;
        _timeString = finalTimeString;
      });
      return;
    }

    // change timeString pixel by pixel
    // if prefer separated into 4 column
    List<int> widthList = [9, 9, 9, 9];
    List<int> startList = [0, 10, 23, 33]; // skip : here
    for (int x = 0; x < 4; x++) {
      //only animate if digit changed
      if (_prevDigitList[x] != digitList[x]) {
        int start = startList[x];
        //for height
        for (int i = 0; i < canvasHeight; i++) {
          for (int j = 0; j < widthList[x]; j++) {
            int index = i * canvasWidth + j + start;
            //i is row. j is column. x is digit
            int delay = 100 * i + j * 50 + x * 150;

            //clear first (optional)
            Future.delayed(Duration(milliseconds: delay), () {
              asyncUpdate(index, " ");
            });

            //wait time before rendering next digit
            int waitFinish = (75 * canvasHeight + widthList[x] * 50 + 400) ~/ 4;
            //then show again
            Future.delayed(Duration(milliseconds: delay + waitFinish), () {
              asyncUpdate(
                index,
                finalTimeString.substring(index, index + 1),
              );
            });
          }
        }
      }
    }

    setState(() {
      _prevDigitList = digitList;
    });

    // if prefer a line at a time
    // for (int i=0;i<finalTimeString.length;i++){
    //   Future.delayed(Duration(milliseconds: 10*i), (){
    //     asyncUpdate(i, finalTimeString.substring(i,i+1));
    //   });
    // }
  }

  void asyncUpdate(int index, String val) async {
    String newString = _timeString;
    newString = newString.replaceRange(index, index + 1, val);
    // print("wa $newString");
    setState(() {
      _timeString = newString;
    });
  }

  Widget _buildPixel(int index, double size) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    size -= 1; //add padding

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
      color: colors[_Element.text],
      margin: isOn(index)
          ? EdgeInsets.only(top: 0, left: 0)
          : EdgeInsets.only(top: size / 2, left: size / 2),
      width: isOn(index) ? size : 0,
      height: isOn(index) ? size : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final height = MediaQuery.of(context).size.height;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'calibri',
      fontSize: height / 15,
    );

    return Container(
      color: colors[_Element.background],
      child: Column(
        children: <Widget>[
          DefaultTextStyle(
            style: defaultStyle,
            child: Container(
              height: height * 0.2,
              child: Row(
                children: <Widget>[
                  NiceTile(
                    header: "Weather",
                    headerSize: defaultStyle.fontSize / 1.5,
                    child: WeatherTile(
                      _weatherCondition,
                      size: defaultStyle.fontSize * 1.5,
                    ),
                  ),
                  // HorizontalDivider(),
                  NiceTile(
                    header: "Temperature",
                    headerSize: defaultStyle.fontSize / 1.5,
                    child: Text("$_temperatureString $_temperatureRange"),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: NiceTile(
                        header: "Date",
                        headerSize: defaultStyle.fontSize / 1.5,
                        child: Text(
                            "${_dateTime.year}/${_dateTime.month}/${_dateTime.day}"),
                      ),
                    ),
                  ),
                  // RaisedButton(
                  //   child: Text("Change time"),
                  //   onPressed: editAndBuild,
                  // ),
                ],
              ),
            ),
          ),
          Divider(
            color: colors[_Element.text],
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (ctx, constraint) {
                return Container(
                  // color: Colors.red,
                  child: Stack(
                    children: _buildDigitalClock(
                      constraint.maxWidth,
                      constraint.maxHeight,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
