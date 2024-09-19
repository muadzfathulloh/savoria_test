import 'package:flutter/material.dart';
import 'package:savoria_test/components/app_colors.dart';
import 'package:savoria_test/data/model/market_model.dart';
import 'package:savoria_test/view/market/widget/market_card.dart';

class MarketList extends StatefulWidget {
  const MarketList({super.key});

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  @override
  Widget build(BuildContext context) {
    final markets = ModalRoute.of(context)!.settings.arguments as List<MarketModel>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DAFTAR TOKO', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: markets.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            return MarketCard(
              onTap: () {
                Navigator.pushNamed(context, '/market-detail', arguments: markets[index]);
              },
              outletName: markets[index].outletName ?? '',
              outletAddress: markets[index].outletAddress ?? '',
              areaName: markets[index].areaName ?? '',
              photo: markets[index].photo ??
                  'https://asset-2.tstatic.net/babel/foto/bank/images/Toko-kelontong-di-Pangkalpinang.jpg',
              isActive: markets[index].activeFlag ?? false,
            );
          },
        ),
      ),
    );
  }
}
