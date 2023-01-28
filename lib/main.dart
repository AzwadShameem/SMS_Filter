import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/constants.dart';
import 'package:spam_filter/provider/InboxMessageProvider.dart';
import 'package:spam_filter/provider/MessageProvider.dart';
import 'package:spam_filter/provider/SearchProvider.dart';
import 'package:spam_filter/provider/settingProvider.dart';
import 'package:spam_filter/provider/statusProvider.dart';
import 'package:spam_filter/screens/home_page.dart';
import 'package:spam_filter/screens/inbox_screen.dart';
import 'package:spam_filter/screens/search_screen.dart';
import 'package:spam_filter/screens/setting_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MessageProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => InboxMessageProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SearchProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => StatusProvider(),
      ),
      ChangeNotifierProvider(
          create: (_) => SettingProvider()
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
          primaryColor: kPrimaryColor,
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: kPrimaryColor)),
      home: const InboxScreen(),
      onGenerateRoute: generateRoute,
      routes: {
        SettingScreen.id: (context) => const SettingScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        HomePage.id: (context) => const HomePage(),
        InboxScreen.id: (context) => const InboxScreen(),
      },
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (_) => const HomePage());

      case "/search":
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case "/setting":
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
