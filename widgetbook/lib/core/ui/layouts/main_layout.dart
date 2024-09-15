import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/core/ui/layouts/main_layout.dart';

@widgetbook.UseCase(name: 'Home', type: MainLayout)
Widget buildMainLayoutUseCase(BuildContext context) {
  return const MainLayout();
}
