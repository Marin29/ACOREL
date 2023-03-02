import 'package:flutter/material.dart';

//import 'lignes_page.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
            const Text("Grâce à cette application vous pourrez connaître la position de vos transports en commun ainsi que leur taux d'occupation ",
              style:
              TextStyle(
                  fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.only(top: 45)),
            /*ElevatedButton.icon(
                style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                    backgroundColor: MaterialStatePropertyAll(Colors.green)
                ),
                onPressed: ()=> {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_,__,___) => LignesPage()
                      )
                  )
                },
                label: const Text(
                  "Afficher les lignes",
                  style:
                  TextStyle(
                      fontSize: 15
                  ),
                ),
                icon: Icon(Icons.accessibility_new_outlined)
            )*/
          ],
        )
    );
  }
}