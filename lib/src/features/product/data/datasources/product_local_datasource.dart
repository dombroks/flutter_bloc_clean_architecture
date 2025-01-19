import 'package:flutter_bloc_ca/src/core/utils/logger.dart';

import '../../../../core/cache/local_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_dto.dart';

sealed class ProductLocalDataSource {
  Future<List<ProductDto>> getAllProduct();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final LocalStorage _localStorage;
  const ProductLocalDataSourceImpl(this._localStorage);

  @override
  Future<List<ProductDto>> getAllProduct() async {
    try {
      final response = await _localStorage.load(
        key: "products",
        boxName: "cache",
      );

      return ProductDto.fromMapList(response);
    } catch (e) {
      logger.e(e);
      throw CacheException();
    }
  }
}
