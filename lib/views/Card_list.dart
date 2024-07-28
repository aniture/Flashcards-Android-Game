import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cs442_mp4/models/deck.dart';
import 'package:cs442_mp4/models/flashcard.dart';
import 'quiz.dart';
import 'card_editor.dart';

class CardList extends StatefulWidget {
  final String deckTitle;
  List<Deck> decks;

  CardList({
    super.key,
    required this.deckTitle,
    required this.decks,
  });

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  List<Flashcard> flashcards = [];
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    for (final deck in widget.decks) {
      if (deck.title == widget.deckTitle) {
        flashcards = deck.flashcards;
        break;
      }
    }
    setState(() {});
  }

  void _toggleSort() {
    setState(() {
      isAscending = !isAscending;
      flashcards.sort((a, b) {
        return isAscending
            ? a.question.compareTo(b.question)
            : b.question.compareTo(a.question);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _toggleSort,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Quiz(
                    deckTitle: widget.deckTitle,
                    decks: widget.decks,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 1,
        ),
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.orangeAccent,
            child: InkWell(
              onTap: () async {
                final newDecks = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardEditor(
                      initialQuestion: flashcards[index].question,
                      initialAnswer: flashcards[index].answer,
                      isDeletable: false,
                      decks: widget.decks,
                      decksTitle: widget.deckTitle,
                    ),
                  ),
                );
                if (newDecks != null) {
                  setState(() {
                    widget.decks = newDecks;
                  });
                  _loadFlashcards();
                  _debugPrintDecks(widget.decks);
                }
              },
              child: Center(
                child: Text(
                  flashcards[index].question,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDecks = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardEditor(
                initialQuestion: '',
                initialAnswer: '',
                isDeletable: true,
                decks: widget.decks,
                decksTitle: widget.deckTitle,
              ),
            ),
          );
          if (newDecks != null) {
            setState(() {
              widget.decks = newDecks;
            });
            _loadFlashcards();
            _debugPrintDecks(widget.decks);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _debugPrintDecks(List<Deck> decks) {
    for (var deck in decks) {
      if (kDebugMode) {
        print('Deck Title: ${deck.title}');
      }
      for (var flashcard in deck.flashcards) {
        if (kDebugMode) {
          print('Question: ${flashcard.question}, Answer: ${flashcard.answer}');
        }
      }
    }
  }
}
