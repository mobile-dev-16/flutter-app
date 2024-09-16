import 'package:eco_bites/core/utils/format_price.dart';
import 'package:flutter/material.dart';

class PriceDisplay extends StatelessWidget {
  const PriceDisplay({
    super.key,
    required this.offerPrice,
    required this.normalPrice,
  });
  static const String currency = 'COP';

  final double offerPrice;
  final double normalPrice;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${formatPrice(normalPrice.toInt())} $currency',
          style: theme.textTheme.bodySmall?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          '${formatPrice(offerPrice.toInt())} $currency',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSecondaryFixedVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
