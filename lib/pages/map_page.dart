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




class MyAp extends StatefulWidget {
  const MyAp({Key? key}) : super(key: key);

  @override
  _MyApState createState() => _MyApState();
}

class _MyApState extends State<MyAp> {



  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            size: Size(1,1),
        ),
        "assets/images/images.png"

    );



    setState(() {
      _markers.clear();

      for (final office in googleOffices.offices) {

        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,


          ),
          icon: icon,

        );
        _markers[office.name] = marker;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(49.63362121582031, -1.6171009540557861),
            zoom: 13.5,
          ),
          markers: _markers.values.toSet(),

        ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: ()=> {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_,__,___) => MyAp()
            )
        )
      },
    label: const Text('Recenter'),
    icon: const Icon(Icons.center_focus_strong),
      )
    );

  }

}
