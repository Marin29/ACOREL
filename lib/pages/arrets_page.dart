
import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:apli1/src/gtfs.dart' as gtfs;
import 'package:intl/intl.dart';


import 'add_page.dart';
import 'lignes_page.dart';
import 'map_page.dart';


//import 'package:apli1/pages/lignes_page.dart' as lignesPage;



class ArretsPage extends StatefulWidget {


  final String direction;
  final String arret;
  final String ligne;
  ArretsPage({required this.direction, required this.arret, required this.ligne});


  @override

  State<ArretsPage> createState() => ArretsPageState();

}



class ArretsPageState extends State<ArretsPage> {

  late String direction;
  late String arret;
  late String ligne;
  late String stopId;
  late List Schedule;
  List vehiculeInfos = [];
  List ArrivalTime = [];



  @override
  void initState() {
    getGTFS();
    super.initState();
    direction = widget.direction;
    arret = widget.arret;
    ligne = widget.ligne;
  }

  Future<List<List<dynamic>>> loadCsv(String csvPath) async {
    String csvData = await rootBundle.loadString(csvPath);
    return CsvToListConverter().convert(csvData);
  }

  Future<String?> getIdFromName(String arret) async {

    final List csvList = await loadCsv("assets/stopsCotentin.csv");
    // Parcourir chaque ligne du CSV
    for (List<dynamic> row in csvList) {
      // Vérifier si l'ID de la route correspond
      if (arret.toLowerCase() == row[3].toString().toLowerCase()) {
        stopId = row[0];
        // Retourner la valeur de la colonne route_long_name
        return stopId;
      }
    }
    // Si l'ID de la route n'est pas trouvé, retourner null ou une valeur par défaut
    return "INCONNU";
  }

  void getGTFS() async {
    vehiculeInfos = await gtfs.getData();
    stopId = (await getIdFromName(arret))!;
    ArrivalTime.add(await getArrivalTime(stopId));
    ArrivalTime.add(await getArrivalTime2(stopId));


    /*for(final vehicle in vehiculeInfos){
      print (vehicle.affluence + " " + vehicle.statut);
    }*/
    setState(() {

    });
  }


  List getAffluence(List vehicleInfos, String direction, String arret){
    List affluence = ["Boup"];
    for (final vehicle in vehicleInfos){
      //print(vehicle.destination);
      //print (vehicle.statut);
      if((vehicle.statut).toString().toLowerCase().contains(arret.toLowerCase())
      || (vehicle.destination).toString().toLowerCase().contains(direction.toString().toLowerCase())){
        affluence.add(vehicle.affluence);
      }

    }
    //print(affluence);
    return affluence;
  }

  List<List<dynamic>> filterByStopId(List<List<dynamic>> data, String stopId) {
    stopId = "BARPL2";
    //print(data.where((row) => (row[3].toString()).contains(stopId)).toList());
    return data.where((row) => (row[3].toString()) == stopId).toList();
  }

  int calculateArrivalTime(List<List<dynamic>> data) {
    DateTime now = DateTime.now();
    List<DateTime> departures = data.map((row) => DateFormat('HH:mm:ss').parse((row[1]).toString())).toList();
    departures.sort();
    List differences = [];
    for (var i = 0; i < departures.length; i++) {

      DateTime updatedDateTime =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, departures[i].hour, departures[i].minute, departures[i].second);
      print(updatedDateTime);
      //print (updatedDateTime);
      if (updatedDateTime.isAfter(now)) {
        differences.add(updatedDateTime.difference(now).inMinutes);
        print(differences[0]);
        return differences[0];
      }
    }
    return -1; // aucun bus trouvé
  }

  int calculateArrivalTime2(List<List<dynamic>> data) {
    DateTime now = DateTime.now();
    List<DateTime> departures = data.map((row) => DateFormat('HH:mm:ss').parse((row[1]).toString())).toList();
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
    print(differences[2]);
    return differences[2] + 20;
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

  @override

Widget build(BuildContext context) {

List Boup = getAffluence(vehiculeInfos, direction, arret);
Boup.add("faible");
List Ordre = ["Prochain", "Suivant", "Puis"];

return MaterialApp(
    home :  Scaffold(

    body : Column(

        children: [

          Padding(
    padding: const EdgeInsets.only(top: 45),
      child: Text(
        'Arrêt ${arret.toLowerCase()} direction $direction',
        style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        textAlign: TextAlign.center,

      ),
    ),
    Expanded(
    child: ListView.builder(

        itemCount: 2,

        itemBuilder: (context, index){

          String affluenceListe = Boup[index];

          Widget image;
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


