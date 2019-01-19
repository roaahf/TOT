import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  _RandomWordsState();
  }
}

class _RandomWordsState extends State<RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600);
  final Set<WordPair> _saved =  Set<WordPair>();

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
              backgroundColor: Colors.grey.shade700,
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Text('Startup Name Generator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
        backgroundColor: Colors.grey.shade700,
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.format_list_bulleted),
              onPressed: _pushSaved),
        ],
      ),

      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return  ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested
        // word pairing, and places each suggestion into a ListTile
        // row. For even rows, the function adds a ListTile row for
        // the word pairing. For odd rows, the function adds a
        // Divider widget to visually separate the entries. Note that
        // the divider may be difficult to see on smaller devices.
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return  Divider();
          }

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings
          // in the ListView,minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word
          // pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    void _bookmark() {
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else {
          _saved.add(pair);
        }
      });
    }
    return ListTile(
      title: Text(
        pair.asPascalCase,
        // Returns the word pair as a simple string, with each word capitalized,
        // like `"KeyFrame"` or `"BigUsa"`. This is informally called "pascal case".
        style: _biggerFont,
      ),

      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.shade500,
        child: Text(pair.toString().substring(0, 1),
          style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 30, color: Colors.white,),
        ),
      ),

      trailing: new Icon(
        alreadySaved ? Icons.bookmark : Icons.bookmark_border,
        color: alreadySaved ? Colors.amberAccent.shade700 : Colors.grey,
        size: 35,
      ),
      onTap: _bookmark,
    );
  }
}