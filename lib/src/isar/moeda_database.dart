import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

//CRUD
class MoedaDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MoedaSchema],
      directory: dir.path,
    );
  }

  //Lista de Moeda
  final List<Moeda> currentMoeda = [];

  //Create
  Future<void> addMoeda(String nome) async {
    //Cria um novo objeto moeda
    final newMoeda = Moeda()..nome = nome;
    //Salvar no BD
    await isar.writeTxn(() => isar.moedas.put(newMoeda));
    // Re-read from BD
    await fetchMoedas();
  }

  //Read
  Future<void> fetchMoedas() async {
    List<Moeda> fetchedMoedas = await isar.moedas.where().findAll();
    currentMoeda.clear();
    currentMoeda.addAll(fetchedMoedas);
    notifyListeners();
  }

  //Update
  Future<void> updateMoeda(int id, String newMoeda) async {
    final existingMoeda = await isar.moedas.get(id);
    if (existingMoeda != null) {
      existingMoeda.nome = newMoeda;
      await isar.writeTxn(() => isar.moedas.put(existingMoeda));
      await fetchMoedas();
    }
  }

  //Delete
  Future<void> deleteMoeda(int id) async {
    await isar.writeTxn(() => isar.moedas.delete(id));
    await fetchMoedas();
  }
}