
import 'package:apli1/pages/arrets_page.dart';
import 'package:apli1/pages/home_page.dart';
import 'package:apli1/pages/lignes_page.dart';
import 'package:flutter/material.dart';
import 'package:apli1/pages/map_page.dart';
import 'package:apli1/src/gtfs.dart';


void main(){
  runApp(const MaterialApp(home : MyApp(), debugShowCheckedModeBanner: false,
  ));
  getData();


  
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1;

  setCurrentIndex(int index){
    setState(() {
      _currentIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(

        body:
        const  [
          SearchPage(),
          MapPage(),

        ][_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index)=>setCurrentIndex(index),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black,
          iconSize: 40,
          elevation: 15,
          items: const [

            BottomNavigationBarItem(
                icon: Icon(Icons.train),
                label: 'Arrêts'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
              label: 'Carte'
            ),
          ],
        ),
      ),

    );
  }
}








