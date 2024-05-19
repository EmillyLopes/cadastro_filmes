import 'package:cadastro_filmes/pages/listar_filmes_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListarFilmesPage(),
    );
  }
}
