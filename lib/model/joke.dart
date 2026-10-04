class Joke {
  String id;
  String value;
  String iconUrl;
  String url;
  List<String> categories;

  Joke({
    required this.id,
    required this.value,
    required this.iconUrl,
    required this.url,
    required this.categories,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    List<String> listaCategorias = [];

    if (json['categories'] != null) {
      listaCategorias = List<String>.from(json['categories']);
    }

    return Joke(
      id: json['id'] ?? '',
      value: json['value'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      url: json['url'] ?? '',
      categories: listaCategorias,
    );
  }
}
