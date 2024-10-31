class Journal{
  final String id;
  final String content;
  final int rate;

  const Journal({
    required this.id,
    required this.content,
    required this.rate,
  });

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
    id: json['id'],
    content: json['content'],
    rate: json['rate'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'rate': rate,
  };
}