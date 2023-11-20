import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String displayedImage = 'images/background1.png';

  void changeImage(String imagePath) {
    setState(() {
      displayedImage = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[500],
      appBar: AppBar(
        title: Text('My Application'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(displayedImage),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    changeImage('images/img1.jpg');
                  },
                  child: Text('Image 1'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    changeImage('images/img2.png');
                  },
                  child: Text('Image 2'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
