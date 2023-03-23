
import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:apli1/src/gtfs.dart';
import 'package:flutter/services.dart';

import 'add_page.dart';
import 'lignes_page.dart';
import 'map_page.dart';


//import 'package:apli1/pages/lignes_page.dart' as lignesPage;


final ligne1 = "1";
//final async arrets = await loadStops(ligne1) ;


Future<List<List>> _loadCSV(String csvPath) async {
  final _rawData = await rootBundle.loadString(csvPath);
  final list = await CsvToListConverter().convert(_rawData);
  return list;
}




Future<List<String>> loadStops(String ligne) async {

  List <String> stopNames = [];

  final csvList = await _loadCSV("assets/stopsCotentin.csv");

// Parcourir chaque ligne du CSV
  for (List<dynamic> row in csvList) {
    // Vérifier si la colonne "ligne" contient 1
    if (row[1].toString() == ligne) {
      stopNames.add(row[2].toString());

    }
  }

  return stopNames;

}




class ArretsPage extends StatefulWidget {


  const ArretsPage({Key? key}) : super(key: key);


  @override

  State<ArretsPage> createState() => ArretsPageState();

}


class ArretsPageState extends State<ArretsPage> {

final ligne1 = "1";
List arrets = [];



void getArrets() async {

arrets = await loadStops("1");


  setState(() {});

}

  @override

Widget build(BuildContext context) {
    getArrets();
    print(arrets);

    int _currentIndex = 3;

    setCurrentIndex(int index){
      setState(() {
        _currentIndex=index;
      });
    }

return MaterialApp(
    home :  Scaffold(

    body : ListView.builder(

        itemCount: arrets.length,
        itemBuilder: (context, index){

          return GestureDetector(
              //onTap: () => ,
              child : Card(
                  child: ListTile(
                    title: Text(arrets[index].toString()),
                  )

              )
          );
        },
    ),
    ),
    );
  }
}


