import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/api/api_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/product_dto.dart';

sealed class ProductRemoteDataSource {
  Future<List<ProductDto>> fetchProduct();
  Future<void> createProduct(ProductDto model);
  Future<void> updateProduct(ProductDto model);
  Future<void> deleteProduct(ProductDto model);
}



final products = FirebaseFirestore.instance.collection("products");


class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiHelper _helper;

  const ProductRemoteDataSourceImpl(this._helper);

  @override
  Future<List<ProductDto>> fetchProduct() => fetchProductFromUrl("");

  Future<List<ProductDto>> fetchProductFromUrl(String url) async {
    try {
      // final response = await _helper.execute(method: Method.get, url: url);
      log(_helper.toString());
      final response = await products.get();

      return ProductDto.fromJsonList(response.docs
          .map((e) => {
                "product_id": e.id,
                "name": e.data()["name"],
                "price": e.data()["price"],
              })
          .toList());
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> createProduct(ProductDto model) async {
    // static const products = "/products";
  
   
    try {
      // await _helper.execute(
      //   method: Method.post,
      //   url: "ApiUrl.products",
      //   data: {},
      // );
      await products.add(model.toMap());
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(ProductDto model) async {
    try {
      await products.doc(model.productId).delete();
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductDto model) async {
    try {
      await products.doc(model.productId).update(model.toMap());
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }
}
