import 'package:flutter/material.dart';

class BasicImage extends StatelessWidget {
  const BasicImage({
    super.key,
    this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: _buildImage(theme, imageUrl),
    );
  }

  Widget _buildImage(ThemeData theme, String? imageUrl) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: 72,
        height: 72,
        color: theme.colorScheme.secondary,
        child: Icon(
          Icons.image,
          color: theme.colorScheme.onSecondary,
          size: 32,
        ),
      );
    }
  }
}
