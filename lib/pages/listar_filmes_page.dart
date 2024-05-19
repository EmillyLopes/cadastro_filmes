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
  List<Filme> _filmes = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadFilmes();
  }

  void _loadFilmes() async {
    List<Filme> filmes = await dbHelper.getFilmes();
    setState(() {
      _filmes = filmes;
    });
  }

  void _navigateToCadastrarFilme([Filme? filme]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastrarFilmePage(filme: filme),
      ),
    );
    _loadFilmes();
  }

  void _deleteFilme(int id) async {
    await dbHelper.deleteFilme(id);
    _loadFilmes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToCadastrarFilme(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filmes.length,
        itemBuilder: (context, index) {
          Filme filme = _filmes[index];
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(10.0),
                leading: Image.network(
                  filme.urlImagem,
                  width: 50,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  filme.titulo,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gênero: ${filme.genero}'),
                    Text('Duração: ${filme.duracao} min'),
                    Row(
                      children: [
                        Text('Pontuação: '),
                        RatingBarIndicator(
                          rating: filme.pontuacao,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 15.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesFilmePage(filme: filme),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _navigateToCadastrarFilme(filme),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteFilme(filme.id!),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2),  // Adiciona uma linha horizontal entre os itens
            ],
          );
        },
      ),
    );
  }
}
