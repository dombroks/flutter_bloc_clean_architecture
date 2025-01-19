import '../../domain/entities/product.dart';

class DeleteProductModel extends Product {
  const DeleteProductModel({
    required String productId,
  }) : super(productId: productId);
}
