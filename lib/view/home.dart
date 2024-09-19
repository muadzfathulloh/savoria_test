import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:savoria_test/components/app_button.dart';
import 'package:savoria_test/components/app_colors.dart';
import 'package:savoria_test/components/constant.dart';
import 'package:savoria_test/data/model/market_model.dart';
import 'package:savoria_test/service/dio_client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MarketModel> markets = [];
  DioClient dioClient = const DioClient(baseUrl);

  Future<List<MarketModel>> getMarkets() async {
    final dio = dioClient.create();

    try {
      final res = await dio.get(baseUrl);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return (json.decode(res.data)['data'] as List).map((e) => MarketModel.fromJson(e)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img_bg.jpg'),
            const Text(
              'SAVORIA',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: AppColor.secondary),
            ),
            const SizedBox(height: 20),
            const Text(
              'Platform yang selalu membantu anda dalam pendataan toko dan produk',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppColor.primary),
            ),
            const SizedBox(height: 30),
            AppButton.elevated(
              // onTap: () => Navigator.pushNamed(context, '/market-list', arguments: markets),
              onTap: () async {
                markets = await getMarkets();
                setState(() {});
                Navigator.pushNamed(context, '/market-list', arguments: markets);
              },
              text: 'DAFTAR TOKO',
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            const SizedBox(height: 5),
            AppButton.outlined(
              onTap: () => Navigator.pushNamed(context, '/market'),
              text: 'TAMBAH TOKO',
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ],
        ),
      ),
    );
  }
}
