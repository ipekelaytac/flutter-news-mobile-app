import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:news_mobile_project/screens/indexScreen.dart';
import 'package:news_mobile_project/screens/newsDetailScreen.dart';
import 'package:news_mobile_project/screens/newsScreen.dart';
import 'package:news_mobile_project/screens/ticket/messageTicketScreen.dart';
import 'package:news_mobile_project/screens/ticket/sendTicketScreen.dart';
import 'package:news_mobile_project/screens/ticket/ticketsScreen.dart';
import 'package:news_mobile_project/screens/user/loginScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:news_mobile_project/screens/user/registerScreen.dart';
import 'package:news_mobile_project/themes/themes.dart';
import 'bloc/settings/settings_cubit.dart';
import 'bloc/settings/settings_state.dart';
import 'localizations/localizations.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(initialLocation: '/kayitol', routes: [
  GoRoute(
    path: '/anasayfa',
    builder: (context, state) => indexScreen(),
  ),
  GoRoute(
    path: '/giris',
    builder: (context, state) => loginScreen(),
  ),
  GoRoute(
    path: '/kayitol',
    builder: (context, state) => registerScreen(),
  ),
  GoRoute(
    path: '/destektalebiolustur',
    builder: (context, state) => sendTicketScreen(),
  ),
  GoRoute(
    path: '/destekler',
    builder: (context, state) => ticketsScreen(),
  ),
  GoRoute(
    path: "/destekler/:ticketID",
    builder: (context, state) => messageTicketScreen(
      ticketID: state.pathParameters['ticketID']!,
    ),
  ),
  GoRoute(
    path: '/haberler',
    builder: (context, state) => newsScreen(),
  ),
  GoRoute(
    path: "/haberler/:newsID",
    builder: (context, state) => newsDetailScreen(
      newsID: state.pathParameters['newsID']!,
    ),
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsState()),
      child:
          BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
        return MaterialApp.router(
          routerConfig: _router,
          title: 'Haberler',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLanguages
              .map((e) => Locale(e, ""))
              .toList(),
          locale: Locale(state.language, ""),
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
        );
      }),
    );
  }
}
