part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.selectedTabIndex = 0,
    this.searchQuery = '',
  });
  final int selectedTabIndex;
  final String searchQuery;

  HomeState copyWith({
    int? selectedTabIndex,
    String? searchQuery,
  }) {
    return HomeState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => <Object>[selectedTabIndex, searchQuery];
}

class HomeInitial extends HomeState {}
