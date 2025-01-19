import 'package:fpdart/fpdart.dart';

import '../../../../core/cache/local_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_checker.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/usecase_params.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_dto.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final LocalStorage _localStorage;
  const ProductRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
    this._localStorage,
  );

  @override
  Future<Either<Failure, void>> create(CreateProductParams params) async {
    try {
      final model = ProductDto(
        name: params.name,
        price: params.price,
      );

      final result = await _remoteDataSource.createProduct(model);

      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAll() {
    return _networkInfo.check<List<Product>>(
      connected: () async {
        try {
          final listProduct = await _remoteDataSource.fetchProduct();

          await _localStorage.save(
            key: "products",
            value: ProductDto.toMapList(listProduct),
            boxName: "cache",
          );

          return Right(listProduct.map((e) => e.toDomain()).toList());
        } on ServerException {
          return Left(ServerFailure());
        }
      },
      notConnected: () async {
        try {
          final listProduct = await _localDataSource.getAllProduct();

          return Right(listProduct.map((e) => e.toDomain()).toList());
        } on CacheException {
          return Left(CacheFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> delete(DeleteProductParams params) async {
    try {
      final model = ProductDto(
        productId: params.productId,
      );

      final result = await _remoteDataSource.deleteProduct(model);

      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> update(UpdateProductParams params) async {
    try {
      final model = ProductDto(
        productId: params.productId,
        name: params.name,
        price: params.price,
      );

      final result = await _remoteDataSource.updateProduct(model);

      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
