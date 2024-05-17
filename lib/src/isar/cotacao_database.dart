import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:flutter/material.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/isar_service.dart';
import 'package:isar/isar.dart'; // Importe o IsarService

// CRUD
class CotacaoDatabase extends ChangeNotifier {
  //
  // Lista de cotações
  final List<Cotacoess> currentCotacao = [];

  // Método estático para inicializar o Isar
  static Future<void> initialize() async {
    await IsarService.initialize(); // Inicialize o IsarService uma vez
  }

  // Método para adicionar nova cotação
  Future<void> addCotacao(
      String nome, DateTime data, DateTime hora, double valor, Moeda moeda) async {
    final newCotacao = Cotacoess()
      ..nome = nome
      ..data = data
      ..hora = hora
      ..valor = valor
      ..moeda = moeda;

    await IsarService.isar
        .writeTxn(() => IsarService.isar.cotacoess.put(newCotacao));
    moeda.cotacoes.add(newCotacao);
    await fetchCotacoes();
  }

  // Método para buscar todas as cotações
  Future<void> fetchCotacoes() async {
    List<Cotacoess> fetchCotacoes =
        await IsarService.isar.cotacoess.where().findAll();
    currentCotacao.clear();
    currentCotacao.addAll(fetchCotacoes);
    notifyListeners();
  }

  // Método para deletar uma cotação pelo ID
  Future<void> deleteCotacao(int id) async {
    await IsarService.isar
        .writeTxn(() => IsarService.isar.cotacoess.delete(id));
    await fetchCotacoes();
  }
}
