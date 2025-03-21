import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers to capture user input
  TextEditingController attendanceController = TextEditingController();
  TextEditingController midtermScoreController = TextEditingController();
  TextEditingController assignmentsAvgController = TextEditingController();
  TextEditingController quizzesAvgController = TextEditingController();
  TextEditingController participationScoreController = TextEditingController();
  TextEditingController projectsScoreController = TextEditingController();
  TextEditingController studyHoursController = TextEditingController();
  TextEditingController stressLevelController = TextEditingController();
  TextEditingController sleepHoursController = TextEditingController();

  String? predictionResult = "";

  // Function to make the API call
  Future<void> makePrediction() async {
    final url = 'http://<your-api-endpoint>/path_to_predict'; // Replace with actual API URL

    // Prepare the data for the prediction
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
        setState(() {
          predictionResult = "Prediction: ${json.decode(response.body)['prediction']}";
        });
      } else {
        setState(() {
          predictionResult = "Error: Unable to get prediction";
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: attendanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Attendance (%)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter attendance';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: midtermScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Midterm Score'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter midterm score';
                  }
                  return null;
                },
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    makePrediction();
                  }
                },
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              Text(
                predictionResult ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
