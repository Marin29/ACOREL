import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:apli1/src/gtfs.dart';
import 'package:flutter/services.dart';

import 'arrets_page.dart';


class Arrets {

  final List<String> arrets;

  Arrets(this.arrets);
}

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
    if (row[1].toString().contains(ligne)) {
      stopNames.add(row[2].toString());

    }
  }

  final arretsFinal = stopNames.toSet().toList();

  return arretsFinal;

}


Future<List<String>> getLigne(int index) async {

  final ligne = (index).toString();

  final arrets = await loadStops(ligne);

  print("test 1");
  final arretsFinal = arrets.toSet().toList();

  return arretsFinal;
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

  List arretsTout = [];
  List arrets = [];


  void getArrets() async {

    arrets = await loadStops("1");
    arretsTout.add(arrets);
    arrets = await loadStops("2");
    arretsTout.add(arrets);
    arrets = await loadStops("3");
    arretsTout.add(arrets);
    arrets = await loadStops("4");
    arretsTout.add(arrets);
    arrets = await loadStops("5");
    arretsTout.add(arrets);
    arrets = await loadStops("6");
    arretsTout.add(arrets);

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
                      textColor : Colors.red,
                      iconColor : Colors.red,
                      subtitle: Text("$route"),
                      children :  [
                         Column (
                           children : [
                             for (final arret in arretsTout[index])
                              ExpansionTile(
                                title: Text(arret.toString()),
                                textColor : Colors.red,
                                  iconColor : Colors.red,
                                  children : [
                                  ListTile(
                                      title : Text("bip boup ceci est un test")
                                  )

                                ]
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
