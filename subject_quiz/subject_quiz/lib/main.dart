import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const FrontScreen(),
    );
  }
}
class FrontScreen extends StatelessWidget {
  const FrontScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.quiz,
              size: 120,
              color: Colors.white,
            ),

            const SizedBox(height: 20),

            const Text(
              "Quiz App",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Test Your Knowledge",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryScreen(),
                  ),
                );
              },
              child: const Text(
                "Start Quiz",
                style: TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Made By Farhat 💜",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<String> subjects = const [
    "Web Technologies",
    "Statistics & Probability",
    "Operating System",
    "DAA",
    "COAL",
    "Mobile App Development"
  ];
  IconData getIcon(String subject) {
    switch (subject) {
      case "Web Technologies":
        return Icons.language;

      case "Statistics & Probability":
        return Icons.bar_chart;

      case "Operating System":
        return Icons.computer;

      case "DAA":
        return Icons.memory;

      case "COAL":
        return Icons.developer_board;

      case "Mobile App Development":
        return Icons.phone_android;

      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Subject"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.purple],
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(25),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Made By Farhat 💜",
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.pinkAccent,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(getIcon(subjects[index]), color: Colors.pink),
              title: Text(
                subjects[index],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(subject: subjects[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String subject;

  const QuizScreen({super.key, required this.subject});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int timeLeft = 10;
  int score = 0;
  Timer? timer;

  int? selectedAnswer;
  bool answered = false;

  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void loadQuestions() {
    if (widget.subject == "Web Technologies") {
      questions = [
        {
          "q": "HTML stands for?",
          "o": [
            "Hyper Text Markup Language",
            "High Text Machine Language",
            "Home Tool Markup Language",
            "None",
            "Hyperlink Text Markup"
          ],
          "a": 0
        },
        {
          "q": "CSS is used for?",
          "o": ["Styling", "Database", "Server", "Logic", "Networking"],
          "a": 0
        },
        {
          "q": "Which tag is used for links?",
          "o": ["<a>", "<link>", "<href>", "<url>", "<anchor>"],
          "a": 0
        },
        {
          "q": "HTML file extension?",
          "o": [".html", ".htm", ".xml", ".css", ".js"],
          "a": 0
        },
        {
          "q": "Which tag is for headings?",
          "o": ["<h1>", "<head>", "<title>", "<header>", "<h6>"],
          "a": 0
        },
      ];
    } else if (widget.subject == "Statistics & Probability") {
      questions = [
        {
          "q": "Mean is also called?",
          "o": ["Average", "Median", "Mode", "Variance", "Probability"],
          "a": 0
        },
        {
          "q": "Probability of sure event?",
          "o": ["1", "0", "0.5", "-1", "Cannot say"],
          "a": 0
        },
        {
          "q": "Variance measures?",
          "o": ["Spread", "Central Value", "Maximum", "Minimum", "None"],
          "a": 0
        },
        {
          "q": "Mode is?",
          "o": ["Most frequent value", "Middle value", "Average", "Total", "Range"],
          "a": 0
        },
        {
          "q": "Sum of probabilities in sample space?",
          "o": ["1", "0", "2", "-1", "Depends"],
          "a": 0
        },
      ];
    } else if (widget.subject == "Operating System") {
      questions = [
        {
          "q": "OS manages?",
          "o": ["Hardware", "Games", "Music", "None", "Applications"],
          "a": 0
        },
        {
          "q": "Example of OS?",
          "o": ["Windows", "MS Word", "Chrome", "Facebook", "Excel"],
          "a": 0
        },
        {
          "q": "Kernel is?",
          "o": ["Core part of OS", "App", "Program", "Driver", "Service"],
          "a": 0
        },
        {
          "q": "OS type?",
          "o": ["Single user", "Browser", "Editor", "Compiler", "IDE"],
          "a": 0
        },
        {
          "q": "Multitasking OS?",
          "o": ["Windows", "Notepad", "Paint", "Calculator", "MS Word"],
          "a": 0
        },
      ];
    } else if (widget.subject == "DAA") {
      questions = [
        {
          "q": "Time complexity of Binary Search?",
          "o": ["O(log n)", "O(n)", "O(n^2)", "O(1)", "O(n log n)"],
          "a": 0
        },
        {
          "q": "Stack follows?",
          "o": ["LIFO", "FIFO", "Random", "Priority", "None"],
          "a": 0
        },
        {
          "q": "Queue follows?",
          "o": ["FIFO", "LIFO", "Stack", "Tree", "Graph"],
          "a": 0
        },
        {
          "q": "Graph is made of?",
          "o": ["Vertices and Edges", "Lines and Circles", "Pages", "Nodes only", "Trees"],
          "a": 0
        },
        {
          "q": "Which is Divide & Conquer?",
          "o": ["Merge Sort", "Linear Search", "Stack", "Queue", "DFS"],
          "a": 0
        },
      ];
    } else if (widget.subject == "COAL") {
      questions = [
        {
          "q": "COAL stands for?",
          "o": ["Computer Organization and Architecture Lab", "Code Optimization And Logic", "Compiler Operations And Language", "Computer Operation And Learning", "None"],
          "a": 0
        },
        {
          "q": "Purpose of COAL?",
          "o": ["Lab Practice", "Gaming", "Music", "Networking", "Painting"],
          "a": 0
        },
        {
          "q": "Registers are?",
          "o": ["Fast storage", "Slow storage", "External storage", "Cloud", "None"],
          "a": 0
        },
        {
          "q": "CPU performs?",
          "o": ["Processing", "Storing", "Displaying", "Networking", "Printing"],
          "a": 0
        },
        {
          "q": "ALU stands for?",
          "o": ["Arithmetic Logic Unit", "Automated Logic Unit", "Application Level Unit", "Array Logic Unit", "None"],
          "a": 0
        },
      ];
    } else if (widget.subject == "Mobile App Development") {
      questions = [
        {
          "q": "Flutter is used for?",
          "o": ["Apps", "Cooking", "Driving", "None", "Gardening"],
          "a": 0
        },
        {
          "q": "Flutter language?",
          "o": ["Dart", "Java", "Python", "C++", "Kotlin"],
          "a": 0
        },
        {
          "q": "Widgets in Flutter?",
          "o": ["UI components", "Database", "Server", "Logic", "OS"],
          "a": 0
        },
        {
          "q": "Hot Reload in Flutter?",
          "o": ["Instant update", "Slow update", "No update", "Compile only", "Debug only"],
          "a": 0
        },
        {
          "q": "Stateful widget can?",
          "o": ["Change UI dynamically", "Static UI", "Compile code", "Run server", "Save files"],
          "a": 0
        },
      ];
    }
  }

  void startTimer() {
    timer?.cancel();

    int endTime = DateTime.now().millisecondsSinceEpoch + (10 * 1000);

    timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (!mounted) return;

      int remaining = ((endTime - DateTime.now().millisecondsSinceEpoch) / 1000).ceil();

      if (remaining <= 0) {
        setState(() {
          timeLeft = 0;
        });
        timer?.cancel();
        showTimeout();
      } else {
        setState(() {
          timeLeft = remaining;
        });
      }
    });
  }

  void showTimeout() {
    timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Time Up ⏰"),
        content: Text("Your Score: $score / ${questions.length}"),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartQuiz();
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
  void checkAnswer(int selectedIndex) {

    if (answered) return;

    setState(() {

      selectedAnswer = selectedIndex;
      answered = true;

      if (selectedIndex == questions[questionIndex]["a"]) {
        score++;
      }

    });

  }
  Color getColor(int index) {

    if (!answered) return Colors.lime;

    if (index == questions[questionIndex]["a"]) {
      return Colors.lightGreen;
    }

    if (index == selectedAnswer) {
      return Colors.red;
    }

    return Colors.lime;
  }
  void nextQuestion(bool isCorrect) {

    if (questionIndex < questions.length - 1) {

      setState(() {
        questionIndex++;
        answered = false;
        selectedAnswer = null;
      });

    } else {

      timer?.cancel();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Finished 🎉"),
          content: Text("Your Score: $score / ${questions.length}"),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartQuiz();
              },
              child: const Text("Restart"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      );

    }
  }
  void restartQuiz() {
    setState(() {
      questionIndex = 0;
      score = 0;
      timeLeft = 10;
      answered = false;
      selectedAnswer = null;
    });

    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var q = questions[questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Time: $timeLeft s",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),

            Text(
              "Question ${questionIndex + 1} / ${questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text("Score: $score",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(q["q"],
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 20),
            ...(q["o"] as List<String>).asMap().entries.map((entry) {
              int index = entry.key;
              String opt = entry.value;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColor(index),
                  ),
                  onPressed: () => checkAnswer(index),
                  child: Text(opt),
                ),
              );
            }),

            const SizedBox(height: 20),

            answered
                ? ElevatedButton(
              onPressed: () {
                nextQuestion(false);
              },
              child: const Text("Next Question"),
            )
                : const SizedBox(),

          ],
        ),
      ),
    );
  }
}