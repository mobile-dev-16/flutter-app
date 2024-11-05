import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

part 'internet_connection_event.dart';
part 'internet_connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  InternetConnectionBloc() : super(InternetConnectionInitial()) {
    on<ConnectedEvent>(_onConnected);
    on<DisconnectedEvent>(_onDisconnected);

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

  void _onConnected(
    ConnectedEvent event,
    Emitter<InternetConnectionState> emit,
  ) {
    // Only emit if we're not already in connected state
    if (state is! ConnectedInternet) {
      Logger().d('Connected to the internet');

      Fluttertoast.showToast(
        msg: 'Connected to the internet',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      emit(
        const ConnectedInternet(
          message: 'Connected to the internet',
        ),
      );
    }
  }

  void _onDisconnected(
    DisconnectedEvent event,
    Emitter<InternetConnectionState> emit,
  ) {
    // Only emit if we're not already in disconnected state
    if (state is! DisconnectedInternet) {
      Logger().e('Disconnected from the internet');

      Fluttertoast.showToast(
        msg: 'No internet connection. Some information may not be up to date.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      emit(
        const DisconnectedInternet(
          message:
              'No internet connection. Some information may not be up to date.',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _internetConnectionStream?.cancel();
    return super.close();
  }
}
