import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_functionalities/model/map_model.dart';

class FirestoreService {
  CollectionReference data = FirebaseFirestore.instance.collection("data");
  CollectionReference mapData =
      FirebaseFirestore.instance.collection("mapData");

  Future<void> saveData(MapModel mapModel) async {
    await mapData.add(mapModel.toJson());
  }

  Future<QuerySnapshot> getData(String type) async {
    return FirebaseFirestore.instance
        .collection('data')
        .where('type', isEqualTo: type)
        .get();
  }

  Future<QuerySnapshot> gePtData(
      String type, String minPrice, String maxPrice) async {
    return FirebaseFirestore.instance
        .collection('data')
        .where('type', isEqualTo: type)
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .get();
  }

  Future<QuerySnapshot> getAllData() async {
    return FirebaseFirestore.instance.collection('data').get();
  }

  // Future<QuerySnapshot> getFilteredMapData() async {
  //   return FirebaseFirestore.instance
  //       .collection('mapData')
  //       .where('type', isEqualTo: 'Hotels')
  //       .where('price', isGreaterThanOrEqualTo: 0)
  //       .where('bath', isEqualTo: 2)
  //       .where('bed', isEqualTo: 1)
  //       .get();
  // }

  // get data by filtring
  Future<QuerySnapshot> getFilteredMapData({
    int? baths,
    int? beds,
    int? minPrice,
    int? maxPrice,
    List<String>? essentials,
    String? type,
  }) {
    Query query = FirebaseFirestore.instance.collection('mapData');

    if (baths != 0) {
      query = query.where('baths', isEqualTo: baths);
    }

    if (beds != 0) {
      query = query.where('beds', isEqualTo: beds);
    }
    // if (type != null) {
    //   query = query.where('type', isEqualTo: type);
    // }
    // this filter for houes
    // if (house != null) {
    //   query = query.where('type', isEqualTo: house);
    // }
    // // this filter for Flat
    // if (flat != null) {
    //   query = query.where('type', isEqualTo: flat);
    // }
    // // this filter for guest House
    // if (guestHouse != null) {
    //   query = query.where('type', isEqualTo: guestHouse);
    // }
    // // // this filter for hotel
    // if (hotel != null) {
    //   query = query.where('type', isEqualTo: hotel);
    // }
    // // filter for price
    if (minPrice != 0) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      if (maxPrice != 0) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }
    }

    // Filter by essentials type
    if (essentials?.isNotEmpty == true) {
      query = query.where('essentials', arrayContainsAny: essentials);
    }

    // if (types?.isNotEmpty == true) {
    //   log("value of typ: $types");

    //   query = query.where('type', whereIn: types);
    // }

    return query.get();
  }
}
