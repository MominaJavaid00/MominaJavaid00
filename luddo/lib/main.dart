import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(LudoApp());
}

class LudoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ludo Dice Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LudoGame(),
    );
  }
}

class LudoGame extends StatefulWidget {
  @override
  _LudoGameState createState() => _LudoGameState();
}

class _LudoGameState extends State<LudoGame> {
  int round = 1;
  int maxRounds = 4; // Changed from 3 to 4
  int currentPlayer = 0; // 0 -> Player 1, 1 -> Player 2, etc.
  List<int> scores = [0, 0, 0, 0]; // Scores for Player 1 to Player 4
  String gameStatus = "Player 1's turn!";
  bool gameOver = false;
  int diceRoll = 1; // Current dice roll

  // Function to roll the dice and update scores
  void rollDice() {
    if (gameOver) return;

    setState(() {
      // Randomly roll the dice (1 to 6)
      diceRoll = Random().nextInt(6) + 1;

      // Update the score of the current player
      scores[currentPlayer] += diceRoll;

      // Check if the current player rolled a 6
      if (diceRoll != 6) {
        // Move to the next player if they did not roll a 6
        currentPlayer = (currentPlayer + 1) % 4;

        // Update round only after player 4 finishes
        if (currentPlayer == 0) {
          round++;
        }
      }

      // Update the game status after each roll
      updateGameStatus();

      // Check if the game is over
      if (round > maxRounds) {
        gameOver = true;
        displayFinalWinner();
      }
    });
  }

  // Function to update the game status
  void updateGameStatus() {
    int maxScore = scores.reduce(max);
    List<int> leaders = [];

    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == maxScore) {
        leaders.add(i + 1);
      }
    }

    if (leaders.length == 1) {
      gameStatus = "Player ${leaders.first} is leading with $maxScore points!";
    } else {
      gameStatus = "Players ${leaders.join(', ')} are tied with $maxScore points!";
    }

    gameStatus += " Player ${currentPlayer + 1}'s turn!";
  }

  // Function to display the final winner in a dialog
  void displayFinalWinner() {
    int maxScore = scores.reduce(max);
    List<int> winners = [];

    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == maxScore) {
        winners.add(i + 1);
      }
    }

    String winnerMessage;
    if (winners.length == 1) {
      winnerMessage = "Player ${winners.first} wins with $maxScore points!";
    } else {
      winnerMessage = "It's a tie between players ${winners.join(', ')} with $maxScore points!";
    }

    // Show dialog with winner message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(winnerMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to restart the game
  void restartGame() {
    setState(() {
      round = 1;
      currentPlayer = 0;
      scores = [0, 0, 0, 0];
      gameStatus = "Player 1's turn!";
      gameOver = false;
      diceRoll = 1;
    });
  }

  // Get the appropriate dice image based on the roll
  String getDiceImage() {
    return 'assets/images/dice-$diceRoll.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ludo Dice Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Round $round / $maxRounds',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Player 1',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${scores[0]}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Player 2',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${scores[1]}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Player 3',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${scores[2]}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Player 4',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${scores[3]}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Image.asset(
              getDiceImage(), // Display the rolled dice image
              height: 150,
              width: 150,
            ),
            SizedBox(height: 30),
            if (!gameOver)
              ElevatedButton(
                onPressed: rollDice,
                child: Text('Roll Dice'),
              ),
            if (gameOver)
              ElevatedButton(
                onPressed: restartGame,
                child: Text('Restart Game'),
              ),
            SizedBox(height: 20),
            Text(
              gameStatus,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
