import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:savoria_test/components/app_button.dart';
import 'package:savoria_test/components/app_colors.dart';
import 'package:savoria_test/components/app_text_field.dart';
import 'package:savoria_test/data/core/market_database.dart';
import 'package:savoria_test/data/model/market_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMarketView extends StatefulWidget {
  const AddMarketView({super.key, this.market});
  final MarketDataModel? market;

  @override
  State<AddMarketView> createState() => _AddMarketViewState();
}

class _AddMarketViewState extends State<AddMarketView> {
  final MarketDB _sqlite = MarketDB();

  XFile? imagePicked;
  File? imageFile;
  GlobalKey<FormState> formKey = GlobalKey();
  SharedPreferences? prefs;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isUpdate = false;
  String? marketCode;

  @override
  void initState() {
    super.initState();
    if (widget.market != null) {
      isUpdate = true;
      nameController.text = widget.market!.marketName!;
      addressController.text = widget.market!.marketAddress!;
      marketCode = widget.market!.marketCode;
      imageFile = File(widget.market!.photoPath!);
      setState(() {});
    }
  }

  Future<XFile?> getImage() async {
    imagePicked = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {});
    return imagePicked;
  }

  Future<void> setImageName() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs!.getInt('count') ?? 0;
    count++;
    await prefs!.setInt('count', count);
    String formattedCount = count.toString().padLeft(4, '0');
    marketCode = 'MARKET_221024_$formattedCount';
    setState(() {});
  }

  Future<void> setImageToAppDocument(String path) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //to get path format png, jpg, jpeg
    String format = path.split('.').last;
    String localPath = '${appDocDir.path}/${marketCode ?? "undifined"}.$format';
    imageFile = await File(path).copy(localPath);
    setState(() {});
  }

  Future<bool> saveMarket() async {
    if (formKey.currentState!.validate()) {
      if (imagePicked == null && !isUpdate) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto toko tidak boleh kosong')));
        return false;
      }
      if (!isUpdate) {
        await setImageName();
        await setImageToAppDocument(imagePicked!.path);
      }
      if (isUpdate && imagePicked != null) {
        await setImageToAppDocument(imagePicked!.path);
      }
      MarketDataModel market = MarketDataModel(
        marketCode: marketCode,
        marketName: nameController.text,
        marketAddress: addressController.text,
        latitudeLongitude: "-6.4425166, 106.3904479",
        photo: imageFile!.path.split('/').last,
        photoPath: imageFile!.path,
        createdDate: DateTime.now().toLocal().toString(),
        updatedDate: DateTime.now().toLocal().toString(),
      );
      if (isUpdate) {
        await _sqlite.updateMarket(marketCode!, market.toJson());
        return true;
      } else {
        await _sqlite.insertMarket(market.toJson());
        return true;
      }
    }
    return false;
  }

  Future<void> dialogPhoto() async {
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(imageFile ?? File(imagePicked!.path)),
            const SizedBox(height: 10),
            AppButton.elevated(
              onTap: () async {
                imagePicked = await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
                  if (value != null) {
                    Navigator.pop(context);
                    return value;
                  }
                  return imagePicked;
                });
                setState(() {});
              },
              text: 'GANTI FOTO',
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${isUpdate ? 'UBAH' : 'TAMBAH'} TOKO', style: const TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            AppTextField(
              labelText: 'Nama Toko',
              hintText: 'Masukkan nama toko',
              controller: nameController,
              validator: (p0) => p0!.isEmpty ? 'Nama toko tidak boleh kosong' : null,
            ),
            const SizedBox(height: 10),
            AppTextField(
              labelText: 'Alamat Toko',
              hintText: 'Masukkan alamat toko',
              maxLines: 5,
              controller: addressController,
              validator: (p0) => p0!.isEmpty ? 'Alamat toko tidak boleh kosong' : null,
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text('* ', style: TextStyle(fontSize: 12, color: Colors.red)),
                Text('Foto Toko', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                if (imagePicked != null || imageFile != null) {
                  await dialogPhoto();
                } else {
                  await getImage();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: imagePicked != null
                    ? Image.file(File(imagePicked!.path), height: 100, width: 100, fit: BoxFit.contain)
                    : imageFile != null
                        ? Image.file(imageFile!, height: 100, width: 100, fit: BoxFit.contain)
                        : const SizedBox(
                            height: 100,
                            width: 100,
                            child: Icon(Icons.camera_alt, color: Colors.grey),
                          ),
              ),
            ),
            const SizedBox(height: 20),
            if (isUpdate)
              Row(
                children: [
                  Expanded(
                    child: AppButton.elevated(
                      width: 0,
                      onTap: () async {
                        await saveMarket().then((value) {
                          if (value) {
                            Navigator.pop(context, true);
                          }
                        });
                      },
                      text: 'UBAH TOKO',
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton.outlined(
                      width: 0,
                      onTap: () async {
                        await _sqlite.deleteMarket(marketCode!);
                        Navigator.pop(context, true);
                      },
                      text: 'HAPUS TOKO',
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            if (!isUpdate)
              AppButton.elevated(
                onTap: () async {
                  await saveMarket().then((value) {
                    if (value) {
                      Navigator.pop(context, true);
                    }
                  });
                },
                text: 'SIMPAN TOKO',
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
          ],
        ),
      ),
    );
  }
}
