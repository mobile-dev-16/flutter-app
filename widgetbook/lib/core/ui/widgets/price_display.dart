import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:eco_bites/core/ui/widgets/price_display.dart';

@widgetbook.UseCase(name: 'Default', type: PriceDisplay)
Widget buildPriceDisplayUseCase(BuildContext context) {
  return const Center(
    child: PriceDisplay(
      normalPrice: 1000,
      offerPrice: 800,
    ),
  );
}
