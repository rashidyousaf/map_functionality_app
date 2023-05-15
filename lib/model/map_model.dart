import 'package:cloud_firestore/cloud_firestore.dart';

class MapModel {
  int? price;
  String? availablity;
  String? type;
  GeoPoint? location;
  int? beds;
  int? baths;
  String? name;
  String? imgUrl;
  List<String>? essentialsTypes;

  MapModel(
      {this.price,
      this.availablity,
      this.type,
      this.location,
      this.beds,
      this.baths,
      this.name,
      this.imgUrl,
      this.essentialsTypes});

  MapModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    availablity = json['availablity'];
    type = json['type'];
    location = json['location'];
    beds = json['beds'];
    baths = json['baths'];
    name = json['name'];
    imgUrl = json['imgUrl'];
    essentialsTypes = json['essentialsTypes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = price;
    data['availablity'] = availablity;
    data['type'] = type;
    data['location'] = location;
    data['beds'] = beds;
    data['baths'] = baths;
    data['name'] = name;
    data['imgUrl'] = imgUrl;
    data['essentialsTypes'] = essentialsTypes;
    return data;
  }
}
