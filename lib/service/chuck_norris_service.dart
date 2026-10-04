import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/joke.dart';

class ChuckNorrisService {
  String baseUrl = 'https://api.chucknorris.io';

  Future<Joke> getRandomJoke() async {
    Uri url = Uri.parse('$baseUrl/jokes/random');

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> dados = json.decode(response.body);

      return Joke.fromJson(dados);
    }

    throw Exception(
      'Erro ao buscar piada. Código: ${response.statusCode}',
    );
  }

  Future<Joke> getRandomJokeByCategory(String category) async {
    Uri url = Uri.parse(
      '$baseUrl/jokes/random?category=${Uri.encodeQueryComponent(category)}',
    );

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> dados = json.decode(response.body);

      return Joke.fromJson(dados);
    }

    throw Exception(
      'Erro ao buscar categoria. Código: ${response.statusCode}',
    );
  }

  Future<List<String>> getCategories() async {
    Uri url = Uri.parse('$baseUrl/jokes/categories');

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> dados = json.decode(response.body);

      return List<String>.from(dados);
    }

    throw Exception(
      'Erro ao buscar categorias. Código: ${response.statusCode}',
    );
  }

  Future<List<Joke>> searchJokes(String query) async {
    Uri url = Uri.parse(
      '$baseUrl/jokes/search?query=${Uri.encodeQueryComponent(query)}',
    );

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> dados = json.decode(response.body);

      List<dynamic> resultados = dados['result'] ?? [];

      List<Joke> piadas = [];

      for (dynamic item in resultados) {
        piadas.add(Joke.fromJson(item));
      }

      return piadas;
    }

    throw Exception(
      'Erro ao pesquisar. Código: ${response.statusCode}',
    );
  }
}
