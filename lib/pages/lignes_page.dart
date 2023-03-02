import'package:flutter/material.dart';

class LignesPage extends StatefulWidget {
  const LignesPage({Key? key}) : super(key: key);

  @override
  State<LignesPage> createState() => _LignesPageState();
}

class _LignesPageState extends State<LignesPage> {

  final events =[
    {
      "intitule": "Métro 1",
      "type": "metro",
      "logo": "M1.jpg"
    },
    {
      "intitule": "Métro 2",
      "type": "metro",
      "logo": "M2.png"
    },
    {
      "intitule": "Tramway R",
      "type": "tram",
      "logo": "TR.jpg"
    },
    {
      "intitule": "Tramway T",
      "type": "tram",
      "logo": "TT.jpg"
    }

  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index){
          final event = events[index];
          final logo = event['logo'];
          final intitule = event['intitule'];
          final type = event['type'];

          return Card(
              child: ListTile(
                leading: Image.asset("assets/images/$logo"),
                title: Text("$intitule"),
                subtitle: Text("$type"),
                trailing: const Icon(Icons.more_vert),
              )
          );
        },

      ),
    );
  }
}
