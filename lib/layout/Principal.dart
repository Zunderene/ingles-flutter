import 'package:flutter/material.dart';
import '../constant.dart';
import 'VerbsIrre.dart';
import 'VerbsIrreTeoria.dart';


class Principal extends StatefulWidget {
  Principal({Key? key}) : super(key: key);

  @override
  _Principal createState() => _Principal();
}

class _Principal extends State<Principal> {


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores['background'],
      body: Padding(
          padding:  EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Container(
            alignment: Alignment(0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 60),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 35),
                        ),
                        onPressed: () { Navigator.push( context,
                          MaterialPageRoute(builder: (context) =>
                              VerbIrregularTeoria()),
                        );},
                        child: const Text('Teoria'),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 35),
                        ),
                        onPressed: () { Navigator.push( context,
                          MaterialPageRoute(builder: (context) =>
                              VerbIrregularTest()),
                        );},
                        child: const Text('Ejercicios'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}