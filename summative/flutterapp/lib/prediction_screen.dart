import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result_screen.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController attendanceController = TextEditingController();
  TextEditingController midtermScoreController = TextEditingController();
  TextEditingController finalScoreController = TextEditingController();
  TextEditingController assignmentsAvgController = TextEditingController();
  TextEditingController quizzesAvgController = TextEditingController();
  TextEditingController participationScoreController = TextEditingController();
  TextEditingController projectsScoreController = TextEditingController();
  TextEditingController studyHoursController = TextEditingController();
  TextEditingController stressLevelController = TextEditingController();
  TextEditingController sleepHoursController = TextEditingController();

  Future<void> makePrediction() async {
    final url = 'http://0.0.0.0:8000/predict'; // Replace with actual API URL

    Map<String, dynamic> requestBody = {
      'Attendance (%)': double.parse(attendanceController.text),
      'Midterm_Score': double.parse(midtermScoreController.text),
      'Final_Score': double.parse(finalScoreController.text),
      'Assignments_Avg': double.parse(assignmentsAvgController.text),
      'Quizzes_Avg': double.parse(quizzesAvgController.text),
      'Participation_Score': double.parse(participationScoreController.text),
      'Projects_Score': double.parse(projectsScoreController.text),
      'Study_Hours_per_Week': double.parse(studyHoursController.text),
      'Stress_Level (1-10)': double.parse(stressLevelController.text),
      'Sleep_Hours_per_Night': double.parse(sleepHoursController.text),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        String prediction = json.decode(response.body)['prediction'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(prediction: prediction),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Unable to get prediction")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Make Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              textField(attendanceController, 'Attendance (%)'),
              textField(midtermScoreController, 'Midterm Score'),
              textField(finalScoreController, 'Final Score'),
              textField(assignmentsAvgController, 'Assignments Avg'),
              textField(quizzesAvgController, 'Quizzes Avg'),
              textField(participationScoreController, 'Participation Score'),
              textField(projectsScoreController, 'Projects Score'),
              textField(studyHoursController, 'Study Hours per Week'),
              textField(stressLevelController, 'Stress Level (1-10)'),
              textField(sleepHoursController, 'Sleep Hours per Night'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: makePrediction,
                child: Text('Predict'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }
}