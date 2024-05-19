import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/filme.dart';

class DetalhesFilmePage extends StatelessWidget {
  final Filme filme;

  DetalhesFilmePage({required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Detalhes do Filme',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(filme.urlImagem, height: 250),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filme.titulo,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  filme.ano.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${filme.genero}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  '${filme.faixaEtaria}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filme.duracao} min',
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
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
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Descrição:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              filme.descricao,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
