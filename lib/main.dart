import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:ricketmortyapi/model/Personnage.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List <Personnage> listePersonnage=[];
  late var jsonResponse;
  String apiAdresse = "https://rickandmortyapi.com/api/character";






  Future init(String adresse) async {
    Uri url = Uri.parse(adresse);
    Response reponseAdresse = await http.get(url);
    jsonResponse = convert.jsonDecode(reponseAdresse.body) as Map<String,dynamic>;
    int index = 0;

      while (index<jsonResponse["results"].length)
        {
          setState(() {
            Personnage perso = Personnage.json(jsonResponse["results"][index] as Map<String,dynamic>);
            listePersonnage.add(perso);
          });

          index++;
        }

        if(jsonResponse["info"]["next"]!= null){
          init(jsonResponse["info"]["next"]);
        }
    }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init(apiAdresse);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Api Rick et Morty"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GridView.builder(
            itemCount: listePersonnage.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 10),
            itemBuilder: (context,index){
              return Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(listePersonnage[index].image)
                      )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(listePersonnage[index].name)
                ],
              );

            }
        )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
