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
    // Simulate a delay for the splash screen
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Retrieve authentication status from local storage
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final bool isAuthenticated = pref.getBool('isAuthenticated') ?? false;

    if (isAuthenticated) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }
}
