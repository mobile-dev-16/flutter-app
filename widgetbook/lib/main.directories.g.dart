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
import 'package:widgetbook_workspace/features/auth/presentation/screens/login_screen.dart'
    as _i5;
import 'package:widgetbook_workspace/features/cart/presentation/screens/cart_screen.dart'
    as _i6;
import 'package:widgetbook_workspace/features/home/presentation/screens/home_screen.dart'
    as _i7;
import 'package:widgetbook_workspace/features/orders/presentation/screens/order_list_screen.dart'
    as _i8;
import 'package:widgetbook_workspace/features/profile/presentation/screens/profile_screen.dart'
    as _i9;
import 'package:widgetbook_workspace/features/splash/presentation/screens/splash_screen.dart'
    as _i10;

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
              _i1.WidgetbookComponent(
                name: 'CustomAppBar',
                useCases: [
                  _i1.WidgetbookUseCase(
                    name: 'Default',
                    builder: _i4.buildCustomAppBarUseCase,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'With Back Button',
                    builder: _i4.buildCustomAppBarWithBackButtonUseCase,
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'features',
    children: [
      _i1.WidgetbookFolder(
        name: 'auth',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'screens',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'LoginScreen',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i5.buildLoginScreenUseCase,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'cart',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'screens',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'CartScreen',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i6.buildCartScreenUseCase,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'home',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'screens',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'HomeScreen',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i7.buildHomeScreenUseCase,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'orders',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'screens',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'OrderListScreen',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i8.buildOrderListScreenUseCase,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'profile',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'screens',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'ProfileScreen',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i9.buildProfileScreenUseCase,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'splash',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'screens',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'SplashScreen',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i10.buildSplashScreenUseCase,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    ],
  ),
];
