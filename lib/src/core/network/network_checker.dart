import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../errors/failures.dart';

typedef EitherNetwork<T> = Future<Either<Failure, T>> Function();

class NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  NetworkInfo(this._connectionChecker);

  bool _isConnected = true;

  set setIsConnected(bool val) => _isConnected = val;
  bool get getIsConnected => _isConnected;

  Future<Either<Failure, T>> check<T>({
    required EitherNetwork<T> connected,
    required EitherNetwork<T> notConnected,
  }) async {
    final isConnected = await isConnnectedToNetwork;
    if (isConnected) {
      return connected.call();
    } else {
      return notConnected.call();
    }
  }

  Future<bool> get isConnnectedToNetwork async =>
      await _connectionChecker.hasConnection;


  
}
