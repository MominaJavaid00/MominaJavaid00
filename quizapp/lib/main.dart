import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the image on the start screen
            Image.asset(
              'assets/1.png',
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int score = 0;

  List<Map<String, Object>> questions = [
    {
      'question': 'What is Flutter?',
      'answers': ['SDK', 'Language', 'Framework', 'IDE'],
      'correct': 0,
    },
    {
      'question': 'Who developed Flutter?',
      'answers': ['Facebook', 'Adobe', 'Google', 'Microsoft'],
      'correct': 2,
    },
    {
      'question': 'What language is used by Flutter?',
      'answers': ['Java', 'Kotlin', 'Dart', 'Swift'],
      'correct': 2,
    },
  ];

  void answerQuestion(int selectedAnswer) {
    if (selectedAnswer == questions[questionIndex]['correct']) {
      score++;
    }

    setState(() {
      questionIndex++;
    });

    if (questionIndex >= questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: score, total: questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: questionIndex < questions.length
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the question number as a heading
          Text(
            'Question ${questionIndex + 1}',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 20),
          // Display the actual question text in large font
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              questions[questionIndex]['question'] as String,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center, // Center the question
            ),
          ),
          SizedBox(height: 20),
          ...(questions[questionIndex]['answers'] as List<String>).map((answer) {
            int index = (questions[questionIndex]['answers'] as List<String>).indexOf(answer);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () => answerQuestion(index),
                child: Text(answer, style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  minimumSize: Size(double.infinity, 50), // Make buttons full-width
                ),
              ),
            );
          }).toList(),
        ],
      )
          : Center(child: Text('No more questions')),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  ResultScreen({required this.score, required this.total});

  String get resultMessage {
    double percentage = (score / total) * 100;
    if (percentage > 80) {
      return 'Excellent';
    } else if (percentage > 50) {
      return 'Good';
    } else {
      return 'Better Luck Next Time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score/$total', style: TextStyle(fontSize: 24)),
            Text(resultMessage, style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                );
              },
              child: Text('Restart Quiz', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
