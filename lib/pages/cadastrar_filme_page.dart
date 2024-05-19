import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  late String _genero;
  late String _faixaEtaria;
  late int _duracao;
  late double _pontuacao;
  late String _descricao;
  late int _ano;

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      _urlImagem = widget.filme!.urlImagem;
      _titulo = widget.filme!.titulo;
      _genero = widget.filme!.genero;
      _faixaEtaria = widget.filme!.faixaEtaria;
      _duracao = widget.filme!.duracao;
      _pontuacao = widget.filme!.pontuacao;
      _descricao = widget.filme!.descricao;
      _ano = widget.filme!.ano;
    } else {
      _urlImagem = '';
      _titulo = '';
      _genero = '';
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
        genero: _genero,
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
              TextFormField(
                initialValue: _genero,
                decoration: InputDecoration(labelText: 'Gênero'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o gênero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _genero = value!;
                },
              ),
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
              RatingBar.builder(
                initialRating: _pontuacao,
                minRating: 1,
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