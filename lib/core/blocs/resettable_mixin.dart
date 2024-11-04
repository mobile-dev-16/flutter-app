import 'package:flutter_bloc/flutter_bloc.dart';

/// A mixin that provides reset functionality for Blocs
mixin ResettableMixin<Event, State> on Bloc<Event, State> {
  /// Resets the bloc to its initial state
  void reset();
}
