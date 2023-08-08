import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  TextEditingController _searchController = TextEditingController();

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=IyO7FLT2n9WFb7wJA4qx1cXf68IoBq42&limit=15&rating=g');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=IyO7FLT2n9WFb7wJA4qx1cXf68IoBq42&q=$_search&limit=15&offset=$_offset&rating=g&lang=pt');
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then(print);
  }

  void _performSearch() {
    setState(() {
      _search = _searchController.text;
      _offset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.deepOrangeAccent, // Alterando a cor da barra de navegação
        elevation: 0,
        title: Text(
          "GIF LAND", // Alterando o título
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadMoreGifs();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[300], // Alterando a cor de fundo
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    _performSearch();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search GIF...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    onSubmitted: (text) {
                      _performSearch();
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(15),
            color: Colors.deepOrangeAccent, // Alterando a cor do destaque
            child: Text(
              "Explore an Amazing Collection of GIFs!", // Alterando o texto
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepOrangeAccent),
                      strokeWidth: 5.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error loading GIFs",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            _loadMoreGifs();
          },
          child: Icon(
            Icons.refresh,
            color: Colors.deepOrangeAccent,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.deepOrangeAccent),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _loadMoreGifs() {
    setState(() {
      _offset += 15;
    });
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: snapshot.data['data'].length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']
                  ['url'],
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data['data'][index])),
            );
          },
          onLongPress: () {
            Share.share(
                snapshot.data['data'][index]['images']['fixed_height']['url']);
          },
        );
      },
    );
  }
}
