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
  final BitmapDescriptor color;

  VehicleInfo(this.id, this.route, this.latitude, this.longitude, this.destination, this.color);
}

String strip(String str, String charactersToRemove){
  String escapedChars = RegExp.escape(charactersToRemove);
  RegExp regex = new RegExp(r"^["+escapedChars+r"]+|["+escapedChars+r']+$');
  String newStr = str.replaceAll(regex, '').trim();
  return newStr;
}

String? getRouteLongNameFromId(String routeId, List<dynamic> csvList) {

  String toRemove = "0";
  String routeIdSans0 = strip(routeId, toRemove);
  // Parcourir chaque ligne du CSV
  for (List<dynamic> row in csvList) {
    //print (row);
    // Vérifier si l'ID de la route correspond
    if (routeIdSans0.toString() == row[0].toString()) {
      // Retourner la valeur de la colonne route_long_name
      return row[3];
    }
  }
  // Si l'ID de la route n'est pas trouvé, retourner null ou une valeur par défaut
  return "INCONNU";
}



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
    /* case "A" :
      break;
    case "B" :
      break;
    case "C" :
      break;
    case "D" :
      break;
    case "E" :
      break;
    case "F" :
      break;
    case "G" :
      break;
*/
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

Future<List<List>> _loadCSV(String csvPath) async {
  final _rawData = await rootBundle.loadString(csvPath);
  final list = await CsvToListConverter().convert(_rawData);

  return list;
}

Future<List<VehicleInfo>> getData() async {
  final routeCsv = await _loadCSV("assets/routesCotentin.csv");


  final url = Uri.parse(
      'https://pysae.com/api/v2/groups/transdev-cotentin/gtfs-rt');
  final response = await http.get(url);
  final feedMessage = FeedMessage.fromBuffer(response.bodyBytes);

  final vehicleInfos = <VehicleInfo>[];


  //print(feedMessage.entity.toString());

  for (var entity in feedMessage.entity) {
    final vehiclePosition = entity.vehicle?.position;
    final vehicleId = entity.vehicle?.vehicle?.id;
    final routeId = entity.vehicle?.trip?.routeId;

    final color = await getColor(routeId!);
    if (vehiclePosition != null && vehicleId != null) {
      final latitude = vehiclePosition.latitude;
      final longitude = vehiclePosition.longitude;
      final destination = getRouteLongNameFromId(routeId!, routeCsv);
      //print(destination);

      final vehicleInfo = VehicleInfo(
          vehicleId, routeId!, latitude, longitude, destination!, color);
      vehicleInfos.add(vehicleInfo);
    }
  }

  /*for (var vehicleInfo in vehicleInfos) {
    print('Vehicle ${vehicleInfo.id} (trip ${vehicleInfo.route}): (${vehicleInfo.latitude}, ${vehicleInfo.longitude})');
  }

*/
  return vehicleInfos;

  //test
}
