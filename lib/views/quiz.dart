import 'package:flutter/material.dart';
import 'package:cs442_mp4/models/deck.dart';

class Quiz extends StatefulWidget {
  final String deckTitle;
  final List<Deck> decks;

  const Quiz({
    Key? key,
    required this.deckTitle,
    required this.decks,
  }) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<Map<String, String>> flashcards = [];
  int currentQuestionIndex = 0;
  bool isShowingAnswer = false;
  int peekedAnswers = 0;
  bool isGreenBackground = false;
  final List shownQuestion = [];
  int totalQuestionsAnswered = 0;
  List indexList = [];

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    for (final deck in widget.decks) {
      if (deck.title == widget.deckTitle) {
        // Convert the list of flashcards to a list of Map<String, String>
        flashcards = deck.flashcards.map((flashcard) {
          return {
            'question': flashcard.question,
            'answer': flashcard.answer,
          };
        }).toList();

        // Shuffle the flashcards to randomize their order
        flashcards.shuffle();
      }
    }

    setState(() {});
  }

  void _showAnswer() {
    setState(() {
      if (!isShowingAnswer) {
        isShowingAnswer = true;
        final currentQuestion = flashcards[currentQuestionIndex]['question']!;
        if (!shownQuestion.contains(currentQuestion)) {
          shownQuestion.add(currentQuestion);
          peekedAnswers++;
        }
      }
      isGreenBackground = !isGreenBackground;
      if (!isGreenBackground) {
        isShowingAnswer = false;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % flashcards.length;
      isShowingAnswer = false;
      isGreenBackground = false;
      if (!indexList.contains(currentQuestionIndex) &&
          indexList.length < flashcards.length) {
        totalQuestionsAnswered++;
        indexList.add(currentQuestionIndex);
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      currentQuestionIndex =
          (currentQuestionIndex - 1 + flashcards.length) % flashcards.length;
      isShowingAnswer = false;
      isGreenBackground = false;
      if (!indexList.contains(currentQuestionIndex) &&
          indexList.length < flashcards.length) {
        totalQuestionsAnswered++;
        indexList.add(currentQuestionIndex);
      }
    });
  }

  int _display() {
    return totalQuestionsAnswered == 0 ? 1 : totalQuestionsAnswered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${widget.deckTitle}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Card(
              color: isGreenBackground ? Colors.green : Colors.orangeAccent,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    isShowingAnswer
                        ? flashcards[currentQuestionIndex]['answer']!
                        : flashcards[currentQuestionIndex]['question']!,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousQuestion,
              ),
              ElevatedButton(
                onPressed: _showAnswer,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                child: const Text('▶️'),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _nextQuestion,
              ),
            ],
          ),
          const SizedBox(height: 16), // Add spacing between buttons and text
          Text(
            'Seen: $totalQuestionsAnswered of ${flashcards.length}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Peeked: $peekedAnswers out of ${_display()} Answer',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
