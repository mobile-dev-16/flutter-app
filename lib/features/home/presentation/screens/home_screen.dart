import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_bites/features/home/presentation/bloc/home_bloc.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_bloc.dart';
import 'package:eco_bites/features/address/presentation/screens/address_screen.dart';
import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  void _navigateToAddressScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address section
                  GestureDetector(
                    onTap: _navigateToAddressScreen,
                    child: BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, state) {
                        String address = 'Select your address';
                        if (state is CurrentAddressUpdated) {
                          address = state.address.fullAddress;
                        }
                        return Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                address,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (query) {
                      context.read<HomeBloc>().add(SearchQueryChanged(query));
                    },
                  ),
                  SizedBox(height: 16),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Nearby'),
                      Tab(text: 'Popular'),
                      Tab(text: 'Recent'),
                      Tab(text: 'Recommended'),
                    ],
                  ),
                  // Tab view
                  SizedBox(
                    height: 300, // Adjust this height as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Center(child: Text('All Content')),
                        Center(child: Text('Nearby Content')),
                        Center(child: Text('Popular Content')),
                        Center(child: Text('Recent Content')),
                        Center(child: Text('Recommended Content')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
