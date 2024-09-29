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
            children: <Widget>[
              // Title with Icon
              Padding(
                padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 8),
              // Carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: CarouselView(
                      itemExtent: 330,
                      shrinkExtent: 200,
                      children: <Widget>[
                        Image.asset('assets/carousel/50off.jpeg',
                            fit: BoxFit.cover),
                        Image.asset('assets/carousel/free-delivery.jpeg',
                            fit: BoxFit.cover),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Tab Bar
              DefaultTabController(
                length: 3,
                child: Column(
                  children: <Widget>[
                    const TabBar(
                      tabs: <Widget>[
                        Tab(text: 'Tab 1'),
                        Tab(text: 'Tab 2'),
                        Tab(text: 'Tab 3'),
                      ],
                    ),
                    Container(
                      height: 200, // Placeholder for tab content
                      child: const TabBarView(
                        children: <Widget>[
                          Center(child: Text('Content 1')),
                          Center(child: Text('Content 2')),
                          Center(child: Text('Content 3')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Card Lists
              Container(
                height: 400, // Set a fixed height for the ListView
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: const <Widget>[
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

class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.5),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
    );
  }
}
