import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cronometer extends StatefulWidget {
  Cronometer({Key? key}) : super(key: key);

  @override
  CronometerWidget createState() => CronometerWidget();


}

class CronometerWidget extends State<Cronometer> {
  late Timer _time;
  int _state = 0;
  String _minuteString = "00:00";

  Future<void> startTime() async {
    _time = new Timer.periodic(new Duration(seconds: 1), (Timer timer) {
      setState(() {
        _state++;
        int minutes = (_state / 60).truncate();
        _minuteString = (minutes % 60).toString().padLeft(2, '0') +
            ":" +
            (_state % 60).toString().padLeft(2, '0');
      });
    });
  }
  String getTimeString(){
    return this._minuteString;
  }


  void stopTime() {
    _time.cancel();
  }

  void resetTime() {
    _state = 0;
  }

  void initState() {
    startTime();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this.stopTime();
  }



  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(
              )),
          Text("$_minuteString",
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 25)),
        ],
      ),
    );
  }
}
