import 'package:eco_bites/core/constants/storage_keys.dart';
import 'package:eco_bites/features/splash/presentation/bloc/splash_event.dart';
import 'package:eco_bites/features/splash/presentation/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<SplashState> emit,
  ) async {
    // Retrieve authentication status and user ID from local storage
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? userId = pref.getString(StorageKeys.userId);

    if (userId != null && userId.isNotEmpty) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }
}
