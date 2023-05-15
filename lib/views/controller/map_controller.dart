import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_functionalities/model/map_model.dart';
import 'package:map_functionalities/service/firebase_service.dart';

import '../../const/const.dart';

class MapController with ChangeNotifier {
  TextEditingController priceController = TextEditingController();
  TextEditingController availablityController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  double latitude = 0;
  double longitude = 0;

  void updateLocation(double lat, double long) {
    latitude = lat;
    longitude = long;
    notifyListeners();
  }

  FirestoreService firestoreService = FirestoreService();

  updateValue(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  // Future<void> saveData() async {
  //   MapModel mapModel = MapModel(
  //     price: int.parse(priceController.text),
  //     availablity: availablityController.text,
  //     location: GeoPoint(latitude, longitude),
  //   );

  //   await firestoreService.saveData(mapModel);

  //   priceController.clear();
  //   availablityController.clear();
  //   typeController.clear();
  // }

  // ['House', 'Flat', 'Guest house', 'Hotel','wifi','kitchen','washingMachine','dryer','airConditioning','heating','iron','tv','dedicatedWorkspace','Appartments','Hotels','Villas','Rooms',]
  Future<void> saveData() async {
    MapModel mapModel = MapModel(
        price: 145,
        availablity: 'Available',
        location: const GeoPoint(32.22061239409323, 37.298810966312885),
        beds: 2,
        baths: 1,
        name: 'Tom Henry',
        type: 'Villas',
        essentialsTypes: [
          'wifi',
          'kitchen',
          'washingMachine',
          'dryer',
          'airConditioning',
          'heating',
          'iron',
          'tv',
          'dedicatedWorkspace',
        ],
        imgUrl:
            'https://images.pexels.com/photos/1559825/pexels-photo-1559825.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2');

    await firestoreService.saveData(mapModel);
  }
}
