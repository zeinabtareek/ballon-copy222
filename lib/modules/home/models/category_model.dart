class CategoryModel {
  CategoryModel({
      this.data, 
      this.msg, 
      this.status, 
      this.statusCode, 
      this.msgEn, 
      this.msgAr,});

  CategoryModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    msg = json['msg'];
    status = json['status'];
    statusCode = json['statusCode'];
    msgEn = json['msg_en'];
    msgAr = json['msg_ar'];
  }
  List<Data>? data;
  String? msg;
  bool? status;
  int? statusCode;
  dynamic msgEn;
  dynamic msgAr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['msg'] = msg;
    map['status'] = status;
    map['statusCode'] = statusCode;
    map['msg_en'] = msgEn;
    map['msg_ar'] = msgAr;
    return map;
  }

}

class Data {
  Data({
      this.id, 
      this.name, 
      this.level, 
      this.refId, 
      this.photo, 
      this.subCategories,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    refId = json['ref_id'];
    photo = json['photo'];
    if (json['sub_categories'] != null) {
      subCategories = [];
      json['sub_categories'].forEach((v) {
        subCategories?.add(SubCategories.fromJson(v));
      });
    }
  }
  int? id;
  String? name;
  int? level;
  int? refId;
  String? photo;
  List<SubCategories>? subCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['level'] = level;
    map['ref_id'] = refId;
    map['photo'] = photo;
    if (subCategories != null) {
      map['sub_categories'] = subCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SubCategories {
  SubCategories({
      this.id, 
      this.name, 
      this.level, 
      this.refId, 
      this.photo,});

  SubCategories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    refId = json['ref_id'];
    photo = json['photo'];
  }
  int? id;
  String? name;
  int? level;
  int? refId;
  String? photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['level'] = level;
    map['ref_id'] = refId;
    map['photo'] = photo;
    return map;
  }

}