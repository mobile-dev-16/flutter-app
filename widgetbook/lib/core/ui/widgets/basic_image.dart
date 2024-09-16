import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:eco_bites/core/ui/widgets/basic_image.dart';

@widgetbook.UseCase(name: 'Placeholder', type: BasicImage)
Widget buildBasicImageUseCase(BuildContext context) {
  return const Center(
    child: BasicImage(),
  );
}

@widgetbook.UseCase(name: 'With Image', type: BasicImage)
Widget buildBasicImageWithImageUseCase(BuildContext context) {
  return const Center(
    child: BasicImage(
      imageUrl: 'https://fastly.picsum.photos/id/1/250/250.jpg',
    ),
  );
}
