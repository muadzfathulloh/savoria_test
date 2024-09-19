class MarketModel {
  int? outletId;
  String? outletName;
  String? outletAddress;
  int? areaId;
  String? areaName;
  String? photo;
  String? latitude;
  String? longtitude;
  String? createdAt;
  int? createdBy;
  bool? activeFlag;

  MarketModel(
      {this.outletId,
      this.outletName,
      this.outletAddress,
      this.areaId,
      this.areaName,
      this.photo,
      this.latitude,
      this.longtitude,
      this.createdAt,
      this.createdBy,
      this.activeFlag});

  MarketModel.fromJson(Map<String, dynamic> json) {
    outletId = json['outlet_id'];
    outletName = json['outlet_name'];
    outletAddress = json['outlet_address'];
    areaId = json['area_id'];
    areaName = json['area_name'];
    photo = json['photo'];
    latitude = json['latitude'];
    longtitude = json['longtitude'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    activeFlag = json['active_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['outlet_id'] = outletId;
    data['outlet_name'] = outletName;
    data['outlet_address'] = outletAddress;
    data['area_id'] = areaId;
    data['area_name'] = areaName;
    data['photo'] = photo;
    data['latitude'] = latitude;
    data['longtitude'] = longtitude;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['active_flag'] = activeFlag;
    return data;
  }
}
