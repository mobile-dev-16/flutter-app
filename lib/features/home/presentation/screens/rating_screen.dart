import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.restaurantName});

  final String restaurantName;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 3.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rate this Restaurant',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Rating:',
              style: theme.textTheme.titleMedium,
            ),
            Slider(
              value: _rating,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (double value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Comments:',
              style: theme.textTheme.titleMedium,
            ),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your comments here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitRating(context);
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating(BuildContext context) {
    final String comment = _commentController.text.trim();

    // Perform the rating submission logic here
    // For example, send the data to the server

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rating submitted!')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
