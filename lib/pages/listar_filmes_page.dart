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
  List<Filme> searchResults = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

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

  void _searchFilmes(String query) async {
    final dbHelper = DatabaseHelper();
    List<Filme> results = await dbHelper.searchFilmes(query);
    setState(() {
      searchResults = results;
    });
  }

  Future<bool?> _confirmDeleteFilme(int id, int index) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Você tem certeza que deseja excluir este filme?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFilme(int id, int index) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteFilme(id);
    setState(() {
      filmes.removeAt(index);
    });
  }

  Widget _buildFilmeCard(Filme filme, int index, {bool isSearchResult = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: isSearchResult
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetalhesFilmePage(filme: filme)),
          );
        }
            : () {
          _showOptions(context, filme);
        },
        child: Dismissible(
          key: Key(filme.id.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await _confirmDeleteFilme(filme.id!, index);
          },
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
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    filme.urlImagem,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10), // Espaçamento entre a imagem e as informações
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filme.titulo,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        SizedBox(height: 5), // Espaçamento entre o título e o gênero
                        Text('${filme.genero}'),
                        SizedBox(height: 5), // Espaçamento entre o gênero e a duração
                        Text('${filme.duracao} min'),
                        SizedBox(height: 20), // Espaçamento entre a duração e a nota
                        RatingBarIndicator(
                          rating: filme.pontuacao,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: isSearching
            ? TextField(
          controller: searchController,
          autofocus: true,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _searchFilmes(value);
            } else {
              setState(() {
                searchResults = [];
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Buscar filmes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: TextStyle(color: Colors.white),
        )
            : Text(
          'Filmes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            color: Colors.white,
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  searchResults = [];
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            color: Colors.white,
            onPressed: () {
              _showAlert(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearching && searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final filme = searchResults[index];
                  return _buildFilmeCard(filme, index, isSearchResult: true);
                },
              ),
            ),
          if (isSearching && searchResults.isEmpty)
            Center(child: Text('Nenhum filme encontrado')),
          if (!isSearching)
            Expanded(
              child: ListView.builder(
                itemCount: filmes.length,
                itemBuilder: (context, index) {
                  final filme = filmes[index];
                  return _buildFilmeCard(filme, index);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastrarFilmePage()),
          ).then((value) {
            if (value != null && value == true) {
              _getFilmes(); // Atualiza a lista de filmes após adicionar um novo filme
            }
          });
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
          title: Text("Equipe:"),
          content: Text("Emilly Lopes dos Santos e Silva"),
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
                  MaterialPageRoute(
                      builder: (context) => DetalhesFilmePage(filme: filme)),
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
                ).then((value) {
                  if (value != null && value == true) {
                    _getFilmes(); // Atualiza a lista de filmes após edição
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}
