import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/core/ui/widgets/bottom_navbar.dart';

@widgetbook.UseCase(name: 'Default', type: BottomNavbar)
Widget buildBottomNavbarUseCase(BuildContext context) {
  return BottomNavbar(currentIndex: 0, onTap: (index) => {});
}
