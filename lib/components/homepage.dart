import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget    {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('BoardEase'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
      ),
      body: content(),
    );
}

 Widget content(){
    return Column(
      children: [
        Padding(
        padding: EdgeInsets.fromLTRB(135.0, 50.0, 30.0, 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
                "15/15",
                style: TextStyle(
                color: Colors.indigoAccent,
                fontWeight: FontWeight.bold,
                fontSize: 50.0
                ),
             ),
            ],
          )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
          //margin: EdgeInsets.all(10.0),
          color: Colors.cyan,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Text(
                    "Name:"
                ),
                SizedBox(height: 0),
                Text(
                    "Payed"
                ),
              ]
          ),
        ),
      ]
    );
  }
}