import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:eco_bites/core/config/theme.dart';
import 'package:eco_bites/core/utils/create_text_theme.dart';

import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {

    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);

    return Widgetbook.material(
      directories: directories,
      appBuilder: (context, child) => ColoredBox(
        color: theme.light().colorScheme.surface,
        child: child,
      ),
      addons: [
        DeviceFrameAddon(devices: [
          Devices.android.samsungGalaxyNote20,
          Devices.ios.iPhone13,
        ],
        initialDevice: Devices.android.samsungGalaxyNote20,
        ),
        InspectorAddon(),
        AlignmentAddon(),
        BuilderAddon(name: 'SafeArea', builder: (_,child) => SafeArea(child: child,))
      ],
      integrations: [
        WidgetbookCloudIntegration(),
      ],
      lightTheme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.light,
    );
  }
}
