import 'package:flutter/material.dart';
import 'package:pentungan_sari/page/page.dart';
import 'package:pentungan_sari/page/recreation/pool.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark 
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Pentungan Sari',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.lightGreen,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.lightGreen,
            selectionColor: Colors.lightGreen,
            selectionHandleColor: Colors.lightGreen
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: ResponsiveWrapper.builder(
              child,
              maxWidth: 16000,
              minWidth: 9000,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(848, name: TABLET),
                const ResponsiveBreakpoint.resize(1024, name: DESKTOP),
                const ResponsiveBreakpoint.resize(1600, name: '4K'),
              ]
            ),
          );
        },
        routes: {
          '/': (context) => const ContextPage(),
          '/recreation/pool': (context) => const PoolPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
