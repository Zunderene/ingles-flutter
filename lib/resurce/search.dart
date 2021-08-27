import 'package:flutter/material.dart';
import 'package:ingles/model/Verbs.dart';

class Search extends SearchDelegate {
  late List<Verbs> selectResults;
  List<Verbs> suggestionsLate = [];
  List<Verbs> recentList = [];
  List<Verbs> listElement = [];

  Search(ele) {
    this.listElement = ele;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        itemCount: selectResults.length,
        itemBuilder: (context, index) {
          return Card(
              margin:  EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          selectResults[index].pres.split("[")[0],
                          style: TextStyle(fontSize: 16),
                        ),
                        Text('[' + selectResults[index].pres.split("[")[1]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          selectResults[index].pas.split("[")[0],
                          style: TextStyle(fontSize: 16),
                        ),
                        Text('[' + selectResults[index].pas.split("[")[1]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          selectResults[index].parti.split("[")[0],
                          style: TextStyle(fontSize: 16),
                        ),
                        Text('[' + selectResults[index].parti.split("[")[1]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          selectResults[index].spain,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              )
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    int _selectItem = 0;
    selectResults = [];
    suggestionsLate.clear();
    query.isEmpty
        ? suggestionsLate = recentList
        : suggestionsLate.addAll(listElement.where((element) =>
    (element.spain == query ||
        (element.spain
            .split(",")
            .map((e) => e.replaceAll(' ', "").trim())
            .contains(query) ||
            (element.spain.startsWith(query))))));

    return ListView.builder(
        itemCount: suggestionsLate.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionsLate[index].spain),
            subtitle: Text(suggestionsLate[index].pres),
            selected: index == _selectItem,
            onTap: () {
              _selectItem = index;
              //selectResults = suggestionsLate[_selectItem];
              selectResults.addAll(listElement.where((element) =>
              (element.spain == query ||
                  (element.spain
                      .split(",")
                      .map((e) => e.replaceAll(' ', "").trim())
                      .contains(suggestionsLate[_selectItem].spain) ||
                      (element.spain.startsWith(suggestionsLate[_selectItem].spain))))));
              showResults(context);
            },
          );
        });
  }
}