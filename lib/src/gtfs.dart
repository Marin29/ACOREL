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

  VehicleInfo(this.id, this.route, this.latitude, this.longitude);
}



Future<String> getData() async {
  final url = Uri.parse('https://pysae.com/api/v2/groups/transdev-cotentin/gtfs-rt');
  final response = await http.get(url);
  final feedMessage = FeedMessage.fromBuffer(response.bodyBytes);

  //print(feedMessage.entity.toString());

  for (var entity in feedMessage.entity) {
    final vehiclePosition = entity.vehicle?.position;
    final vehicleId = entity.vehicle?.vehicle?.id;
    final routeId = entity.vehicle?.trip?.routeId;
    if (vehiclePosition != null && vehicleId != null) {
      final latitude = vehiclePosition.latitude;
      final longitude = vehiclePosition.longitude;

      print('(trip $routeId): ($latitude, $longitude)');
    }
  }



  return feedMessage.entity.toString();

  //test

}
void _loadCSVStops() async {
  final _rawData = await rootBundle.loadString("assets/arrets.csv");
  const CsvToListConverter().convert(_rawData);

}