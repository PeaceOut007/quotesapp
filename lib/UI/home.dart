import 'package:flutter/material.dart';

class Quotes extends StatefulWidget {
  @override
  _QuotesState createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  int i=0;
  List quotes=[
    "The purpose of our lives is to be happy.",
    "Get busy living or get busy dying",
    "YOLO, but if you do it right, once is enough.",
    "Never let the fear of striking out keep you from playing the game.",
    "In order to write about life first you must live it.",
    "You get what you fucking deserve"
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quotes4u"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.file_copy_outlined),
        onPressed: () => debugPrint("Yo"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 350,
                height: 250,
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: Text(quotes[i % quotes.length],
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
                )
                )),
            Divider(
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: FlatButton.icon(
                  onPressed: _showQuote,
                  color: Colors.greenAccent.shade700,
                  icon: Icon(Icons.wb_sunny, color: Colors.white,),
                  label: Text("Next Quote",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _showQuote() {
    setState(() {
      i++;
    });
  }
}
