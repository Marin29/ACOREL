import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gtfs_realtime_bindings/gtfs_realtime_bindings.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';




Future<String> getData() async {
  final url = Uri.parse('https://proxy.transport.data.gouv.fr/resource/ilevia-lille-gtfs-rt');
  final response = await http.get(url);

  final feedMessage = FeedMessage.fromBuffer(response.bodyBytes);

  print(feedMessage.entity.toString());

  return feedMessage.entity.toString();

  //test

}


void _loadCSVStops() async {
  final _rawData = await rootBundle.loadString("assets/arrets.csv");
  const CsvToListConverter().convert(_rawData);

}