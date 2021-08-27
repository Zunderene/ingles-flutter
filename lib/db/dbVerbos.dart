import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ingles/model/Verbs.dart';

class LoadVerbIrre {
  late String myData;
  late List<Verbs> listVerbs;
  late Widget tableData;
  List<List<dynamic>> data = [];

  loadAsset() async {
    final myData = await rootBundle.loadString("asset/data/verbos.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);

    data = csvTable;
    listVerbs = List.generate(data.length, (index) {
      return Verbs(index, data[index][0], data[index][1], data[index][2],
          data[index][3]);
    });

    return listVerbs;
  }


  @override
  String toString() {
    return 'Verbos{myData: $listVerbs }';
  }
}
