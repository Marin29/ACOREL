import 'package:apli1/pages/lignes_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../src/gtfs.dart';
import 'map_page.dart';

//import 'lignes_page.dart';



void main(){
  runApp(const MaterialApp(home : Home(), debugShowCheckedModeBanner: false,
  ));
  getData();



}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo_acomoove.jpeg"),
            Container(
              margin: EdgeInsets.all(20),
              child: const Text(
                "L'affluence en temps réel",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Poppins'

                ),
                textAlign: TextAlign.center,
              ),
            ),

               Container(
                 margin: EdgeInsets.all(20),
                 child : Text("Gaëlle, Audrey, Nadir et Marin sont heureux de vous présenter leur application réalisée dans le cadre de leur PPE en partenariat avec Acorel ! Grâce à cette application vous pourrez connaître la position de vos transports en commun ainsi que leurs taux d'occupation ",
              style:
              TextStyle(
                  fontSize: 16
              ),
              textAlign: TextAlign.justify,
            ),
            ),
            const Padding(padding: EdgeInsets.only(top: 45)),
            ElevatedButton.icon(
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                    backgroundColor: MaterialStatePropertyAll(Colors.red)
                ),
                onPressed: ()=> {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_,__,___) => MyApp()
                      )
                  )
                },
                label: const Text(
                  "Lancer l'application",
                  style:
                  TextStyle(
                      fontSize: 15
                  ),
                ),
                icon: Icon(Icons.play_arrow)
            )
          ],
        )
      )
    );
  }
}
