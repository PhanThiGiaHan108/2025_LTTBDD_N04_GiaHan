import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/logo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      saveLocale: true,

      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'lib/lang',
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      child: const ChicktionaryApp(),
    ),
  );
}

class ChicktionaryApp extends StatelessWidget {
  const ChicktionaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicktionary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFDE5)),
      home: const Logo(),

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
