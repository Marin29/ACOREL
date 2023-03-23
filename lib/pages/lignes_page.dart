import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:apli1/src/gtfs.dart';
import 'package:flutter/services.dart';

import 'arrets_page.dart';

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


Future<List<String>> getLigne(int index) async {
  final ligne = (index + 1 ).toString();

  final arrets = await loadStops(ligne);

  print("test 1");

  return arrets;
}



class SearchPage extends StatefulWidget {


  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final ligne1 = 1;
  final events =[
    {
      "intitule": "Ligne 1",
      "route": "Les Fourches <> Schuman-Delaville",
      "logo": "Macarons-Lignes-1.png"
    },
    {
      "intitule": "Ligne 2",
      "route": "Digard <> Collignon",
      "logo": "Ligne-2_sept22.jpg"
    },
    {
      "intitule": "Ligne 3",
      "route": "Brécourt <> Eglantine château",
      "logo": "Macarons-Lignes-3.png"
    },
    {
      "intitule": "Ligne 4",
      "route": "Amfreville <> Marettes",
      "logo": "Macarons-Lignes-4.png"
    },
    {
      "intitule": "Ligne 5",
      "route": "Querqueville/Amfreville <> Flamands",
      "logo": "Macarons-Lignes-5.png"
    },
    {
      "intitule": "Ligne 6",
      "route": "Polyclinique <> Sauxmarais",
      "logo": "Macarons-Lignes-6.jpg"
    }

  ];

  List arrets = [];

  void getArrets() async {

    arrets = await loadStops("1");

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    getArrets();
    return Center(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index){
          final event = events[index];
          final logo = event['logo'];
          final intitule = event['intitule'];
          final route = event['route'];


          return GestureDetector(
            /*onTap: () =>
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_,__,___) => ArretsPage()
                    )
                ),*/
              child : Card(
                  child: ExpansionTile(
                      leading: Image.asset("assets/images/$logo"),
                      title: Text("$intitule"),
                      subtitle: Text("$route"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      children :  [
                         Column (
                           children : [
                             for (final arret in arrets)
                              ListTile(
                                title: Text(arret.toString()),
                              )
                           ]
                        )
                      ]
                  )
              )

              );
        },

      ),
    );
  }
}
