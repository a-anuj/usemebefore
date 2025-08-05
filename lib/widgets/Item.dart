class Item {
  final String title;
  final String expiryDate;
  final String storage;
  final String note;
  final String imageUrl;

  Item({
    required this.title,
    required this.expiryDate,
    required this.storage,
    required this.note,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'expiryDate': expiryDate,
      'storage': storage,
      'note': note,
      'imageUrl': imageUrl,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      expiryDate: json['expiryDate'],
      storage: json['storage'],
      note: json['note'],
      imageUrl: json['imageUrl'],
    );
  }
}
