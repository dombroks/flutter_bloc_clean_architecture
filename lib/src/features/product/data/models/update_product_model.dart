import '../../domain/entities/product.dart';

class UpdateProductModel extends Product {
  const UpdateProductModel({
    required String productId,
    required String name,
    required int price,
  }) : super(productId: productId, name: name, price: price);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
    };
  }
}
