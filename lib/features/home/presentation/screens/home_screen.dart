import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0), // Add padding to the top
          child: Column(
            children: [
              // Title with Icon
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Symbols.location_on_rounded, fill: 1),
                    const SizedBox(width: 8),
                    Text(
                      'Calle 13 #12-34',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
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
                ),
              ),
              SizedBox(height: 16),
              // Carousel
              Container(
                height: 200,
                color: Colors.grey[300], // Placeholder for carousel
                child: Center(child: Text('Carousel Placeholder')),
              ),
              SizedBox(height: 16),
              // Tab Bar
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Tab 1'),
                        Tab(text: 'Tab 2'),
                        Tab(text: 'Tab 3'),
                      ],
                    ),
                    Container(
                      height: 200, // Placeholder for tab content
                      child: TabBarView(
                        children: [
                          Center(child: Text('Content 1')),
                          Center(child: Text('Content 2')),
                          Center(child: Text('Content 3')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Card Lists
              Container(
                height: 400, // Set a fixed height for the ListView
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('Card 1'),
                        subtitle: Text('Subtitle 1'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Card 2'),
                        subtitle: Text('Subtitle 2'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Card 3'),
                        subtitle: Text('Subtitle 3'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
