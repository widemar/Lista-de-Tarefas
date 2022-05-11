import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/models/tarefa.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemListaTarefa extends StatelessWidget {
  const ItemListaTarefa(
      {Key? key, required this.tarefa, required this.deletarTarefa})
      : super(key: key);
  final Tarefa tarefa;
  final Function deletarTarefa;

  void deletar(BuildContext context) {
    deletarTarefa(tarefa);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: deletar,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever_sharp,
              label: "Deletar",
              spacing: 10,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.deepPurpleAccent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat("dd/MM/yyyy - HH:mm").format(tarefa.dataHora),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                tarefa.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
