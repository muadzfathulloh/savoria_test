import 'package:flutter/material.dart';
import 'package:savoria_test/components/app_colors.dart';

class MarketCard extends StatelessWidget {
  const MarketCard(
      {super.key,
      required this.outletName,
      required this.outletAddress,
      required this.areaName,
      required this.photo,
      required this.isActive,
      this.onTap});
  final String outletName;
  final String outletAddress;
  final String areaName;
  final String photo;
  final bool isActive;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          onTap?.call();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Toko sedang tutup'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
                label: "Tetap Buka",
                textColor: AppColor.primary,
                onPressed: () {
                  onTap?.call();
                }),
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))]
              : [],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    photo,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(color: Colors.black));
                    },
                  ),
                ),
                isActive
                    ? const SizedBox()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(outletName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isActive ? Colors.black : Colors.grey)),
                  Text.rich(
                    TextSpan(
                      text: 'Status: ',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: isActive ? 'Buka' : 'Tutup',
                          style: TextStyle(fontSize: 14, color: isActive ? Colors.green : Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(outletAddress, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(areaName, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
