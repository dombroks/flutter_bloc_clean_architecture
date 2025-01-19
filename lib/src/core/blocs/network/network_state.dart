import 'package:equatable/equatable.dart';

abstract class NetworkState extends Equatable {
  @override
  List<Object> get props => [];
}

class NetworkInitialState extends NetworkState {}

class NetworkConnectedState extends NetworkState {}

class NetworkDisconnectedState extends NetworkState {}
