import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

class IndicadorScreen extends StatefulWidget {
  const IndicadorScreen({super.key});

  @override
  IndicadorScreenState createState() => IndicadorScreenState();
}

class IndicadorScreenState extends State<IndicadorScreen> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readMoeda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Cadastro de indicadores"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildIndicadoresList(),
            ),
            const SizedBox(height: 16),
            _buildNavigatorButtons(),
          ],
        ),
      ),
      floatingActionButton: _buildAddIndicadorButton(),
    );
  }

  Widget _buildIndicadoresList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    List<Moeda> currentMoeda = moedaDatabase.currentMoeda;
    return currentMoeda.isEmpty
        ? const Center(
            child: Text(
              "Sua lista de indicadores está vazia",
              style: TextStyle(fontSize: 22),
            ),
          )
        : ListView.builder(
            itemCount: currentMoeda.length,
            itemBuilder: (context, index) {
              final moeda = currentMoeda[index];

              return ListTile(
                title: Text(
                  "Indicador: ${moeda.nome} - ID: ${moeda.id}",
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => updateMoeda,
                      icon: const Icon(Icons.create_sharp),
                    ),
                    IconButton(
                      onPressed: () => deleteMoeda,
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              );
            },
          );
  }

  void addMoedaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Indicador",
              style: TextStyle(color: Colors.blue, fontSize: 30)),
          content: TextField(
              controller: textController,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                  labelText: "Nome do indicador",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)))),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child:
                  const Text('Salvar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                context.read<MoedaDatabase>().addMoeda(textController.text);
                Navigator.pop(context);
                textController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddIndicadorButton() {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        onPressed: () {
          addMoedaDialog();
        },
        tooltip: "Adicionar indicador",
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNavigatorButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: goToGrafico,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: const Text(
            "Gráfico",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: goToCotacao,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: const Text(
            "Cotações",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void goToGrafico() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GraficoScreen()));
  }

  void goToCotacao() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CotacaoScreen()));
  }

  void readMoeda() {
    context.read<MoedaDatabase>().fetchMoedas();
  }

  void updateMoeda(Moeda moeda) {
    textController.text = moeda.nome;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update moeda'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                context
                    .read<MoedaDatabase>()
                    .updateMoeda(moeda.id, textController.text);
                textController.clear();
                Navigator.pop(context);
              },
              child: const Text('Update'))
        ],
      ),
    );
  }

  void deleteMoeda(int id) {
    context.read<MoedaDatabase>().deleteMoeda(id);
  }
}
