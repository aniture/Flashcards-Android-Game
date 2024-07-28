import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cs442_mp4/models/deck.dart';
import 'package:cs442_mp4/models/flashcard.dart';
import 'package:cs442_mp4/views/deck_editor.dart';
import 'card_list.dart'; // Import the Deck class

class DeckList extends StatefulWidget {
  const DeckList({super.key});

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  List<Deck> decks = [];

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final String jsonContent = await DefaultAssetBundle.of(context)
        .loadString('assets/flashcards.json');
    final List<dynamic> jsonData = json.decode(jsonContent);

    for (final dynamic item in jsonData) {
      final String title = item['title'];
      final List<Flashcard> flashcards = (item['flashcards'] as List<dynamic>)
          .map((fc) => Flashcard(
                id: fc['question'].hashCode,
                deckId: title.hashCode.toString(),
                question: fc['question'],
                answer: fc['answer'],
              ))
          .toList();

      decks.add(Deck(id: title.hashCode, title: title, flashcards: flashcards));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Center(
          child: Text(
            'Flashcard Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: () {
              if (kDebugMode) {
                print('Download button pressed');
              }
              _loadDecks();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the crossAxisCount based on screen width
          int crossAxisCount =
              (constraints.maxWidth / 350).floor(); // Change 350 to your desired item width

          return GridView.count(
            crossAxisCount: crossAxisCount,
            padding: const EdgeInsets.all(4),
            children: List.generate(
              decks.length,
              (index) => Card(
                color: Colors.orangeAccent,
                child: InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print('Deck ${decks[index].title} tapped');
                    }

                    // Navigate to the CardList widget when a deck is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardList(
                          deckTitle: decks[index].title, // Pass the deck title
                          decks: decks, // Pass the deck
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Center(child: Text(decks[index].title)),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final newDeck = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeckEditor(
                                    deckTitle: decks[index].title, // Pass the deck title
                                    isCreating: false,
                                    decks: decks,
                                    deckIndex: index,
                                  ),
                                ),
                              );
                              if (newDeck != null) {
                                // Update the decks list with the new deck
                                setState(() {
                                  decks = newDeck;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () async {
          if (kDebugMode) {
            print('Create a new deck button pressed');
          }
          final newDeck = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeckEditor(
                deckTitle: "", // Pass the deck title
                isCreating: true,
                decks: decks,
                deckIndex: 0,
              ),
            ),
          );
          if (newDeck != null) {
            // Update the decks list with the new deck
            setState(() {
              decks = newDeck;
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
