import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gtfs_realtime_bindings/gtfs_realtime_bindings.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:protobuf/protobuf.dart';




Future<String> getData() async {
  final url = Uri.parse('https://pysae.com/api/v2/groups/transdev-cotentin/gtfs-rt');
  final response = await http.get(url);

  final feedMessage = FeedMessage.fromBuffer(response.bodyBytes);

  //print(feedMessage.entity.toString());

  final vehiclePosition = feedMessage.entity
      .map((e) => e.vehicle)
      .where((vp) => vp != null)
      .firstWhere((vp) => vp.vehicle.id == '61289ff756b38782f6019835');

  if (vehiclePosition != null) {
    final position = vehiclePosition.position;
    final latitude = position.latitude;
    final longitude = position.longitude;

    print('Latitude: $latitude');
    print('Longitude: $longitude');

  }



  return feedMessage.entity.toString();

  //test

}


void _loadCSVStops() async {
  final _rawData = await rootBundle.loadString("assets/arrets.csv");
  const CsvToListConverter().convert(_rawData);

}