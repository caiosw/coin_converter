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
      hintColor: Colors.black,
      primaryColor: Colors.green,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        hintStyle: TextStyle(color: Colors.black)
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

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {

  }

  void _dollarChanged(String text) {

  }

  void _euroChanged(String text) {

  }

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
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 100.0,
                        color: Colors.green,
                      ),
                      Divider(),
                      buildTextField(
                        "BRL (Brazilian Real)",
                        "R\$",
                        realController,
                        _realChanged
                      ),
                      Divider(),
                      buildTextField(
                        "USD (American Dollar)",
                        "U\$",
                        dollarController,
                        _dollarChanged
                      ),
                      Divider(),
                      buildTextField(
                        "EUR (Euro)",
                        "€",
                        euroController,
                        _euroChanged
                      ),
                    ],
                  ),
                )
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

buildTextField(
  String label,
  String prefix,
  TextEditingController controller,
  Function function
) {
  return TextFormField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green),
        border: OutlineInputBorder(),
        prefixText: prefix,
    ),
    controller: controller,
    onChanged: function,
    keyboardType: TextInputType.number,
  );
}