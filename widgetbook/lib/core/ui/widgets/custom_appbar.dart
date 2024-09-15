import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';

@widgetbook.UseCase(name: 'Default', type: CustomAppBar)
Widget buildCustomAppBarUseCase(BuildContext context) {
  return const CustomAppBar(title: 'AppBar');
}

@widgetbook.UseCase(name: 'With Back Button', type: CustomAppBar)
Widget buildCustomAppBarWithBackButtonUseCase(BuildContext context) {
  return const CustomAppBar(title: 'AppBar', showBackButton: true);
}