/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _posLille = CameraPosition(
    target: LatLng(50.633331, 3.0600),
    zoom: 13.5,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _posLille,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Recenter'),
        icon: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_posLille));
  }
}
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:apli1/src/locations.dart' as locations;
import 'package:apli1/src/gtfs.dart' as gtfs;

import '../main.dart';



class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {





  final Map<String, Marker> _markers = {};

  //Au moment de l'initialisation, on récupère la data de l'API
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final vehiclesInfo = await gtfs.getData();
    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            size: Size(1,1),
        ),
        "assets/images/bus_marker.png"
    );

    



    setState(() {


      _markers.clear();

      for (final vehicle in vehiclesInfo) {

        //Marqueur placé à la position de chaque véhicule
        final marker = Marker(
          markerId: MarkerId(vehicle.id),
          position: LatLng(vehicle.latitude, vehicle.longitude),

          //Pop up qui s'affiche en cliquant sur un marqueur
          infoWindow: InfoWindow(
            title: "Destination : ${vehicle.destination} | Affluence : ${vehicle.affluence}",
            snippet : "Ligne : ${vehicle.route} | Statut :  ${vehicle.statut}",

          ),
          icon: vehicle.color,

        );
        _markers[vehicle.id] = marker;
      }

    }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(


        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(

            //Centré sur la région du Cap du Cotentin
            target: LatLng(49.63362121582031, -1.6171009540557861),
            zoom: 13.5,
          ),
          markers: _markers.values.toSet(),

        ),

    //Pour actualiser on appelle simplement la page
    floatingActionButton: FloatingActionButton.extended(
        backgroundColor : Colors.red,
        onPressed: ()=> {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_,__,___) => MyApp()
            )
        )
      },


    label: const Text('Actualiser'),
    icon: const Icon(Icons.refresh),

    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );

  }

}
