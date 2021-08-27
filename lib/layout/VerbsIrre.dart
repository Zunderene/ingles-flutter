
import 'package:flutter/material.dart';
import 'package:ingles/db/dbVerbos.dart';
import 'package:ingles/model/Verbs.dart';
import 'package:ingles/resurce/search.dart';

class VerbIrregularTeoria extends StatefulWidget {
  VerbIrregularTeoria({Key? key}) : super(key: key);

  @override
  _Index createState() => _Index();
}

class _Index extends State<VerbIrregularTeoria> {
  LoadVerbIrre data = new LoadVerbIrre();
  late Stream<List<Verbs>> strem;
  late List<Verbs> muestraSearch;

  void initState() {
    super.initState();
    strem = new Stream.fromFuture(getData());
  }

  Future<List<Verbs>> getData() async {
    muestraSearch = await this.data.loadAsset();
    return muestraSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search(muestraSearch));
              },
              icon: Icon(Icons.search))
        ],
        centerTitle: true,
        title: Text("Busqueda"),
      ),
      body: StreamBuilder<List<Verbs>>(
        stream: strem,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            List<Verbs> ele = snapshot.data as List<Verbs>;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DataTable(
                columnSpacing: 0,
                columns: [
                  DataColumn(label: Text('Presente')),
                  DataColumn(label: Text('Pasado')),
                  DataColumn(label: Text('P.Perfecto')),
                  DataColumn(label: Text('Español'))
                ],
                rows: List.generate(ele.length, (index) {
                  return DataRow(cells: [
                    DataCell(Text(ele[index].pres)),
                    DataCell(Text(ele[index].pas)),
                    DataCell(Text(ele[index].parti)),
                    DataCell(Text(ele[index].spain)),
                  ]);
                }),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}