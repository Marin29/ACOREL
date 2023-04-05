import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gtfs_realtime_bindings/gtfs_realtime_bindings.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:protobuf/protobuf.dart';


class VehicleInfo {
  final String id;
  final String route;
  final double latitude;
  final double longitude;
  final String destination;
  final String statut;
  final String affluence;
  final BitmapDescriptor color;

  VehicleInfo(this.id, this.route, this.latitude, this.longitude, this.destination, this.color, this.statut, this.affluence);
}


//Utilisée pour enlever le 0 devant le  numéro de ligne au sein du flux GTFS
String strip(String str, String charactersToRemove){
  String escapedChars = RegExp.escape(charactersToRemove);
  RegExp regex = new RegExp(r"^["+escapedChars+r"]+|["+escapedChars+r']+$');
  String newStr = str.replaceAll(regex, '').trim();
  return newStr;
}

// On récupère la destination à partir de l'ID de chaque véhicule du flux
String? getRouteLongNameFromId(String routeId, List<dynamic> csvList) {

  String destination = "";
  String toRemove = "0";
  String routeIdSans0 = strip(routeId, toRemove);
  // Parcourir chaque ligne du CSV
  for (List<dynamic> row in csvList) {
    // Vérifier si l'ID de la route correspond
    if (routeIdSans0 == row[0].toString()) {
      destination = row[3].split("-")[1].trim();
      // Retourner la valeur de la colonne route_long_name
      return destination;
    }
  }
  // Si l'ID de la route n'est pas trouvé, retourner null ou une valeur par défaut
  return "INCONNU";
}


//Récupération du statut du véhicule (prochain arrêt)
Future<String> getStatut(String statut, String stopId) async {
  String enRoute = "IN_TRANSIT_TO";
  String arret = "STOPPED_AT";
  String arrive = "INCOMING_AT";
  final csvList = await _loadCSV("assets/stopsCotentin.csv");
  if(statut == enRoute) {
    statut = "en route vers l'arrêt ";
  }

  else if (statut == arret) {
    statut = "stoppé à l'arrêt ";
  }

  else if(statut == arrive) {
    statut = "arrive à l'arrêt ";
  }

  for (List<dynamic> row in csvList) {
    if (stopId == row[0].toString()) {
      statut = statut + row[2].toString();
    }
  }
  return statut;
}


//Simulation d'affluence
String selectRandom(List items) {
  final random = Random();
  final index = random.nextInt(items.length);
  return items[index];
}


//On atribue une couleur à chaque marqueur de véhicule une couleur en fonction de sa ligne
Future<BitmapDescriptor> getColor(String routeId) async {

  switch(routeId){

    case "01" :
      final icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(1,1),
          ),
          "assets/images/bus_marker_01.png"
      );
      return  icon;
    case "02" :
      final icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(1,1),
          ),
          "assets/images/bus_marker_02.png"
      );
      return  icon;
    case "03" :
      final icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(1,1),
          ),
          "assets/images/bus_marker_03.png"
      );
      return  icon;
    case "04" :
      final icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(1,1),
          ),
          "assets/images/bus_marker_04.png"
      );
      return  icon;
    case "05" :
      final icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(1,1),
          ),
          "assets/images/bus_marker_05.png"
      );
      return  icon;
    case "06" :
      final icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(1,1),
          ),
          "assets/images/bus_marker_06.png"
      );
      return  icon;

    default :
      final icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(1,1),
          ),
          "assets/images/bus_marker.png"
      );
      return  icon;

  }

}


//Chargement d'un fichier CSV
Future<List<List>> _loadCSV(String csvPath) async {
  final _rawData = await rootBundle.loadString(csvPath);
  final list = await CsvToListConverter().convert(_rawData);

  return list;
}



//Connection à l'API et récupération des infos du flux
Future<List<VehicleInfo>> getData() async {
  final routeCsv = await _loadCSV("assets/routesCotentin.csv");


  //Lien de l'API parsé
  final url = Uri.parse(
      'https://pysae.com/api/v2/groups/transdev-cotentin/gtfs-rt');
  final response = await http.get(url);
  final feedMessage = FeedMessage.fromBuffer(response.bodyBytes);

  final vehicleInfos = <VehicleInfo>[];

  final affluences = ["nulle", "faible","moyenne", "forte", "très forte"];


  for (var entity in feedMessage.entity) {
    final vehiclePosition = entity.vehicle?.position;
    final vehicleId = entity.vehicle?.vehicle?.id;
    final routeId = entity.vehicle?.trip?.routeId;
    final affluence = selectRandom(affluences);

    final color = await getColor(routeId!);
    if (vehiclePosition != null && vehicleId != null) {
      final latitude = vehiclePosition.latitude;
      final longitude = vehiclePosition.longitude;
      final destination = getRouteLongNameFromId(entity.vehicle.trip.routeId, routeCsv);
      final statut =  await getStatut((entity.vehicle.currentStatus).toString(), entity.vehicle.stopId);

      final vehicleInfo = VehicleInfo(
          vehicleId, routeId!, latitude, longitude, destination!, color, statut, affluence);
      vehicleInfos.add(vehicleInfo);
    }
  }

  /*for (var vehicleInfo in vehicleInfos) {
    print('Vehicle ${vehicleInfo.id} (trip ${vehicleInfo.route}): (${vehicleInfo.latitude}, ${vehicleInfo.longitude})');
  }

*/
  return vehicleInfos;

}
