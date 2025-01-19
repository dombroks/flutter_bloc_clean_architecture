import '../../domain/entities/product.dart';

class ProductDto {
  ProductDto({this.productId, required this.name, required this.price});

  final String? productId;
  final String name;
  final int price;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      productId: json["product_id"],
      name: json["name"],
      price: json["price"],
    );
  }

  static List<ProductDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductDto.fromJson(json)).toList();
  }

  factory ProductDto.fromMap(Map<dynamic, dynamic> map) {
    return ProductDto(
      productId: map["product_id"],
      name: map["name"],
      price: map["price"],
    );
  }

  static List<ProductDto> fromMapList(List<dynamic> mapList) {
    return mapList.map((json) => ProductDto.fromMap(json)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "product_id": productId,
      "name": name,
      "price": price,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<ProductDto> productList) {
    return productList.map((e) => e.toMap()).toList();
  }

  // Convert DTO to a domain model
  Product toDomain() {
    return Product(
      productId: productId,
      name: name,
      price: price,
    );
  }

  // Convert a domain model to DTO
  static ProductDto fromDomain(Product product) {
    return ProductDto(
      productId: product.productId,
      name: product.name!,
      price: product.price!,
    );
  }
}
