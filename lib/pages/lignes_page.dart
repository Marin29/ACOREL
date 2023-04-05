import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import 'arrets_page.dart';


class Arrets {

  final List<String> arrets;

  Arrets(this.arrets);
}


//chargement de csv
Future<List<List>> _loadCSV(String csvPath) async {
  final _rawData = await rootBundle.loadString(csvPath);
  final list = await CsvToListConverter().convert(_rawData);
  return list;
}


//De base c'est au format "départ <> Arrivée", donc on veut que Arrivée
List getDestinations(String routeId) {

  List destination = [];

      destination.add(routeId.split("<>")[0].trim()) ;
      destination.add(routeId.split("<>")[1].trim()) ;

  return destination;

}


//Chargement des arrêts par ligne

Future<List<String>> loadStops(String ligne) async {

  List <String> stopNames = [];

  final csvList = await _loadCSV("assets/stopsCotentin.csv");

// Parcourir chaque ligne du CSV
  for (List<dynamic> row in csvList) {
    // Vérifier si la colonne "ligne" contient le numéro de ligne
    if (row[1].toString().contains(ligne)) {
      stopNames.add(row[2].toString());

    }
  }

  //On enlève les doublons
  final arretsFinal = stopNames.toSet().toList();

  return arretsFinal;

}


class SearchPage extends StatefulWidget {


  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  //Je l'ai fait manuellement parce que ça valait pas le coup de le faire dynamiquement pour 6 lignes, mais il est tout à fait
  //possible de récupérer dynamiquement les intitulés, routes et logos
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
  String selectionArret = "";


  void getArrets() async {

    //chaque élément de la liste arretsTout contient tous les arrets d'une ligne
    for(int i = 1; i<7; i++){
      arrets = await loadStops(i.toString());
      arretsTout.add(arrets);
    }


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
          List selectionRoute = getDestinations(route!);


          return GestureDetector(

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
                                    for (int i = 0; i <2; i++)
                                      ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                ArretsPage(direction: selectionRoute[i], arret: arret.toString(), ligne :(index+1).toString()),

                                            )
                                            );
                                          },
                                          title: Text("Direction ${selectionRoute[i]}")
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
