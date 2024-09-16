import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/features/cart/presentation/widgets/quantity_input.dart';

@widgetbook.UseCase(name: 'Default', type: QuantityInput)
Widget buildQuantityInputUseCase(BuildContext context) {
  return Center(
    child: QuantityInput(
      initialValue: 1,
      onChanged: (value) {},
    ),
  );
}

@widgetbook.UseCase(name: 'With Custom Values', type: QuantityInput)
Widget buildQuantityInputCustomValuesUseCase(BuildContext context) {
  return Center(
    child: QuantityInput(
      initialValue: 12,
      onChanged: (value) {},
    ),
  );
}
