import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gtfs_realtime_bindings/gtfs_realtime_bindings.dart';


Future<String> getData() async {
  final url = Uri.parse('https://proxy.transport.data.gouv.fr/resource/ilevia-lille-gtfs-rt');
  final response = await http.get(url);

  final feedMessage = FeedMessage.fromBuffer(response.bodyBytes);

  print(feedMessage.entity.toString());

  return feedMessage.entity.toString();

}