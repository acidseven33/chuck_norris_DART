import 'package:flutter/material.dart';

import '../model/joke.dart';
import '../service/chuck_norris_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChuckNorrisService service = ChuckNorrisService();
  final TextEditingController searchController = TextEditingController();

  Joke? joke;
  List<Joke> searchResults = [];

  bool loading = false;
  String message = 'Escolha uma opção para começar.';

  @override
  void initState() {
    super.initState();
    _loadRandomJoke();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRandomJoke() async {
    setState(() {
      loading = true;
      message = 'Buscando uma piada...';
    });

    try {
      Joke resultado = await service.getRandomJoke();

      setState(() {
        joke = resultado;
        searchResults = [];
        message = '';
        loading = false;
      });
    } catch (erro) {
      setState(() {
        loading = false;
        message = 'Não foi possível consultar a API.';
      });

      _showMessage('Erro: verifique sua conexão com a internet.');
    }
  }

  Future<void> _searchJokes() async {
    String texto = searchController.text.trim();

    if (texto.isEmpty) {
      _showMessage('Digite uma palavra ou termo para pesquisar.');
      return;
    }

    setState(() {
      loading = true;
      message = 'Pesquisando...';
      searchResults = [];
    });

    try {
      List<Joke> resultados = await service.searchJokes(texto);

      setState(() {
        searchResults = resultados;
        joke = resultados.isNotEmpty ? resultados.first : null;
        loading = false;

        if (resultados.isEmpty) {
          message = 'Nenhuma piada encontrada para "$texto".';
        } else {
          message = '${resultados.length} resultado(s) encontrado(s).';
        }
      });
    } catch (erro) {
      setState(() {
        loading = false;
        message = 'Erro ao realizar a pesquisa.';
      });

      _showMessage('Não foi possível consultar a API.');
    }
  }

  Future<void> _showCategories() async {
    setState(() {
      loading = true;
    });

    try {
      List<String> categories = await service.getCategories();

      setState(() {
        loading = false;
      });

      if (!mounted) {
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Categorias'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  String category = categories[index];

                  return ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(category),
                    onTap: () {
                      Navigator.pop(context);
                      _loadCategory(category);
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    } catch (erro) {
      setState(() {
        loading = false;
      });

      _showMessage('Não foi possível carregar as categorias.');
    }
  }

  Future<void> _loadCategory(String category) async {
    setState(() {
      loading = true;
      message = 'Buscando categoria "$category"...';
    });

    try {
      Joke resultado =
          await service.getRandomJokeByCategory(category);

      setState(() {
        joke = resultado;
        searchResults = [];
        loading = false;
        message = 'Categoria: $category';
      });
    } catch (erro) {
      setState(() {
        loading = false;
        message = 'Erro ao buscar a categoria.';
      });

      _showMessage('Não foi possível consultar essa categoria.');
    }
  }

  void _showMessage(String texto) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
      ),
    );
  }

  Widget _buildJokeCard(Joke item) {
    return Card(
      margin: const EdgeInsets.only(top: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (item.iconUrl.isNotEmpty)
              Image.network(
                item.iconUrl,
                width: 90,
                height: 90,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 80,
                  );
                },
              ),

            const SizedBox(height: 16),

            Text(
              item.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            if (item.categories.isNotEmpty)
              Wrap(
                spacing: 8,
                children: item.categories.map(
                  (String categoria) {
                    return Chip(
                      label: Text(categoria),
                    );
                  },
                ).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.length <= 1) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        const Text(
          'Resultados da pesquisa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            Joke item = searchResults[index];

            return Card(
              child: ListTile(
                leading: item.iconUrl.isNotEmpty
                    ? Image.network(
                        item.iconUrl,
                        width: 45,
                        height: 45,
                      )
                    : const Icon(Icons.sentiment_satisfied),
                title: Text(item.value),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuck Norris API'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              // Título
              const Text(
                'Piadas do Chuck Norris',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // GIF
              const SizedBox(height: 15),

              Image.asset(
                'assets/imgs/ChuckNorris.gif',
                height: 180,
              ),

              const SizedBox(height: 6),

              // Descrição
              const Text(
                'Pesquise ou gere uma piada do Chuck Norris.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Campo de pesquisa
              TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchJokes(),

                decoration: InputDecoration(
                  labelText: 'Digite uma palavra ou termo',
                  hintText: 'Ex.: dev, animal, movie...',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),

                  suffixIcon: IconButton(
                    onPressed: _searchJokes,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Botão pesquisar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : _searchJokes,
                  icon: const Icon(Icons.search),
                  label: const Text('PESQUISAR'),
                ),
              ),

              // Botão piada aleatória
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : _loadRandomJoke,
                  icon: const Icon(Icons.casino),
                  label: const Text('PIADA ALEATÓRIA'),
                ),
              ),

              // Botão categorias
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: loading ? null : _showCategories,
                  icon: const Icon(Icons.category),
                  label: const Text('CATEGORIAS'),
                ),
              ),

              const SizedBox(height: 16),

              // Carregamento
              if (loading)
                const CircularProgressIndicator()

              // Mensagem
              else if (message.isNotEmpty)
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),

              // Piada retornada
              if (joke != null)
                _buildJokeCard(joke!),

              // Resultados da pesquisa
              _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }
}