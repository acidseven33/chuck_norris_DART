# Chuck Norris API — Flutter

Projeto simples para o trabalho prático de Flutter + API + imagens/GIFs.

## Estrutura

```text
lib/
├── main.dart
├── model/
│   └── joke.dart
├── service/
│   └── chuck_norris_service.dart
└── view/
    └── home_page.dart

assets/
└── imgs/
    └── README.txt
```

A estrutura segue a ideia trabalhada nos materiais de aula:
- `service/`: comunicação com a API;
- `view/`: telas e interface;
- `model/`: representação dos dados;
- `main.dart`: ponto de entrada.

## API utilizada

A aplicação usa diretamente a Chuck Norris API:

- `/jokes/random`
- `/jokes/random?category=...`
- `/jokes/categories`
- `/jokes/search?query=...`

Não é necessário colocar chave do RapidAPI neste projeto.

## Funcionalidades

1. Campo de pesquisa + botão Pesquisar.
2. Botão Piada Aleatória.
3. Botão Categorias.
4. Validação de pesquisa vazia.
5. Tratamento de erro de conexão/API.
6. Processamento de JSON com `json.decode`.
7. Exibição da imagem retornada pela API com `Image.network`.

## Como executar

Dentro da pasta do projeto:

```bash
flutter pub get
flutter run
```

Se você criar um projeto Flutter novo e copiar estes arquivos, substitua o conteúdo de `lib/` e o `pubspec.yaml`.

## Imagem/GIF próprio

A pasta `assets/imgs/` está preparada para você colocar uma imagem ou GIF próprio depois.

O projeto já exibe dinamicamente o `icon_url` retornado pela própria API, então ele funciona mesmo sem adicionar outro arquivo.
