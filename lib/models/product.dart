class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image; // path ของรูปใน assets เช่น assets/images/1.png
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    required this.image,
  });
}