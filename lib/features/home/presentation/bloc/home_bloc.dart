import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<TabChanged>(_onTabChanged);
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onTabChanged(TabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
