import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../database_helper.dart';
import '../models/filme.dart';

class CadastrarFilmePage extends StatefulWidget {
  final Filme? filme;

  CadastrarFilmePage({this.filme});

  @override
  _CadastrarFilmePageState createState() => _CadastrarFilmePageState();
}

class _CadastrarFilmePageState extends State<CadastrarFilmePage> {
  final _formKey = GlobalKey<FormState>();
  late String _urlImagem;
  late String _titulo;
  late List<String> _generos;
  late String _faixaEtaria;
  late int _duracao;
  late double _pontuacao;
  late String _descricao;
  late int _ano;

  final List<MultiSelectItem<String>> _genreItems = [
    MultiSelectItem('Ação', 'Ação'),
    MultiSelectItem('Comédia', 'Comédia'),
    MultiSelectItem('Drama', 'Drama'),
    MultiSelectItem('Terror', 'Terror'),
    MultiSelectItem('Ficção Científica', 'Ficção Científica'),
    MultiSelectItem('Romance', 'Romance'),
    MultiSelectItem('Aventura', 'Aventura'),
    MultiSelectItem('Animação', 'Animação'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      _urlImagem = widget.filme!.urlImagem;
      _titulo = widget.filme!.titulo;
      _generos = widget.filme!.genero.split(', ');
      _faixaEtaria = widget.filme!.faixaEtaria;
      _duracao = widget.filme!.duracao;
      _pontuacao = widget.filme!.pontuacao;
      _descricao = widget.filme!.descricao;
      _ano = widget.filme!.ano;
    } else {
      _urlImagem = '';
      _titulo = '';
      _generos = [];
      _faixaEtaria = 'Livre';
      _duracao = 0;
      _pontuacao = 0.0;
      _descricao = '';
      _ano = 2024;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Filme filme = Filme(
        id: widget.filme?.id,
        urlImagem: _urlImagem,
        titulo: _titulo,
        genero: _generos.join(', '),
        faixaEtaria: _faixaEtaria,
        duracao: _duracao,
        pontuacao: _pontuacao,
        descricao: _descricao,
        ano: _ano,
      );

      final dbHelper = DatabaseHelper();
      if (widget.filme == null) {
        dbHelper.insertFilme(filme);
      } else {
        dbHelper.updateFilme(filme);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filme == null ? 'Cadastrar Filme' : 'Editar Filme'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _urlImagem,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
                onSaved: (value) {
                  _urlImagem = value!;
                },
              ),
              TextFormField(
                initialValue: _titulo,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _titulo = value!;
                },
              ),
              SizedBox(height: 16.0),
              MultiSelectDialogField(
                items: _genreItems,
                title: Text("Gêneros"),
                selectedColor: Colors.deepPurple,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.movie,
                  color: Colors.deepPurple,
                ),
                buttonText: Text(
                  "Selecione os Gêneros",
                  style: TextStyle(
                    color: Colors.deepPurple[900],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  _generos = results.cast<String>();
                },
                initialValue: _generos,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _faixaEtaria,
                decoration: InputDecoration(labelText: 'Faixa Etária'),
                items: ['Livre', '10', '12', '14', '16', '18']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _faixaEtaria = value!;
                  });
                },
              ),
              TextFormField(
                initialValue: _duracao.toString(),
                decoration: InputDecoration(labelText: 'Duração (min)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a duração';
                  }
                  return null;
                },
                onSaved: (value) {
                  _duracao = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    "Nota: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  RatingBar.builder(
                    initialRating: _pontuacao,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _pontuacao = rating;
                    },
                  ),
                ],
              ),
              TextFormField(
                initialValue: _ano.toString(),
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ano = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _descricao,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descricao = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
