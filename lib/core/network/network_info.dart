import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eco_bites/core/blocs/internet_connection/internet_connection_bloc.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(
    this.connectivity,
    this.internetConnectionBloc,
  );

  final Connectivity connectivity;
  final InternetConnectionBloc internetConnectionBloc;

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results =
        await connectivity.checkConnectivity();
    final bool isConnected =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    // Emit corresponding event based on connection status
    if (isConnected) {
      internetConnectionBloc.add(ConnectedEvent());
    } else {
      internetConnectionBloc.add(DisconnectedEvent());
    }

    return isConnected;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map(
      (List<ConnectivityResult> results) {
        final bool isConnected =
            results.isNotEmpty && !results.contains(ConnectivityResult.none);

        // Emit corresponding event based on connection status
        if (isConnected) {
          internetConnectionBloc.add(ConnectedEvent());
        } else {
          internetConnectionBloc.add(DisconnectedEvent());
        }

        return isConnected;
      },
    );
  }
}
