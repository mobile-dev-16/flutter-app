part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => <Object>[];
}

class TabChanged extends HomeEvent {
  const TabChanged(this.index);
  final int index;

  @override
  List<Object> get props => <Object>[index];
}

class SearchQueryChanged extends HomeEvent {
  const SearchQueryChanged(this.query);
  final String query;

  @override
  List<Object> get props => <Object>[query];
}
