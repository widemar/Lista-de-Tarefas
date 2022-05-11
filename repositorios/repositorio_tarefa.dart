import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:lista_de_tarefas/models/tarefa.dart';

const String chaveListaTarefas = "lista_tarefas";

class RepositorioTarefa {
  late SharedPreferences sharedPreferences;

  Future<List<Tarefa>> pegarListaDeTarefas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(chaveListaTarefas) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Tarefa.fromJson(e)).toList();
  }

  void salvarListaDeTarefas(List<Tarefa> tarefas) {
    final String jsonString = json.encode(tarefas);
    sharedPreferences.setString(chaveListaTarefas, jsonString);
  }
}
