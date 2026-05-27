import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(FarhatColorMix());
class FarhatColorMix extends StatelessWidget {
  const FarhatColorMix({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mix and match games',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// ---------------- Modern Login Screen ----------------
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;

  void _login() {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter username and password!'),
            backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.yellow,
              Colors.blue.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 330,
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("🎨 Farhat Color craft",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple)),
                SizedBox(height: 30),

                TextField(
                  controller: usernameController,
                  style: TextStyle(color: Colors.pink),
                  decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  style: TextStyle(color: Colors.pink),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.brown,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 30),

                GestureDetector(
                  onTap: _login,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Login",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Splash Screen ----------------
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double leftPos = -200;
  double rightPos = -200;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        leftPos = 0;
        rightPos = 0;
      });
    });
    Timer(Duration(seconds: 4), () {
      _showWelcomeDialog();
    });
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            '🎉 Welcome to Farhat\'s Games!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Start', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MainMenu()), // <-- goes to Main Menu
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            left: leftPos,
            top: 0,
            bottom: 0,
            width: screenWidth / 2,
            child: Image.asset(
              'assets/images/left-half.png',
              fit: BoxFit.cover,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            right: rightPos,
            top: 0,
            bottom: 0,
            width: screenWidth / 2,
            child: Image.asset(
              'assets/images/right-half.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------- Main Menu ----------------
// ---------------- Main Menu ----------------
class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("🎮 Farhat Games"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: Stack(
        children: [

          // 🔹 Center Buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GameScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  child: Text("🎨 Color Mix Game",
                      style: TextStyle(fontSize: 20)),
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CardMatchingGame()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  child: Text("🎴 Card Matching Game",
                      style: TextStyle(fontSize: 20)),
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                            (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  child: Text("🚪 Logout",
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),

          // 🔥 Modern Circular Back Button
          Positioned(
            top: 25,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------- Game Screen ----------------
enum ShapeType { balloon, square, bottle }

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> colors = [Colors.pink, Colors.purple, Colors.yellow, Colors.blue];
  final Map<Color, String> colorNames = {
    Colors.pink: 'Pink',
    Colors.purple: 'Purple',
    Colors.yellow: 'Yellow',
    Colors.blue: 'Blue',
  };

  late Color targetColor;
  List<Color> selectedColors = [];
  bool mixing = false;
  int score = 0;
  int attempts = 0;
  int currentRound = 1;   // Current round number
  int maxRounds = 5;      // Total rounds per game
  bool showReplay = false;
  Color? lastTargetColor;
  bool roundCompleted = false;
  ShapeType selectedShape = ShapeType.balloon;
  Color? hintColor;

  int secondsLeft = 60; // Timer for color mixing game
  Timer? roundTimer;

  @override
  void initState() {
    super.initState();
    _generateTarget();
  }

  void _startRoundTimer() {
    roundTimer?.cancel();
    secondsLeft = 30;
    roundTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsLeft--;
      });
      if (secondsLeft <= 0) {
        roundTimer?.cancel();
        _timeUpNextRound();
      }
    });
  }

  void _timeUpNextRound() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.pink[50],
        title: Center(
          child: Text(
            '⏰ Time Out!',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 20),
          ),
        ),
        content: Text(
          'Time is over!\nNext round will start automatically.',
          textAlign: TextAlign.center,
        ),
      ),
    );

    // Wait 2 seconds then close dialog & go next round
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop(); // close dialog
        _nextRound(); // go to next round
      }
    });
  }
  void _showGameOverDialog() {
    roundTimer?.cancel(); // stop timer
    showDialog(
      context: context,
      barrierDismissible: false, // force user to press button
      builder: (_) => AlertDialog(
        title: Text('🏆 Game Over!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your Score: $score'),
            Text('Attempts: $attempts'),
            SizedBox(height: 20),
            Text('Thanks for playing!', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _handleRefresh(); // reset the game
            },
            child: Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
              );
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }
  void _nextRound() {
    if (currentRound >= maxRounds) {
      _showGameOverDialog();
    } else {
      setState(() {
        currentRound++;
        _generateTarget();
      });
    }
  }

  void _generateTarget() {
    targetColor = colors[Random().nextInt(colors.length)];
    selectedColors.clear();
    showReplay = false;
    roundCompleted = false;
    hintColor = null;
    _startRoundTimer();
  }

  void _checkResult() {
    if (selectedColors.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Select exactly 3 colors!'),
            backgroundColor: Colors.pink),
      );
      return;
    }

    setState(() {
      mixing = true;
      attempts++;
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        mixing = false;
        roundCompleted = true;
      });

      if (selectedColors.contains(targetColor)) {
        score++;
        lastTargetColor = targetColor;
        _showGiftReward();
      } else {
        _showResultDialog(false);
      }
    });
  }

  void _showResultDialog(bool success) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.pink[100],
        title: Text(
          success ? '🎉 Congratulations!' : '😅 Try Again!',
          style: TextStyle(
              color: success ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Target Color: ${colorNames[targetColor]}'),
            SizedBox(height: 10),
            Text(
                'Selected Colors: ${selectedColors.map((c) => colorNames[c]).join(", ")}'),
            SizedBox(height: 10),
            Text('Score: $score'),
            Text('Attempts: $attempts'),
          ],
        ),
        actions: [
          if (!success)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nextRound();
              },
              child: Text('Next Round'),
            ),
        ],
      ),
    );
  }

  void _showGiftReward() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.pink[50],
        content: GiftAnimation(targetColor: lastTargetColor!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextRound();
            },
            child: Text('Next Round'),
          )
        ],
      ),
    );
  }

  void _handleReplay() {
    setState(() {
      selectedColors.clear();
      mixing = false;
      roundCompleted = false;
      hintColor = null;
      showReplay = true; // allow selections again
      _startRoundTimer(); // reset timer for current round
    });
  }

  void _handleRefresh() {
    setState(() {
      score = 0;
      attempts = 0;
      currentRound = 1;
      _generateTarget();
    });
  }

  void _onShapeTap(ShapeType shape) {
    setState(() {
      selectedShape = shape;
    });

    // 🔥 Reset timer when shape changes
    _startRoundTimer();
  }

  void _onColorTap(Color c) {
    setState(() {
      if (selectedColors.contains(c))
        selectedColors.remove(c);
      else if (selectedColors.length < 3) selectedColors.add(c);
    });
  }

  void _undoSelection() {
    if (selectedColors.isEmpty) return;
    setState(() {
      selectedColors.removeLast();
    });
  }

  void _shuffleColors() {
    setState(() {
      colors.shuffle();
    });
  }

  void _showHint() {
    if (selectedColors.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Select exactly 2 colors first!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      if (selectedColors.contains(targetColor)) {
        List<Color> remainingColors =
        colors.where((c) => !selectedColors.contains(c)).toList();

        if (remainingColors.isNotEmpty) {
          hintColor =
          remainingColors[Random().nextInt(remainingColors.length)];
        }
      } else {
        hintColor = targetColor;
      }
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        hintColor = null;
      });
    });
  }

  Widget _buildShapeWidget(Color c) {
    bool isHint = hintColor == c;
    switch (selectedShape) {
      case ShapeType.balloon:
        return Balloon(
            color: c, selected: selectedColors.contains(c) || isHint);
      case ShapeType.square:
        return Square(
            color: c, selected: selectedColors.contains(c) || isHint);
      case ShapeType.bottle:
        return Bottle(
            color: c, selected: selectedColors.contains(c) || isHint);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          FloatingAnimations(),
          Row(
            children: [
              Container(
                width: 100,
                color: Colors.pink[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Shapes', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 30),
                    ShapeButton(
                        label: 'Balloon',
                        selected: selectedShape == ShapeType.balloon,
                        onTap: () => _onShapeTap(ShapeType.balloon)),
                    ShapeButton(
                        label: 'Square',
                        selected: selectedShape == ShapeType.square,
                        onTap: () => _onShapeTap(ShapeType.square)),
                    ShapeButton(
                        label: 'Bottle',
                        selected: selectedShape == ShapeType.bottle,
                        onTap: () => _onShapeTap(ShapeType.bottle)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Score: $score',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Attempts: $attempts',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Round: $currentRound / $maxRounds',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Time: $secondsLeft s',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: targetColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple, width: 3),
                      ),
                      child: Center(
                          child: Text(
                            'Target',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: Center(
                        child: Wrap(
                          spacing: 25,
                          runSpacing: 25,
                          alignment: WrapAlignment.center,
                          children: colors.map((c) {
                            return GestureDetector(
                              onTap: () => _onColorTap(c),
                              child: _buildShapeWidget(c),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: mixing ? null : _checkResult,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      child: mixing
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Mix Colors', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _undoSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          child: Text('Undo', style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _shuffleColors,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          child: Text('Shuffle', style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _showHint,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[700],
                            padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          child: Text('Hint', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 5,
            child: ElevatedButton(
              onPressed: () {
                roundTimer?.cancel();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MainMenu()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Back'),
            ),
          ),
          Positioned(
            top: 80,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LevelsScreen(
                      onLevelSelected: () {
                        _startRoundTimer(); // 🔥 Reset timer when level selected
                      },
                    ),
                  ), // <-- Levels screen
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 3),
                ),
                child: Center(child: Text('🎴', style: TextStyle(fontSize: 24))),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _handleRefresh,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                  child: Text('Refresh'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleReplay,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                  child: Text('Replay'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                            (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue),
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//level screen add
class LevelsScreen extends StatelessWidget {
  final VoidCallback onLevelSelected;

  const LevelsScreen({required this.onLevelSelected});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
        backgroundColor: Colors.pink[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 2.5,
          ),
          itemCount: 10,
          itemBuilder: (_, index) {
            int level = index + 1;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
              ),
              onPressed: () {
                Navigator.pop(context);

                onLevelSelected(); // 🔥 Reset timer from GameScreen

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Level $level selected!')),
                );
              },
              child: Text('Level $level', style: TextStyle(fontSize: 20)),
            );
          },
        ),
      ),
    );
  }
}
// ---------------- Mini-Game: Card Matching ----------------
class CardMatchingGame extends StatefulWidget {
  @override
  _CardMatchingGameState createState() => _CardMatchingGameState();
}

class _CardMatchingGameState extends State<CardMatchingGame> {
  List<String> cards = [];
  List<bool> flipped = [];
  List<int> selectedIndices = [];

  int score = 0;
  int level = 1;
  int maxLevel = 3;

  int secondsLeft = 30;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _generateCards();
    _startTimer();
  }

  void _generateCards() {
    List<String> base;

    if (level == 1) {
      base = ['🍎','🍌','🍓','🍇','🍊'];
    } else if (level == 2) {
      base = ['🍎','🍌','🍓','🍇','🍊','🍉'];
    } else {
      base = ['🍎','🍌','🍓','🍇','🍊','🍉','🥝'];
    }

    cards = [...base, ...base];
    cards.shuffle();

    flipped = List.filled(cards.length, false);
    selectedIndices.clear();

    secondsLeft = 30;
    gameTimer?.cancel();
    setState(() {});
  }

  void _startTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsLeft--;
      });

      if (secondsLeft <= 0) {
        gameTimer?.cancel();
        _showGameOverDialog();
      }
    });
  }

  void _flipCard(int index) {
    if (flipped[index] || selectedIndices.length >= 2 || secondsLeft <= 0) return;

    setState(() {
      flipped[index] = true;
      selectedIndices.add(index);
    });

    if (selectedIndices.length == 2) {
      Timer(Duration(milliseconds: 700), () {
        _checkMatch();
      });
    }
  }

  void _checkMatch() {
    int first = selectedIndices[0];
    int second = selectedIndices[1];

    if (cards[first] == cards[second]) {
      score += 10;
    } else {
      flipped[first] = false;
      flipped[second] = false;
    }

    selectedIndices.clear();
    setState(() {});

    if (flipped.every((f) => f == true)) {
      gameTimer?.cancel();
      _levelUpDialog();
    }
  }

  void _levelUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.pink[50],
        title: Center(
          child: Text(
            '🎉 Level $level Completed!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (level < maxLevel) {
                level++;
                _startGame();
              } else {
                _showWinDialog();
              }
            },
            child: Text(level < maxLevel ? 'Next Level' : 'Finish'),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.yellow[100],
        title: Center(
          child: Text(
            '🏆 You Won All Levels!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ),
        content: Text('Final Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              level = 1;
              score = 0;
              _startGame();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.red[100],
        title: Center(
          child: Text(
            '⏰ Time Up!',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              level = 1;
              score = 0;
              _startGame();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxis = cards.length <= 10 ? 5 : 4;

    return Scaffold(
      appBar: AppBar(
        title: Text('🎴 Card Matching - Level $level'),
        backgroundColor: Colors.pink[300],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Text(
                '⏳ $secondsLeft s   |   🎯 Score: $score',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxis,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => _flipCard(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            flipped[index] ? cards[index] : '❓',
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                gameTimer?.cancel();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MainMenu()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Floating Animations ----------------
// Balloon, Square, Bottle, GiftAnimation, FloatingAnimations

class FloatingAnimations extends StatefulWidget {
  @override
  _FloatingAnimationsState createState() => _FloatingAnimationsState();
}

class _FloatingAnimationsState extends State<FloatingAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<ConfettiParticle> particles = [];
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(seconds: 20), vsync: this)..repeat();

    // Delay particle creation until first frame to get screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
      setState(() {
        particles = List.generate(15, (index) => ConfettiParticle.fullScreen(screenWidth, screenHeight));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (particles.isEmpty) return SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: particles.map((p) {
            double y = (p.initialY - _controller.value * screenHeight * 1.9) % screenHeight;
            return Positioned(
              left: p.x,
              top: y,
              child: Icon(
                p.type == 0 ? Icons.cloud : Icons.star,
                size: p.size,
                color: p.color,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ConfettiParticle {
  double x = 0;
  double initialY = 0;
  double size = 20;
  int type = 0; // 0 = cloud, 1 = star
  Color color = Colors.white;

  ConfettiParticle.fullScreen(double screenWidth, double screenHeight) {
    x = Random().nextDouble() * screenWidth;
    initialY = Random().nextDouble() * screenHeight;
    size = 20 + Random().nextDouble() * 20;
    type = Random().nextInt(2);
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.7);
  }
}

// ---------------- Shape Buttons ----------------
class ShapeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const ShapeButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.pink[300] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple),
        ),
        child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
      ),
    );
  }
}

// ---------------- Balloon Widget ----------------
class Balloon extends StatelessWidget {
  final Color color;
  final bool selected;
  const Balloon({required this.color, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [color.withOpacity(0.8), Colors.white.withOpacity(0.2)],
              center: Alignment(-0.3, -0.3),
              radius: 0.8,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.6), blurRadius: 8, spreadRadius: 1),
            ],
            border: Border.all(color: selected ? Colors.black : Colors.white, width: 4),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 4,
            height: 20,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

// ---------------- Square Widget ----------------
class Square extends StatelessWidget {
  final Color color;
  final bool selected;
  const Square({required this.color, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? Colors.black : Colors.white, width: 4),
        boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)],
      ),
    );
  }
}

// ---------------- Bottle Widget ----------------
class Bottle extends StatelessWidget {
  final Color color;
  final bool selected;
  const Bottle({required this.color, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? Colors.black : Colors.white, width: 3),
          ),
        ),
        Container(
          width: 20,
          height: 10,
          color: color,
        )
      ],
    );
  }
}

// ---------------- Gift Animation ----------------
class GiftAnimation extends StatefulWidget {
  final Color targetColor;
  const GiftAnimation({required this.targetColor});

  @override
  _GiftAnimationState createState() => _GiftAnimationState();
}

class _GiftAnimationState extends State<GiftAnimation>
    with TickerProviderStateMixin {
  bool open = false;
  late AnimationController _controller;
  late Animation<double> _popperAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _popperAnim = Tween<double>(begin: 0, end: -150).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        open = true;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!open)
            Container(
              width: 100,
              height: 100,
              color: widget.targetColor,
              child: Center(
                  child: Text(
                    '🎁',
                    style: TextStyle(fontSize: 36),
                  )),
            ),
          if (open)
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Positioned(
                  bottom: _popperAnim.value,
                  child: Column(
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 50, color: Colors.orangeAccent),
                      SizedBox(height: 10),
                      Icon(Icons.circle, size: 20, color: Colors.amber),
                      SizedBox(height: 5),
                      Icon(Icons.circle, size: 20, color: Colors.yellow),
                    ],
                  ),
                );
              },
            ),
          if (open)
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    color: widget.targetColor,
                    child: Center(
                      child: Text('🎉 Winner!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 250,
                    height: 100,
                    child: Stack(
                      children: List.generate(5, (index) {
                        double startX = Random().nextDouble() * 200;
                        double startDelay = Random().nextDouble() * 2;
                        return AnimatedBalloon(delay: startDelay, x: startX);
                      }),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------- Animated Balloon for gift celebration ----------------
class AnimatedBalloon extends StatefulWidget {
  final double delay;
  final double x;
  const AnimatedBalloon({required this.delay, required this.x});

  @override
  _AnimatedBalloonState createState() => _AnimatedBalloonState();
}

class _AnimatedBalloonState extends State<AnimatedBalloon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(duration: Duration(seconds: 3), vsync: this)
      ..repeat(reverse: false);
    _anim = Tween<double>(begin: 100, end: -50).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Positioned(
          bottom: _anim.value - widget.delay * 50,
          left: widget.x,
          child: Icon(Icons.circle,
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              size: 20),
        );
      },
    );
  }
}