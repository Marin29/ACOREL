import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:apli1/src/gtfs.dart';
import 'package:flutter/services.dart';

Future<List<List>> _loadCSV(String csvPath) async {
  final _rawData = await rootBundle.loadString(csvPath);
  final list = await CsvToListConverter().convert(_rawData);
  return list;
}


Future<void> loadStops() async {
  String stopNames = "";
  String ligne = "1";

  final csvList = await _loadCSV("assets/stopsCotentin.csv");

// Parcourir chaque ligne du CSV
  for (List<dynamic> row in csvList) {
    // Vérifier si la colonne "ligne" contient 1
    if (row[1].toString() == ligne) {
      stopNames = row[2].toString();
      print(stopNames);

    }
      // Ajouter le nom de l'arrêt à l'ensemble
    }
  }

// Afficher les noms d'arrêt dans l'ensemble




class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index){
          final event = events[index];
          final logo = event['logo'];
          final intitule = event['intitule'];
          final route = event['route'];

          return GestureDetector(
            onTap: () => loadStops(),
              child : Card(
              child: ListTile(
                leading: Image.asset("assets/images/$logo"),
                title: Text("$intitule"),
                subtitle: Text("$route"),
                trailing: const Icon(Icons.arrow_forward_ios),
              )

              )
          );
        },

      ),
    );
  }
}
