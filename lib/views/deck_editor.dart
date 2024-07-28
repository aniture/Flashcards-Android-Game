import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cs442_mp4/models/deck.dart';

class DeckEditor extends StatefulWidget {
  const DeckEditor({
    super.key,
    required this.deckTitle,
    required this.isCreating,
    required this.decks,
    required this.deckIndex,
  });

  final String deckTitle;
  final bool isCreating;
  final List<Deck> decks; 
  final int deckIndex;

  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  final TextEditingController _deckNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deckNameController.text = widget.deckTitle;
  }

  Future<void> _saveDeck() async {
    final deckTitle = _deckNameController.text;

    if (widget.isCreating) {
      final newDeck = Deck(id: deckTitle.hashCode, title: deckTitle, flashcards: []);
      widget.decks.add(newDeck);

      if (kDebugMode) {
        print('New deck created: $deckTitle');
      }
    } else {
      for (final deck in widget.decks) {
        if (deck.title == widget.deckTitle) {
          deck.title = deckTitle;
          break;
        }
      }

      if (kDebugMode) {
        print('Deck title updated: $deckTitle');
      }
    }

    Navigator.pop(context, widget.decks);
  }

  Future<void> _deleteDeck() async {
    if (widget.deckIndex >= 0 && widget.deckIndex < widget.decks.length) {
      widget.decks.removeAt(widget.deckIndex);

      if (kDebugMode) {
        print('Deck deleted at index ${widget.deckIndex}');
      }

      Navigator.pop(context, widget.decks);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = !widget.isCreating;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Deck' : 'Create Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Deck Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextFormField(
                controller: _deckNameController,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _saveDeck,
                  child: const Text('Save'),
                ),
                if (isEditing) ...[
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _deleteDeck,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
