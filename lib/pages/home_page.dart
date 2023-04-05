import 'package:flutter/material.dart';
import '../main.dart';
import '../src/gtfs.dart';


/*void main(){
  runApp(const MaterialApp(home : Home(), debugShowCheckedModeBanner: false,
  ));
  getData();
}*///On run l'application depuis la home page pour avoir la page d'accueil mais elle pourrait très bien être run depuis le main pour arriver sur les lignes directement

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
            Image.asset("assets/images/logo_acomoove.jpeg"),//logo de l'entreprise acomoove, il peut être modifié en rajoutant une image dans le fichier image dans asset
            Container(
              margin: EdgeInsets.all(20),
              child: const Text(
                "RIFT",
                style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Poppins'//police utilisée, pour la changer il faut modifier le pubspec.yaml et ajouter une police dans le fichier fonts dans assets

                ),
                textAlign: TextAlign.center,
              ),
            ),

               Container(
                 margin: EdgeInsets.all(20),
                 child : Text("Gaëlle, Audrey, Nadir et Marin sont heureux de "
                     "vous présenter un prototype d'application réalisé dans le cadre de leur projet étudiant"
                     " de quatrième année, en partenariat avec Acorel !",
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
                          pageBuilder: (_,__,___) => MyApp()//renvoie au main
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
