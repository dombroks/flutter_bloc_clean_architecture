import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? productId;
  final String? name;
  final int? price;
  const Product({
    this.productId,
    this.name,
    this.price,
  });

  @override
  List<Object?> get props => [productId, name, price];
}
