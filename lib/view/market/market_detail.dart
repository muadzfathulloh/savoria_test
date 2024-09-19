import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:savoria_test/components/app_button.dart';
import 'package:savoria_test/data/model/market_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/app_colors.dart';

class MarketDetail extends StatelessWidget {
  const MarketDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final market = ModalRoute.of(context)!.settings.arguments as MarketModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("DETAIL TOKO", style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                market.photo ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Status: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextSpan(
                    text: market.activeFlag ?? false ? 'Buka' : 'Tutup',
                    style: TextStyle(fontSize: 16, color: market.activeFlag ?? false ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Nama Toko: \t', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextSpan(text: market.outletName ?? '', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Alamat: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextSpan(text: market.outletAddress ?? '', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Area: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextSpan(text: market.areaName ?? '', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Dibangun pada: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  // MAKE IT HH-MMM-YYYY by DateTime
                  TextSpan(
                      text: DateFormat('d MMMM yyyy').format(DateTime.parse(market.createdAt ?? "2024-09-19 19:19:00")),
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            //dibangun oleh
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Dibangun oleh: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextSpan(text: market.createdBy.toString(), style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const Spacer(),
            AppButton.elevated(
              onTap: () async {
                //open wit package url_launcher
                final url = 'https://www.google.com/maps/search/?api=1&query=${market.latitude},${market.longtitude}';
                launchUrl(Uri.parse(url)).catchError((error) => Fluttertoast.showToast(msg: 'Gagal membuka Maps'));
              },
              text: 'LIHAT LOKASI',
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ],
        ),
      ),
    );
  }
}
