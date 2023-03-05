import 'package:apli1/pages/add_page.dart';
import 'package:apli1/pages/home_page.dart';
import 'package:apli1/pages/lignes_page.dart';
import 'package:flutter/material.dart';
import 'package:apli1/pages/map_page.dart';
import 'package:apli1/src/gtfs.dart';


void main(){
  runApp(const MyApp());
  getData();

  
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  setCurrentIndex(int index){
    setState(() {
      _currentIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const [
            Text("Acorel"),
            Text("Lignes"),
            Text("Carte"),
            Text("Ajouter une ligne")
          ][_currentIndex]
        ),
        body: const  [
          Home(),
          LignesPage(),
          MyAp(),
          Add()

          
        ][_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index)=>setCurrentIndex(index),
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          iconSize: 40,
          elevation: 15,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.train),
                label: 'Lignes'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
              label: 'Carte'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Ajouter'
            )
          ],
        ),
      ),
    );
  }
}
/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: Map(),
    );
  }
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}*/







