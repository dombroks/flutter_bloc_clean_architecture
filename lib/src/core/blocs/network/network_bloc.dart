import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_ca/src/configs/injector/injector.dart';

import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc(this.networkInfo) : super(NetworkInitialState()) {
    on<NetworkCheckEvent>(_onNetworkCheck);
  }

  final NetworkInfo networkInfo;

  Future<void> _onNetworkCheck(
      NetworkCheckEvent event, Emitter<NetworkState> emit) async {
    final isConnected = await networkInfo.isConnnectedToNetwork;

    if (isConnected) {
      emit(NetworkConnectedState());
    } else {
      emit(NetworkDisconnectedState());
    }

    networkInfo.setIsConnected = isConnected;
  }
}
