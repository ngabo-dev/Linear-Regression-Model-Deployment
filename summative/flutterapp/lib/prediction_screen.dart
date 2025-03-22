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
      'attendance': double.parse(attendanceController.text),
      'midterm_score': int.parse(midtermScoreController.text),
      'assignments_avg': int.parse(assignmentsAvgController.text),
      'quizzes_avg': int.parse(quizzesAvgController.text),
      'participation_score': int.parse(participationScoreController.text),
      'projects_score': int.parse(projectsScoreController.text),
      'study_hours': int.parse(studyHoursController.text),
      'stress_level': int.parse(stressLevelController.text),
      'sleep_hours': double.parse(sleepHoursController.text),
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
              TextFormField(
                controller: attendanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Attendance (%)'),
              ),
              TextFormField(
                controller: midtermScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Midterm Score'),
              ),
              TextFormField(
                controller: assignmentsAvgController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Assignments Avg'),
              ),
              TextFormField(
                controller: quizzesAvgController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quizzes Avg'),
              ),
              TextFormField(
                controller: participationScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Participation Score'),
              ),
              TextFormField(
                controller: projectsScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Projects Score'),
              ),
              TextFormField(
                controller: studyHoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Study Hours per Week'),
              ),
              TextFormField(
                controller: stressLevelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stress Level'),
              ),
              TextFormField(
                controller: sleepHoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Sleep Hours per Night'),
              ),
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
}
