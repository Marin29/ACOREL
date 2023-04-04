import 'package:apli1/pages/lignes_page.dart';
import 'package:flutter/material.dart';
import 'package:apli1/pages/map_page.dart';
import 'package:apli1/src/gtfs.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';


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

        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index)=>setCurrentIndex(index),
          selectedColor: Colors.red,
          unSelectedColor: Colors.black,
          iconSize: 38,
          elevation: 15,
          isFloating: false,
          bubbleCurve: Curves.bounceIn,
          scaleCurve: Curves.bounceInOut,
          strokeColor: Colors.red,
          items: [

            CustomNavigationBarItem(
                icon: Icon(Icons.train),
                title: Text('Arrêts')
            ),
            CustomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Carte')
            ),
          ],
        ),
      ),

    );
  }
}








