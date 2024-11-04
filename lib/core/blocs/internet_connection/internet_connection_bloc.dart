import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

part 'internet_connection_event.dart';
part 'internet_connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  InternetConnectionBloc() : super(InternetConnectionInitial()) {
    on<ConnectedEvent>(
        (ConnectedEvent event, Emitter<InternetConnectionState> emit) {
      Logger().d('Connected to the internet');
      emit(
        const ConnectedInternet(
          message: 'Connected to the internet',
        ),
      );

      // Show toast for connected state
      Fluttertoast.showToast(
        msg: 'Connected to the internet',
        toastLength: Toast.LENGTH_SHORT,
      );
    });

    on<DisconnectedEvent>(
        (DisconnectedEvent event, Emitter<InternetConnectionState> emit) {
      Logger().e('Disconnected from the internet');
      Fluttertoast.showToast(
        msg: 'No internet connection. Some information may not be up to date.',
        toastLength: Toast.LENGTH_LONG,
      );
      emit(
        const DisconnectedInternet(
          message:
              'No internet connection. Some information may not be up to date.',
        ),
      );
    });

    _internetConnectionStream = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        if (results.contains(ConnectivityResult.none)) {
          add(DisconnectedEvent());
        } else {
          add(ConnectedEvent());
        }
      },
    );
  }
  StreamSubscription<List<ConnectivityResult>>? _internetConnectionStream;

  @override
  Future<void> close() {
    _internetConnectionStream?.cancel();
    return super.close();
  }
}
