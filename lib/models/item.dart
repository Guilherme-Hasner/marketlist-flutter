class Item {
  final String categ;
  final String title;
  final String? description;
  final double price;
  final int quant;
  final String? imgPath;

  const Item({
    required this.categ,
    required this.title,
    this.description,
    required this.price,
    required this.quant,
    this.imgPath,
  });

  Map<String, dynamic> toJson() => {
        'categ': categ,
        'title': title,
        'description': description,
        'price': price,
        'quant': quant,
        'imgPath': imgPath,
      };

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      categ: json['categ'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      quant: json['quant'],
      imgPath: json['imgPath'],
    );
  }
}
