import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final String title, description;

  const Description({Key? key, required this.title, required this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(description);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      appBar: AppBar(
        title: Text('Description'),
        backgroundColor: Color.fromARGB(255, 0, 9, 16),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(title,
                  selectionColor: Colors.white,
                  style: TextStyle(color: Colors.white)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(description,
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
