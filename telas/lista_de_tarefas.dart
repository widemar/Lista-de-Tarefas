
import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/repositorios/repositorio_tarefa.dart';
import 'package:lista_de_tarefas/widgets/item_lista_tarefas.dart';
import 'package:lista_de_tarefas/models/tarefa.dart';

class ListaDeTarefas extends StatefulWidget {
  const ListaDeTarefas({Key? key}) : super(key: key);

  @override
  State<ListaDeTarefas> createState() => _ListaDeTarefasState();
}

class _ListaDeTarefasState extends State<ListaDeTarefas> {
  var adicionarTarefasTextField = TextEditingController();

  var repositorioTarefa = RepositorioTarefa();

  List<Tarefa> listaTarefas = [];
  Tarefa? tarefaDeletada;
  int? posicaoTarefaDeletada;

  bool singularPLural() {
    if (listaTarefas.length <= 1) {
      return true;
    } else {
      return false;
    }
  }

  void adicionarTarefas() {
    if (adicionarTarefasTextField.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Campo vazio, tarefa não adicionada",
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      setState(() {
        Tarefa tarefa = Tarefa(
            nome: adicionarTarefasTextField.text, dataHora: DateTime.now());
        listaTarefas.add(tarefa);
      });
      adicionarTarefasTextField.clear();
      repositorioTarefa.salvarListaDeTarefas(listaTarefas);
    }
  }

  void deletarTarefa(Tarefa tarefa) {
    tarefaDeletada = tarefa;
    posicaoTarefaDeletada = listaTarefas.indexOf(tarefa);

    setState(() {
      listaTarefas.remove(tarefa);
    });
    repositorioTarefa.salvarListaDeTarefas(listaTarefas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Tarefa "${tarefa.nome}" deletada com sucesso',
          textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Colors.white,
          onPressed: recolocarTarefasDeletadas,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void mostrarTodasTarefasQueSeraoDeletadas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Deletar tudo?",
        ),
        content: const Text(
          "Deseja deletar todas as tarefas adicionadas?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.amberAccent,
            ),
          ),
          TextButton(
            onPressed: deletarTodasTarefas,
            child: const Text(
              "Deletar tudo",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void deletarTodasTarefas() {
    setState(() {
      Navigator.of(context).pop();
      listaTarefas.clear();
    });
    repositorioTarefa.salvarListaDeTarefas(listaTarefas);
  }

  void recolocarTarefasDeletadas() {
    setState(() {
      listaTarefas.insert(posicaoTarefaDeletada!, tarefaDeletada!);
    });
    repositorioTarefa.salvarListaDeTarefas(listaTarefas);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    repositorioTarefa.pegarListaDeTarefas().then((value) {
      setState(() {
        listaTarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Lista de Tarefas",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: adicionarTarefasTextField,
                        decoration: const InputDecoration(
                          labelText: "Adicione uma tarefa",
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: adicionarTarefas,
                      child: const Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent,
                        padding: const EdgeInsets.only(
                          top: 22,
                          bottom: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (Tarefa nome in listaTarefas)
                          ItemListaTarefa(
                              tarefa: nome, deletarTarefa: deletarTarefa),
                      ],
                    ),
                  ),
                ),
                Text(
                  singularPLural()
                      ? "Você tem ${listaTarefas.length} tarefa pendente"
                      : "Você tem ${listaTarefas.length} tarefas pendentes",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "Clique e arraste para deletar uma única tarefa",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: mostrarTodasTarefasQueSeraoDeletadas,
                        child: const Text(
                          "Deletar todas as tarefas da lista",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
