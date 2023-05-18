class Note {
  final int id;
  final String title;
  final String desc;
  final DateTime createdAt;

  Note(this.id, this.title, this.desc, this.createdAt);

  factory Note.fromMap(Map<String, dynamic> data) => Note(
        data['id'],
        data['title'],
        data['desc'],
        DateTime.parse(data['createdAt']),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'desc': desc,
    'createdAt': createdAt.toIso8601String(),
  };
}
