
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
Boup.add("faible");
List Ordre = ["Prochain", "Suivant", "Puis"];

return MaterialApp(
    home :  Scaffold(

    body : Column(

        children: [

          Padding(
    padding: const EdgeInsets.only(top: 45),
      child: Text(
        'Arrêt ${arret.toLowerCase()} direction $direction',
        style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        textAlign: TextAlign.center,

      ),
    ),
    Expanded(
    child: ListView.builder(

        itemCount: 3,

        itemBuilder: (context, index){

          String affluenceListe = Boup[index];

          Widget image;
          switch(affluenceListe){

            case 'nulle':
              image  = Image.asset("assets/images/tres_faible.png");
              break;
            case 'faible':
              image  = Image.asset("assets/images/faible.png");
              break;
            case 'moyenne':
              image  = Image.asset("assets/images/moyenne.png");
              break;
            case 'forte':
              image  = Image.asset("assets/images/forte.png");
              break;
            case 'très forte':
              image  = Image.asset("assets/images/tres_forte.png");
              break;
              default:
                image  = Image.asset("assets/images/moyenne.png");

          }

              return Card(
                  child: ListTile(
                    title : Text("${Ordre[index]}"),
                    subtitle: Text("2 minutes"),
                    trailing: image,
                  )

              );
        },
    ),
    ),
        ],

    ),
    ),
    );

  }
}


