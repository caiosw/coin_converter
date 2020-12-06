import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=2c275b03";
// key with limited requests per day

void main() async {


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
  double bitcoin;

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  void _clearAllTextFields() {
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
    bitcoinController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAllTextFields();
      return;
    }

    double real = double.parse(text);
    dollarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoin).toStringAsFixed(10);
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAllTextFields();
      return;
    }

    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
    bitcoinController.text = (dollar * this.dollar / bitcoin)
        .toStringAsFixed(10);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAllTextFields();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro / bitcoin)
        .toStringAsFixed(10);
  }

  void _bitcoinChanged(String text) {
    if (text.isEmpty) {
      _clearAllTextFields();
      return;
    }

    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dollarController.text = (bitcoin * this.bitcoin / dollar)
        .toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin / euro)
        .toStringAsFixed(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Icon(
          Icons.monetization_on,
          color: Colors.white,
        ),
        title: Text("Coin Converter"),

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
              bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];

              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(height: 5.0,),
                      buildTextField(
                        "BRL (Brazilian Real)",
                        "R\$ ",
                        realController,
                        _realChanged
                      ),
                      Divider(),
                      buildTextField(
                        "USD (American Dollar)",
                        "U\$ ",
                        dollarController,
                        _dollarChanged
                      ),
                      Divider(),
                      buildTextField(
                        "EUR (Euro)",
                        "€ ",
                        euroController,
                        _euroChanged
                      ),
                      Divider(),
                      buildTextField(
                          "BTC (Bitcoin)",
                          "BTC ",
                          bitcoinController,
                          _bitcoinChanged
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
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}