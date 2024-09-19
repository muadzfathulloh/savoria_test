class MarketDataModel {
  String? marketCode;
  String? marketName;
  String? marketAddress;
  String? latitudeLongitude;
  String? photo;
  String? photoPath;
  String? createdDate;
  String? updatedDate;

  MarketDataModel(
      {this.marketCode,
      this.marketName,
      this.marketAddress,
      this.latitudeLongitude,
      this.photo,
      this.photoPath,
      this.createdDate,
      this.updatedDate});

  MarketDataModel.fromJson(Map<String, dynamic> json) {
    marketCode = json['market_code'];
    marketName = json['market_name'];
    marketAddress = json['market_address'];
    latitudeLongitude = json['latitude_longitude'];
    photo = json['photo'];
    photoPath = json['photo_path'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['market_code'] = marketCode;
    data['market_name'] = marketName;
    data['market_address'] = marketAddress;
    data['latitude_longitude'] = latitudeLongitude;
    data['photo'] = photo;
    data['photo_path'] = photoPath;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    return data;
  }
}
