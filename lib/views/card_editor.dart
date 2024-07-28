import 'package:flutter/material.dart';
import 'package:cs442_mp4/models/deck.dart';
import 'package:cs442_mp4/models/flashcard.dart';

class CardEditor extends StatefulWidget {
  final String initialQuestion;
  final String initialAnswer;
  final bool isDeletable;
  final List<Deck> decks;
  final String decksTitle;

  const CardEditor({
    super.key,
    required this.initialQuestion,
    required this.initialAnswer,
    required this.isDeletable,
    required this.decks,
    required this.decksTitle,
  });

  @override
  _CardEditorState createState() => _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {
  late TextEditingController questionController;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.initialQuestion);
    answerController = TextEditingController(text: widget.initialAnswer);
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    String updatedQuestion = questionController.text;
    String updatedAnswer = answerController.text;

    if (widget.isDeletable) {
      _createNewCard(updatedQuestion, updatedAnswer);
    } else {
      _updateExistingCard(updatedQuestion, updatedAnswer);
    }
  }

  void _createNewCard(String question, String answer) {
    Flashcard newCard = Flashcard(
      id: widget.decks.hashCode,
      deckId: widget.decksTitle.hashCode.toString(),
      question: question,
      answer: answer,
    );

    List<Deck> updatedDecks = widget.decks.map((deck) {
      if (deck.title == widget.decksTitle) {
        return Deck(
          id: widget.decksTitle.hashCode,
          title: deck.title,
          flashcards: [...deck.flashcards, newCard],
        );
      }
      return deck;
    }).toList();

    Navigator.pop(context, updatedDecks);
  }

  void _updateExistingCard(String question, String answer) {
    List<Deck> updatedDecks = widget.decks.map((deck) {
      if (deck.title == widget.decksTitle) {
        List<Flashcard> updatedFlashcards = deck.flashcards.map((flashcard) {
          if (flashcard.question == widget.initialQuestion) {
            return Flashcard(
              id: question.hashCode,
              deckId: widget.decksTitle.hashCode.toString(),
              question: question,
              answer: answer,
            );
          }
          return flashcard;
        }).toList();

        return Deck(
          id: widget.decksTitle.hashCode,
          title: deck.title,
          flashcards: updatedFlashcards,
        );
      }
      return deck;
    }).toList();

    Navigator.pop(context, updatedDecks);
  }

  void _deleteCard() {
    List<Deck> updatedDecks = widget.decks.map((deck) {
      if (deck.title == widget.decksTitle) {
        List<Flashcard> updatedFlashcards = deck.flashcards
            .where((flashcard) => flashcard.question != widget.initialQuestion)
            .toList();

        return Deck(
          id: widget.decksTitle.hashCode,
          title: deck.title,
          flashcards: updatedFlashcards,
        );
      }
      return deck;
    }).toList();

    Navigator.pop(context, updatedDecks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Card'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Edit Card',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Question (Label)'),
            TextField(
              controller: questionController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Answer (Label)'),
            TextField(
              controller: answerController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16),
                if (!widget.isDeletable)
                  ElevatedButton(
                    onPressed: _deleteCard,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                    ),
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
