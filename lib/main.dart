import 'package:flutter/material.dart';
import 'package:savoria_test/data/core/market_database.dart';
import 'package:savoria_test/view/home.dart';
import 'package:savoria_test/view/market/market_detail.dart';
import 'package:savoria_test/view/market/market_list.dart';
import 'package:savoria_test/view/market_add/add_market_view.dart';
import 'package:savoria_test/view/market_add/market_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize sHared preferences
  await MarketDB().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        //soal 1
        '/market-list': (context) => const MarketList(),
        '/market-detail': (context) => const MarketDetail(),
        //soal 2
        '/market': (context) => const MarketView(),
        '/market-add': (context) => const AddMarketView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
