
import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:apli1/src/gtfs.dart' as gtfs;
import 'package:intl/intl.dart';


class ArretsPage extends StatefulWidget {


  final String direction;
  final String arret;
  final String ligne;
  ArretsPage({required this.direction, required this.arret, required this.ligne});


  @override

  State<ArretsPage> createState() => ArretsPageState();

}



class ArretsPageState extends State<ArretsPage> {

  //Récupération de la sélection de la page précédente
  late String direction;
  late String arret;
  late String ligne;


  late String stopId;
  late List Schedule;
  List vehiculeInfos = [];

  //Initialisation le temps que les données chargent, sans ça ça fait un message d'erreur moche pendant le chargement
  List ArrivalTime = ["en cours de calcul","en cours de calcul", "en cours de calcul" ];



  @override
  void initState() {
    getGTFS();
    super.initState();

    direction = widget.direction;
    arret = widget.arret;
    ligne = widget.ligne;
  }

  //Chargement du csv
  Future<List<List<dynamic>>> loadCsv(String csvPath) async {
    String csvData = await rootBundle.loadString(csvPath);
    return CsvToListConverter().convert(csvData);
  }


  //On récupère l'id des véhicules arrivant à cet arrêt à partir du nom de l'arrêt
  Future<String?> getIdFromName(String arret) async {

    final List csvList = await loadCsv("assets/stopsCotentin.csv");
    // Parcourir chaque ligne du CSV
    for (List<dynamic> row in csvList) {
      // Vérifier si l'ID de la route correspond
      if (arret.toLowerCase() == row[3].toString().toLowerCase()) {
        stopId = row[0];
        return stopId;
      }
    }
    // Si l'ID de la route n'est pas trouvé, retourner null ou une valeur par défaut
    return "INCONNU";
  }

  void getGTFS() async {

    //On récupère les données GTFS RT
    vehiculeInfos = await gtfs.getData();
    stopId = (await getIdFromName(arret))!;

    //Calcul du temps d'arrivée des 3 prochains véhicules
    ArrivalTime[0] = await getArrivalTime(stopId);
    ArrivalTime[1] = (await getArrivalTime2(stopId));
    ArrivalTime[2] = (await getArrivalTime3(stopId)) + 10;


    setState(() {

    });
  }


  List getAffluence(List vehicleInfos, String direction, String arret){
    List affluence = ["Boup"];
    for (final vehicle in vehicleInfos){

      // Si le statut du véhicule contient le nom de l'arret et la destination correspond, alors on récupère son affluence
      // précédémment calculée dans gtfs.dart
      if((vehicle.statut).toString().toLowerCase().contains(arret.toLowerCase())
      || (vehicle.destination).toString().toLowerCase().contains(direction.toString().toLowerCase())){
        affluence.add(vehicle.affluence);
      }

    }
    return affluence;
  }


    //TODO : Récupérer le stopId en fonction de la sélection

  List<List<dynamic>> filterByStopId(List<List<dynamic>> data, String stopId) {
    stopId = "BARPL2";

    // On utilise le csv stop_times qui contient les horaires (colonne 4) ainsi que les id des arrêts
    return data.where((row) => (row[3].toString()) == stopId).toList();
  }


  //TODO : Optimiser tout ça je sais c'est pas propre du tout mais ça a le mérite de marcher
  int calculateArrivalTime(List<List<dynamic>> data) {

    //On récupère l'heure et la date actuelle
    DateTime now = DateTime.now();
    List<DateTime> departures = data.map((row) => DateFormat('HH:mm:ss').parse((row[1]).toString())).toList();
    departures.sort();
    List differences = [];

    for (var i = 0; i < departures.length; i++) {

      //
      DateTime updatedDateTime =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, departures[i].hour, departures[i].minute, departures[i].second);
      //print (updatedDateTime);
      if (updatedDateTime.isAfter(now)) {
        //Pour chaque horaire, s'il se situe après l'heure actuelle on calcule la différence et on l'ajoute à la liste
        differences.add(updatedDateTime.difference(now).inMinutes);
        return differences[0];
      }
    }
    return -1; // aucun bus trouvé
  }


  //Pour le deuxième véhicule
  int calculateArrivalTime2(List<List<dynamic>> data) {
    DateTime now = DateTime.now();

    //On récupère et formate les horaires du CSV stop_times
    List<DateTime> departures = data.map((row) => DateFormat('HH:mm:ss').parse((row[1]).toString())).toList();

    //On trie par ordre croissant
    departures.sort();
    List differences = [];
    List<DateTime> updatedDateTime = [];
    for (var i = 0; i < departures.length; i++) {
      updatedDateTime.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, departures[i].hour, departures[i].minute, departures[i].second));
      //print (updatedDateTime);
      if (updatedDateTime[i].isAfter(now)) {
        differences.add(updatedDateTime[i].difference(now).inMinutes);
      }
    }
    return differences[1];
  }

  //Pour le troisième véhicule
  int calculateArrivalTime3(List<List<dynamic>> data) {
    DateTime now = DateTime.now();
    List<DateTime> departures = data.map((row) => DateFormat('HH:mm:ss').parse((row[1]).toString())).toList();
    departures.sort();
    List differences = [];
    List<DateTime> updatedDateTime = [];
    for (var i = 0; i < departures.length; i++) {
      updatedDateTime.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, departures[i].hour, departures[i].minute, departures[i].second));
      if (updatedDateTime[i].isAfter(now)) {
        differences.add(updatedDateTime[i].difference(now).inMinutes);
      }
    }
    print(differences[2]);
    return differences[2];
  }


  Future<int> getArrivalTime(String stopId) async {
    List<List<dynamic>> data = await loadCsv("assets/stop_times.csv");
    List<List<dynamic>> filteredData = filterByStopId(data, stopId);
    return calculateArrivalTime(filteredData);
  }

  Future<int> getArrivalTime2(String stopId) async {
    List<List<dynamic>> data = await loadCsv("assets/stop_times.csv");
    List<List<dynamic>> filteredData = filterByStopId(data, stopId);
    return calculateArrivalTime2(filteredData);
  }

  Future<int> getArrivalTime3(String stopId) async {
    List<List<dynamic>> data = await loadCsv("assets/stop_times.csv");
    List<List<dynamic>> filteredData = filterByStopId(data, stopId);
    return calculateArrivalTime3(filteredData);
  }
  @override

Widget build(BuildContext context) {
    final affluences = ["nulle", "faible","moyenne", "forte", "très forte"];
List AffluencesArret = getAffluence(vehiculeInfos, direction, arret);
AffluencesArret.add(gtfs.selectRandom(affluences));
AffluencesArret.add(gtfs.selectRandom(affluences));

List Ordre = ["Prochain", "Suivant", "Puis"];

return MaterialApp(

    home :  Scaffold(

    body : Column(

        children: [

          //Titre qui affiche la ligne, l'arret et la destination choisis
          Padding(
    padding: const EdgeInsets.only(top: 45),
      child: Text(
        'Ligne ${ligne.toLowerCase()} :Arrêt ${arret.toLowerCase()} direction $direction',
        style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        textAlign: TextAlign.center,

      ),
    ),

    Expanded(

    child: ListView.builder(

        itemCount: 3,

        itemBuilder: (context, index){

          String affluenceListe = AffluencesArret[index];

          Widget image;
          //Assignation de l'icone en fonction de l'affluence
          switch(affluenceListe){

            case 'nulle':
              image  = Image.asset("assets/images/tres_faible.png");
              break;
            case 'faible':
              image  = Image.asset("assets/images/faible.png");
              break;
            case 'moyenne':
              image  = Image.asset("assets/images/moyenne.png");
              break;
            case 'forte':
              image  = Image.asset("assets/images/forte.png");
              break;
            case 'très forte':
              image  = Image.asset("assets/images/tres_forte.png");
              break;
              default:
                image  = Image.asset("assets/images/moyenne.png");

          }

              return Card(
                  child: ListTile(
                    title : Text("${Ordre[index]}"),
                    subtitle: Text("${ArrivalTime[index].toString()} minutes"),
                    trailing: image,
                  )

              );
        },
    ),
    ),
        ],

    ),
    ),
    );

  }
}


