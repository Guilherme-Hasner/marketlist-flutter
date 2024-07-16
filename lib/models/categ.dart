class Categ {
  final String title;
  final String? description;
  final String? imgPath;

  const Categ({required this.title, this.description, this.imgPath});

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'imgPath': imgPath,
      };

  static Categ fromJson(Map<String, dynamic> json) {
    return Categ(
      title: json['title'],
      description: json['description'],
      imgPath: json['imgPath'],
    );
  }
}
