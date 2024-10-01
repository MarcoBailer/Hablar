import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'auth/login_screen.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// O Widget que configura sua aplicação.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (BuildContext context, SettingsController settingsController,
          Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',

          // Configurações de localização
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // Inglês, sem código de país
          ],

          // Define o título do aplicativo com base na localização
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define o tema e o modo escuro com base nas configurações
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Configura as rotas do aplicativo
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  default:
                    return const LoginScreen();
                }
              },
            );
          },
        );
      },
    );
  }
}
