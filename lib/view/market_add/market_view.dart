import 'package:flutter/material.dart';
import 'package:savoria_test/components/app_button.dart';
import 'package:savoria_test/components/app_colors.dart';
import 'package:savoria_test/data/core/market_database.dart';
import 'package:savoria_test/data/model/market_data_model.dart';
import 'package:savoria_test/view/market/widget/market_card.dart';
import 'package:savoria_test/view/market_add/add_market_view.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  List<MarketDataModel?> markets = [];
  final MarketDB _sqlite = MarketDB();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarket();
  }

  Future<void> getMarket() async {
    final data = await _sqlite.getMarkets();
    List<MarketDataModel?> market = data.map((e) => MarketDataModel.fromJson(e)).toList();
    markets = market;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DAFTAR TOKO', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          markets.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 25),
                  onPressed: () async {
                    var data = await Navigator.pushNamed(context, '/market-add');
                    if (data != null) {
                      getMarket();
                    }
                  },
                )
              : const SizedBox(),
        ],
        backgroundColor: AppColor.primary,
      ),
      body: markets.isNotEmpty
          ? RefreshIndicator.adaptive(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                await getMarket();
              },
              backgroundColor: AppColor.primary,
              color: Colors.white,
              child: ListView.separated(
                itemCount: markets.length,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  MarketDataModel? market = markets[index];
                  return MarketCard(
                    outletName: market?.marketName ?? '',
                    areaName: market?.marketAddress ?? '',
                    outletAddress: market?.marketCode ?? '',
                    isActive: true,
                    photo: market?.photoPath ?? '',
                    latitude: market?.latitudeLongitude ?? '',
                    canEdit: true,
                    onTap: () async {
                      var data =
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddMarketView(market: market)));
                      if (data != null) {
                        await getMarket();
                      }
                    },
                  );
                },
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/empty.jpg", width: 250),
                  const SizedBox(height: 10),
                  const Text('Belum ada data toko', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 20),
                  AppButton.elevated(
                    onTap: () async {
                      var data = await Navigator.pushNamed(context, '/market-add');
                      if (data != null) {
                        getMarket();
                      }
                    },
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
