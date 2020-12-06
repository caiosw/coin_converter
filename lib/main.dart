import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=2c275b03";
// key with limited requests per day

void main() async {
  //print(["results"]["currencies"]);

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.green,
      primaryColor: Colors.black,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintStyle: TextStyle(color: Colors.green)
      )
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dollar;
  double euro;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("\$ Coin Converter"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 25.0
                  ),
                )
              );
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                      "Error getting data :(",
                      style: TextStyle(
                          fontSize: 25.0
                      ),
                    )
                );
              }

              dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

              return SingleChildScrollView(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 100.0,
                      color: Colors.green,
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "BRL (Brazilian Real)",
                        labelStyle: TextStyle(color: Colors.green),
                        border: OutlineInputBorder(),
                        prefixText: "R\$"
                      ),
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "USD (American Dollar)",
                          labelStyle: TextStyle(color: Colors.green),
                          border: OutlineInputBorder(),
                          prefixText: "U\$"
                      ),
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "EUR (Euro)",
                          labelStyle: TextStyle(color: Colors.green),
                          border: OutlineInputBorder(),
                          prefixText: "€"
                      ),
                    ),
                  ],
                ),
              );


          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}