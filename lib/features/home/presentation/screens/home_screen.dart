import 'package:eco_bites/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      context.read<HomeBloc>().add(TabChanged(_tabController.index));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
          child: Column(
            children: <Widget>[
              // Title with Icon
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Symbols.location_on_rounded,
                      fill: 1,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Calle 13 #12-34',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search deals...',
                  suffixIcon: const Icon(Symbols.search_rounded, fill: 1),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  fillColor: theme.colorScheme.surfaceContainerHigh,
                  filled: true,
                ),
                onChanged: (String query) {
                  context.read<HomeBloc>().add(SearchQueryChanged(query));
                },
              ),
              const SizedBox(height: 16),
              // Carousel
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: CarouselView(
                    itemExtent: 330,
                    shrinkExtent: 200,
                    children: <Widget>[
                      Image.asset(
                        'assets/carousel/50off.jpeg',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/carousel/free-delivery.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Tab Bar
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (HomeState previous, HomeState current) =>
                    previous.selectedTabIndex != current.selectedTabIndex,
                builder: (BuildContext context, HomeState state) {
                  return Column(
                    children: <Widget>[
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: <Widget>[
                          _buildTab(
                            Symbols.fastfood_rounded,
                            'Restaurant',
                            0,
                            state.selectedTabIndex,
                          ),
                          _buildTab(
                            Symbols.nutrition_rounded,
                            'Ingredients',
                            1,
                            state.selectedTabIndex,
                          ),
                          _buildTab(
                            Symbols.store_rounded,
                            'Store',
                            2,
                            state.selectedTabIndex,
                          ),
                          _buildTab(
                            Symbols.bakery_dining,
                            'Diary',
                            3,
                            state.selectedTabIndex,
                          ),
                          _buildTab(
                            Symbols.local_cafe_rounded,
                            'Drink',
                            4,
                            state.selectedTabIndex,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: TabBarView(
                          controller: _tabController,
                          children: const <Widget>[
                            Center(child: Text('Restaurant Content')),
                            Center(child: Text('Ingredients Content')),
                            Center(child: Text('Store Content')),
                            Center(child: Text('Diary Content')),
                            Center(child: Text('Drink Content')),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int index, int selectedIndex) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            fill: selectedIndex == index ? 1 : 0,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
