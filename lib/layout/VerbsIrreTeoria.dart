import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ingles/db/dbVerbos.dart';
import 'package:ingles/model/Verbs.dart';
import 'package:ingles/resurce/evaluation.dart';

import '../constant.dart';

class VerbIrregularTest extends StatefulWidget {
  VerbIrregularTest({Key? key}) : super(key: key);

  @override
  _VerbIrregularTest createState() => _VerbIrregularTest();
}

class _VerbIrregularTest extends State<VerbIrregularTest> {
  Evaluacion eva = new Evaluacion(numEjercicios: 0, numFallos: 0, timeTotal: 0);
  Map<String, TextEditingController> tControllers = {
    "Presente": new TextEditingController(),
    "Pasado": new TextEditingController(),
    "Pas Perfecto": new TextEditingController(),
  };
  Map<String, Color> listBorderColor = {
    "Presente": Color(0xFF000000),
    "Pasado": Color(0xFF000000),
    "Pas Perfecto": Color(0xFF000000),
  };

  int realizado = 0;
  int numFallos = 0;
  Map<String, bool> correct = {
    "Presente": false,
    "Pasado": false,
    "Pas Perfecto": false,
  };
  late List<Verbs> ele;
  late Timer _time;
  int _state = 0;
  String _minuteString = "00:00";

  LoadVerbIrre data = new LoadVerbIrre();
  late Future<List<Verbs>> muestraSearch = getData();
  Verbs? muestra = null;

  void initState() {
    startTime();
    super.initState();
  }

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

  void stopTime() {
    _time.cancel();
  }

  void resetTime() {
    _state = 0;
  }

  @override
  void dispose() {
    super.dispose();
    this.stopTime();
  }

  Future<List<Verbs>> getData() async {
    return await this.data.loadAsset();
  }

  createAlertDialog(BuildContext constext) {
    return AlertDialog(
      backgroundColor: Colores['primary'],
      elevation: 1.0,
      content: Container(
          height: 280,
          child: Column(
            children: [
              Text(
                "Correcto",
                style: TextStyle(fontSize: 50, color: Color(0xFFFFFFFF)),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colores['secondary'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("Tiempo " + this._minuteString,
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                  "Ejercicios resueltos " +
                                      eva.numEjercicios.toString(),
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                          ]))))
            ],
          )),
      actions: [
        TextButton(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              alignment: Alignment(0, 0),
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: new BoxDecoration(
                  color: Color(0xFFFF0206),
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFFF0206))),
              child: Text("Salir", style: TextStyle(color: Color(0xFF000000)))),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              alignment: Alignment(0, 0),
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: new BoxDecoration(
                  color: Color(0xFF3474E0),
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFF512DA8))),
              child: Text("Ok", style: TextStyle(color: Color(0xFF000000)))),
          onPressed: () {
            Navigator.of(context).pop(true);
            this.startTime();
          },
        )
      ],
    );
  }

  Widget crono() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          Positioned.fill(child: Container()),
          Text("$_minuteString",
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 25)),
        ],
      ),
    );
  }

  changeText(val, key, e) {
    Map<String, String> mpp = {
      'Presente': e.pres.split('[')[0],
      'Pasado': e.pas.split('[')[0],
      'Pas Perfecto': e.parti.split('[')[0]
    };
    // Si es identico //
    if (mpp[key] == val) {
      setState(() {
        this.correct[key] = true;
        this.listBorderColor[key] = Color(0xff00fd28);
      });
    }
    // Si expieza de la misma forma //
    else if (mpp[key]!.startsWith(val) && val.isNotEmpty) {
      setState(() {
        this.listBorderColor[key] = Color(0xFFffcc2f);
      });
    }
    // Si esta totalmente erroneo //
    else if (val.isNotEmpty) {
      setState(() {
        this.listBorderColor[key] = Color(0xFFFF0000);
      });
      // Esta vacio //
    } else {
      setState(() {
        this.listBorderColor[key] = Color(0xFF000000);
      });
    }

    if (correct.values.every((element) => element)) {
      this.stopTime();
      this.setState(() {
        this.tControllers.forEach((key, value) {
          value.text = "";
        });
        this.correct.forEach((key, value) {
          this.correct[key] = false;
        });
        this.muestra = this.ele[Random().nextInt(this.ele.length)];
        this.listBorderColor.forEach((key, value) {
          this.listBorderColor[key] = Color(0xFF000000);
        });

        this.eva.numEjercicios++;

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return this.createAlertDialog(context);
            });
        resetTime();
      });
    }
  }

  Widget createForm(Verbs ele) {
    List<Widget> form = [
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
        decoration: BoxDecoration(
            color: Color(0xFF0D47A1),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            )),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Text(muestra!.spain.toUpperCase(),
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 50)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: this.crono(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Realizados " + eva.numEjercicios.toString(),
                          style: TextStyle(
                              color: Color(0xFFFFFFFF), fontSize: 20)),
                    ],
                  ),
                ),
              ],
            )),
      ),
    ];
    tControllers.forEach((key, value) {
      form.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xfffca362),
                  Color(0xFFfd9f3e),
                  Color(0xfffabc84),
                ]),
                border: Border.all(width: 5, color: Color(0xffff7e1d)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(key,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5))));
      form.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
          child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 5, color: this.listBorderColor[key]!),
              ),
              child: TextField(
                  onChanged: (val) {
                    this.changeText(val, key, ele);
                  },
                  controller: value,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  )))));
    });

    return SingleChildScrollView(
        child: Column(
      children: form,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFDD00),
        body: Container(
            child: FutureBuilder<List<Verbs>>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<List<Verbs>> snapshot) {
            if (snapshot.hasData) {
              if (muestra == null) {
                ele = snapshot.requireData;
                muestra = ele[Random().nextInt(ele.length)];
              }
              return createForm(muestra!);
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        )));
  }
}
