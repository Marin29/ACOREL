import'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:apli1/src/gtfs.dart';
import 'package:flutter/services.dart';







class ArretsPage extends StatefulWidget {

  final arrets;

  ArretsPage({required this.arrets});


  @override
  State<ArretsPage> createState() => ArretsPageState();
}


class ArretsPageState extends State<ArretsPage> {

  get arrets => ArretsPageState().arrets;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(

        itemCount: ArretsPageState().arrets.length,
        itemBuilder: (context, index){
          final arret = arrets[index];
          final intitule = arret[index];

          return GestureDetector(
              //onTap: () => ,
              child : Card(
                  child: ListTile(
                    title: Text("$intitule"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  )

              )
          );
        },

      ),
    );
  }
}
