class ScriptModel {
  final String id;
  final String title;
  final String? description;
  final double price;
  final String downloadUrl;
  final String type;

  ScriptModel({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.downloadUrl,
    required this.type,
  });

  factory ScriptModel.fromJson(Map<String, dynamic> json) {
    return ScriptModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      downloadUrl: json['downloadUrl'] ?? '',
      type: json['type'] ?? 'free',
    );
  }
}
