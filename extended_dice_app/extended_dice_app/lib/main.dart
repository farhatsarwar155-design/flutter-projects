import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DicePage(),
    );
  }
}

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage>
    with SingleTickerProviderStateMixin {
  int diceNumber = 1;
  String userGuess = '';
  String resultMessage = '';

  int correctGuesses = 0;
  int wrongGuesses = 0;
  int round = 0;
  int maxRounds = 10;

  String difficulty = "Medium"; // default

  final TextEditingController guessController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  void setDifficulty(String level) {
    setState(() {
      difficulty = level;
      if (level == "Easy") {
        maxRounds = 5;
      } else if (level == "Medium") {
        maxRounds = 10;
      } else {
        maxRounds = 15;
      }
      restartGame();
    });
  }

  void rollDice() {
    if (round >= maxRounds) return;

    if (userGuess.isEmpty) {
      setState(() {
        resultMessage = '⚠ Please enter a number between 1 and 6!';
      });
      return;
    }

    int guessedNumber = int.tryParse(userGuess) ?? -1;

    if (guessedNumber < 1 || guessedNumber > 6) {
      setState(() {
        resultMessage = '❌ Enter a valid number (1 to 6 only)';
      });
      return;
    }

    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        diceNumber = Random().nextInt(6) + 1;

        if (guessedNumber == diceNumber) {
          correctGuesses++;
          resultMessage = '🎉 Correct! Dice was $diceNumber';
        } else {
          wrongGuesses++;
          resultMessage =
          '😢 Wrong! You chose $guessedNumber, Dice was $diceNumber';
        }

        round++;
        guessController.clear();
        userGuess = '';

        // Final result popup
        if (round == maxRounds) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Game Over"),
              content: Text(
                  "Difficulty: $difficulty\nCorrect: $correctGuesses\nWrong: $wrongGuesses"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                )
              ],
            ),
          );
        }
      });
    });
  }

  void restartGame() {
    setState(() {
      round = 0;
      correctGuesses = 0;
      wrongGuesses = 0;
      diceNumber = 1;
      resultMessage = '';
      guessController.clear();
      userGuess = '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dice App — Made by Farhat',
          style: TextStyle(
            color: Color(0xFFFFB6C1),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Color(0xFFFFB6C1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Difficulty selector
              DropdownButton<String>(
                value: difficulty,
                dropdownColor: Colors.purple[100],
                items: ["Easy", "Medium", "Hard"]
                    .map((level) =>
                    DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setDifficulty(value);
                },
              ),

              const SizedBox(height: 10),

              // Scoreboard
              Text(
                'Round: $round / $maxRounds   ✅ $correctGuesses   ❌ $wrongGuesses',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Dice animation
              AnimatedBuilder(
                animation: _rotationAnimation,
                child: Image.asset('assets/images/$diceNumber.png', width: 150),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: child,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Input field
              SizedBox(
                width: 160,
                child: TextField(
                  controller: guessController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Enter 1-6',
                  ),
                  onChanged: (value) {
                    userGuess = value;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Roll button
              ElevatedButton(
                onPressed: round >= maxRounds ? null : rollDice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: const Text(
                  'Roll Dice',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFB6C1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Result message
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Restart button
              if (round >= maxRounds)
                ElevatedButton(
                  onPressed: restartGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Restart Game',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}