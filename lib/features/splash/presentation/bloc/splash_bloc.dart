import 'package:eco_bites/features/splash/presentation/bloc/splash_event.dart';
import 'package:eco_bites/features/splash/presentation/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<SplashState> emit,
  ) async {
    // TODO(1): Implement the authentication
    // ignore: always_specify_types
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO(2): Replace the following line with the actual authentication logic

    const bool isAuthenticated = true;

    if (isAuthenticated) {
      emit(Authenticated());
    }
    // else {
    //   emit(Unauthenticated());
    // }
  }
}
