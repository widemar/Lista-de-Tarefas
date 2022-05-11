import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/telas/lista_de_tarefas.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Monospace",
      ),
      debugShowCheckedModeBanner: false,
      home: const ListaDeTarefas(),
    );
  }
}
