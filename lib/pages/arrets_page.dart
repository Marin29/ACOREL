
import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:apli1/src/gtfs.dart' as gtfs;

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
  List vehiculeInfos = [];

  @override
  void initState() {
    getGTFS();
    super.initState();
    direction = widget.direction;
    arret = widget.arret;
    ligne = widget.ligne;
  }

  void getGTFS() async {
    vehiculeInfos = await gtfs.getData();

    /*for(final vehicle in vehiculeInfos){
      print (vehicle.affluence + " " + vehicle.statut);
    }*/
    setState(() {

    });
  }

  List getAffluence(List vehicleInfos, String direction, String arret){
    List affluence = ["Boup"];
    for (final vehicle in vehicleInfos){
      print(vehicle.destination);
      print (vehicle.statut);
      if((vehicle.statut).toString().toLowerCase().contains(arret.toLowerCase())
      || (vehicle.destination).toString().toLowerCase().contains(direction.toString().toLowerCase())){
        affluence.add(vehicle.affluence);
      }

    }
    print(affluence);
    return affluence;
  }

  @override

Widget build(BuildContext context) {

List Boup = getAffluence(vehiculeInfos, direction, arret);

return MaterialApp(
    home :  Scaffold(

    body : ListView.builder(

        itemCount: 2,
        itemBuilder: (context, index){

          return GestureDetector(
              //onTap: () => ,
              child : Card(
                  child: ListTile(
                    title: Text("$direction"),
                    trailing: Text("${Boup[1]}"),
                  )

              )
          );
        },
    ),
    ),
    );
  }
}


