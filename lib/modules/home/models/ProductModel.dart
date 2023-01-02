class ProductModel {
  ProductModel({
      this.data, 
      this.msg, 
      this.nextPage, 
      this.status, 
      this.statusCode,});

  ProductModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductData.fromJson(v));
      });
    }
    msg = json['msg'];
    nextPage = json['nextPage'];
    status = json['status'];
    statusCode = json['statusCode'];
  }
  List<ProductData>? data;
  String? msg;
  int? nextPage;
  bool? status;
  int? statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['msg'] = msg;
    map['nextPage'] = nextPage;
    map['status'] = status;
    map['statusCode'] = statusCode;
    return map;
  }

}

class ProductData {
  ProductData({
      this.id, 
      this.name, 
      this.desc, 
      this.price, 
      this.availability, 
      this.photo, 
      this.categoryId,});

  ProductData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    price = json['price'];
    availability = json['availability'];
    photo = json['photo'];
    categoryId = json['category_id'];
  }
  int? id;
  String? name;
  String? desc;
  double? price;
  int? availability;
  String? photo;
  int? categoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['desc'] = desc;
    map['price'] = price;
    map['availability'] = availability;
    map['photo'] = photo;
    map['category_id'] = categoryId;
    return map;
  }

}