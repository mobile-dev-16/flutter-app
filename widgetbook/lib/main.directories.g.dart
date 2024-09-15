// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/core/ui/layouts/main_layout.dart' as _i2;
import 'package:widgetbook_workspace/core/ui/widgets/bottom_navbar.dart' as _i3;
import 'package:widgetbook_workspace/core/ui/widgets/custom_appbar.dart' as _i4;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'core',
    children: [
      _i1.WidgetbookFolder(
        name: 'ui',
        children: [
          _i1.WidgetbookFolder(
            name: 'layouts',
            children: [
              _i1.WidgetbookLeafComponent(
                name: 'MainLayout',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Home',
                  builder: _i2.buildMainLayoutUseCase,
                ),
              )
            ],
          ),
          _i1.WidgetbookFolder(
            name: 'widgets',
            children: [
              _i1.WidgetbookLeafComponent(
                name: 'BottomNavbar',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Default',
                  builder: _i3.buildBottomNavbarUseCase,
                ),
              ),
              _i1.WidgetbookLeafComponent(
                name: 'CustomAppBar',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Default',
                  builder: _i4.buildCustomAppBarUseCase,
                ),
              ),
            ],
          ),
        ],
      )
    ],
  )
];
