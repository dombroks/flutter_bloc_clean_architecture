import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../usecases/usecase_params.dart';

abstract class ProductRepository {
  Future<Either<Failure, void>> create(CreateProductParams params);
  Future<Either<Failure, void>> delete(DeleteProductParams params);
  Future<Either<Failure, List<Product>>> getAll();
  Future<Either<Failure, void>> update(UpdateProductParams params);
}
