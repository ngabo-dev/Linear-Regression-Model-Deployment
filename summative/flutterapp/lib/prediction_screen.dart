import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result_screen.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({Key? key}) : super(key: key);

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController attendanceController = TextEditingController();
  final TextEditingController midtermScoreController = TextEditingController();
  final TextEditingController finalScoreController = TextEditingController();
  final TextEditingController assignmentsAvgController = TextEditingController();
  final TextEditingController quizzesAvgController = TextEditingController();
  final TextEditingController participationScoreController = TextEditingController();
  final TextEditingController projectsScoreController = TextEditingController();
  final TextEditingController studyHoursController = TextEditingController();
  final TextEditingController stressLevelController = TextEditingController();
  final TextEditingController sleepHoursController = TextEditingController();

  Future<void> makePrediction() async {
    const String url = 'https://linear-regression-model-1-ocmt.onrender.com/predict';

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      double attendance = double.parse(attendanceController.text);
      double midtermScore = double.parse(midtermScoreController.text);
      double finalScore = double.parse(finalScoreController.text);
      double assignmentsAvg = double.parse(assignmentsAvgController.text);
      double quizzesAvg = double.parse(quizzesAvgController.text);
      double participationScore = double.parse(participationScoreController.text);
      double projectsScore = double.parse(projectsScoreController.text);
      double studyHours = double.parse(studyHoursController.text);
      double stressLevel = double.parse(stressLevelController.text);
      double sleepHours = double.parse(sleepHoursController.text);

      double totalScore = (attendance + midtermScore + assignmentsAvg + quizzesAvg +
              participationScore + projectsScore + studyHours + stressLevel + sleepHours) /
          9;

      Map<String, dynamic> requestBody = {
        'attendance': attendance,
        'midterm_score': midtermScore,
        'assignments_avg': assignmentsAvg,
        'quizzes_avg': quizzesAvg,
        'participation_score': participationScore,
        'projects_score': projectsScore,
        'study_hours_per_week': studyHours,
        'stress_level': stressLevel,
        'sleep_hours_per_night': sleepHours,
        'final_score': finalScore,
        'total_score': totalScore,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        List<dynamic> predictionList = json.decode(response.body)['prediction'];
        String prediction = predictionList.isNotEmpty ? predictionList[0].toString() : "No prediction available";
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(prediction: prediction),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Unable to get prediction")),
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
      appBar: AppBar(
        title: const Text('Make Prediction', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFFF7E5F), // Orange-pink color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF7E5F), // Orange-pink
              Color(0xFF8E44AD),  // Purple
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField(attendanceController, 'Attendance (%)'),
              _buildTextField(midtermScoreController, 'Midterm Score'),
              _buildTextField(finalScoreController, 'Final Score'),
              _buildTextField(assignmentsAvgController, 'Assignments Avg'),
              _buildTextField(quizzesAvgController, 'Quizzes Avg'),
              _buildTextField(participationScoreController, 'Participation Score'),
              _buildTextField(projectsScoreController, 'Projects Score'),
              _buildTextField(studyHoursController, 'Study Hours per Week'),
              _buildTextField(stressLevelController, 'Stress Level (1-10)'),
              _buildTextField(sleepHoursController, 'Sleep Hours per Night'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: makePrediction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E44AD), // Purple color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Predict', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8E44AD), width: 2.0), // Purple focused border
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (double.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}