import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/database/database.dart';
import 'core/navigation_handler.dart';
import 'core/navigation_service.dart';
import 'core/route_name.dart';
import 'core/routes.dart';
import 'screens/canvas/view_models/canvas_view_model.dart';
import 'screens/home/view_models/home_view_model.dart';
import 'theme/app_theme.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = Database.instance();
  var homeVM = HomeViewModel(db);
  await db.initialize();
  await homeVM.fetchAllCanvases();
  runApp(MeowMural(db, homeVM));
}

class MeowMural extends StatelessWidget {
  const MeowMural(this.db, this.homeVM, {super.key});
  final Database db;
  final HomeViewModel homeVM;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CanvasViewModel(db),
        ),
        ChangeNotifierProvider(
          create: (_) => homeVM,
        ),
        Provider<NavigationHandler>(
          create: (_) => NavigationHandler(),
        ),
      ],
      builder: (_, __) => MaterialApp(
        title: 'Meow Mural',
        debugShowCheckedModeBanner: false,
        initialRoute: RouteName.home,
        onGenerateRoute: Routes.generate,
        navigatorObservers: [routeObserver],
        scaffoldMessengerKey: NavigationService.messengerKey,
        navigatorKey: NavigationService.navigatorKey,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
      ),
    );
  }
}
