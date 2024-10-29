import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this.connectivity);

  final Connectivity connectivity;

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results =
        await connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map(
      (List<ConnectivityResult> results) =>
          results.isNotEmpty && !results.contains(ConnectivityResult.none),
    );
  }
}
