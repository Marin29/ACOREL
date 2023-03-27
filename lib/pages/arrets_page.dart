
import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:apli1/src/gtfs.dart';
import 'package:flutter/services.dart';

import 'add_page.dart';
import 'lignes_page.dart';
import 'map_page.dart';


//import 'package:apli1/pages/lignes_page.dart' as lignesPage;



void getSelection (String selection){


  setState(){};
}



class ArretsPage extends StatefulWidget {


  final String direction;
  final String arret;
  final String ligne;
  ArretsPage({required this.direction, required this.arret, required this.ligne});


  @override

  State<ArretsPage> createState() => ArretsPageState();

}

//blabladjzgdkhgezj

class ArretsPageState extends State<ArretsPage> {

  late String direction;
  late String arret;
  late String ligne;

  @override
  void initState() {
    super.initState();
    direction = widget.direction;
    arret = widget.arret;
    ligne = widget.ligne;
  }

  @override

Widget build(BuildContext context) {



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
                    trailing: Text("$arret"),
                  )

              )
          );
        },
    ),
    ),
    );
  }
}


