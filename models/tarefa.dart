class Tarefa {
  Tarefa({required this.nome, required this.dataHora});

  Tarefa.fromJson(Map<String, dynamic> json)
      : nome = json["nome"],
        dataHora = DateTime.parse(json["datahora"]);

  String nome;
  DateTime dataHora;

  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "datahora": dataHora.toIso8601String(),
    };
  }
}
