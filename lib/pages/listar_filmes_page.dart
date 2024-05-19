import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../database_helper.dart';
import '../models/filme.dart';
import 'cadastrar_filme_page.dart';
import 'detalhes_filme_page.dart';

class ListarFilmesPage extends StatefulWidget {
  @override
  _ListarFilmesPageState createState() => _ListarFilmesPageState();
}

class _ListarFilmesPageState extends State<ListarFilmesPage> {
  List<Filme> filmes = [];

  @override
  void initState() {
    super.initState();
    _getFilmes();
  }

  void _getFilmes() async {
    final dbHelper = DatabaseHelper();
    List<Filme> list = await dbHelper.getFilmes();
    setState(() {
      filmes = list;
    });
  }

  void _deleteFilme(int id, int index) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteFilme(id);
    setState(() {
      filmes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Filmes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showAlert(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          final filme = filmes[index];
          return Padding(
            padding: const EdgeInsets.all(12.0), // Increased padding around the card
            child: Dismissible(
              key: Key(filme.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _deleteFilme(filme.id!, index);
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Increased padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(4.0), // Padding inside ListTile
                        leading: Image.network(
                          filme.urlImagem,
                          width: 50,
                          height: 250,
                          fit: BoxFit.scaleDown,
                        ),
                        title: Text(
                          filme.titulo,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Increased font size
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10), // Added space between title and genre
                            Text('${filme.genero}', style: TextStyle(fontSize: 14)), // Increased font size
                            SizedBox(height: 4), // Added space between genre and duration
                            Text('${filme.duracao} min', style: TextStyle(fontSize: 14)), // Increased font size
                            SizedBox(height: 22), // Added space between duration and rating
                            Row(
                              children: [
                                Text('', style: TextStyle(fontSize: 26)), // Increased font size
                                RatingBarIndicator(
                                  rating: filme.pontuacao,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 24.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          _showOptions(context, filme);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastrarFilmePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nome do Grupo"),
          content: Text("Seu Grupo"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showOptions(BuildContext context, Filme filme) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Exibir Dados'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetalhesFilmePage(filme: filme)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Alterar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastrarFilmePage(filme: filme)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
