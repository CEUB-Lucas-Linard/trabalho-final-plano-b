
class Deck {
  final int? id;
  final String title;

  Deck({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(id: map['id'], title: map['title']);
  }
}
