import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String prediction;

  const ResultScreen({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prediction Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Prediction Result",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              prediction,
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text("Go to Home"),
            ),
          ],
        ),
      ),
    );
  }
}