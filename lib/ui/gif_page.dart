import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;
  GifPage(this._gifData);

  void _shareGif() {
    final String gifUrl = _gifData['images']['fixed_height']['url'];
    Share.share('Check out this GIF!\n$gifUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GIF Share",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareGif(); // Chamando a função de compartilhamento
            },
          )
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _gifData['title'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Image.network(
              _gifData['images']['fixed_height']['url'],
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: Text(
          "Back to GIFs",
          style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 12),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.deepOrangeAccent),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
