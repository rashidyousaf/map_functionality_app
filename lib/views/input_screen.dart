// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:map_functionalities/const/colors.dart';
import 'package:map_functionalities/main.dart';
import 'package:map_functionalities/views/controller/map_controller.dart';
import 'package:map_functionalities/views/view_screen.dart';
import 'package:map_functionalities/widgets/custom_dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/language.dart';
import '../widgets/custom_textfield.dart';

const List<String> list = <String>['Avaliable', 'Not Avaliable'];
const List<String> list2 = <String>['Hotels', 'Appartments', 'Villas', 'Rooms'];

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.561920, 74.348083),
    zoom: 2,
  );

  List<Marker> _marker = [];

  // this for give value to function
  double latitude = 0;
  double longitude = 0;
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(31.561920, 74.348083),
        infoWindow: InfoWindow(title: 'Lahore'))
  ];

// this is for add marker on map
  List<Marker> markers = [];

  // this section for serach places
  List<dynamic> _placesList = [];
  TextEditingController _textController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
    _textController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_textController.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyClFplHsDAz86qsjXQ05yOfeX3OJvkQe4s";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    // log('${response.body.toString()}');
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

// this section gettting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {});
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final MapController mp = MapController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // this floatingActionButton
      floatingActionButton: FloatingActionButton(
          backgroundColor: greyColor,
          child: Icon(
            Icons.my_location_rounded,
            size: 30.sp,
            color: Colors.black,
          ),
          onPressed: () async {
            getUserCurrentLocation().then((value) async {
              GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(value.latitude, value.longitude), zoom: 6),
                ),
              );
              setState(() {});
            });
          }),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.home,
          style: TextStyle(
              color: Colors.black,
              fontSize: 25.sp,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, right: 15.w, left: 15.w),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: Icon(
                Icons.language,
                color: Colors.black,
                size: 25.sp,
              ),
              onChanged: (Language? language) async {
                if (language != null) {
                  MyApp.setLocale(context, Locale(language.languageCode, ''));
                }
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.input,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomTextfield(
                  hint: AppLocalizations.of(context)!.enterprice,
                  controller: mp.priceController,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropdown(
                      list: list,
                      controller: mp.availablityController,
                    ),
                    CustomDropdown(
                      list: list2,
                      controller: mp.typeController,
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.textfieldHint,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: hintColor, width: 2.w),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: hintColor, width: 1.0),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return _placesList;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['description']),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    onSuggestionSelected(suggestion);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            color: greyColor,
            height: 450.h,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return GoogleMap(
                onTap: (LatLng latLng) async {
                  Marker newMarker = Marker(
                    markerId: const MarkerId("new Location"),
                    position: LatLng(latLng.latitude, latLng.longitude),
                    infoWindow: const InfoWindow(
                      title: 'New Place',
                    ),
                  );
                  markers.add(newMarker);
                  latitude = latLng.latitude;
                  longitude = latLng.longitude;
                  mp.updateValue(latLng.latitude, latLng.longitude);

                  setState(() {});

                  log("lat: ${latLng.latitude} lon: ${latLng.longitude}");
                },
                markers: markers.map((e) => e).toSet(),
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            }),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 100.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .black, // Set the background color of the button
                      ),
                      onPressed: () async {
                        await mp.saveData();
                        // mp.latitude = latitude;
                        // mp.longitude = longitude;

                        // if (mp.priceController.text.isNotEmpty &&
                        //     mp.availablityController.text.isNotEmpty &&
                        //     mp.latitude != null &&
                        //     mp.longitude != null) {
                        //   await mp.saveData();
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('Data add'),
                        //       duration: Duration(seconds: 2),
                        //     ),
                        //   );
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('All fields required'),
                        //       duration: Duration(seconds: 2),
                        //     ),
                        //   );
                        // }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.submit,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ))),
              SizedBox(
                width: 20.w,
              ),
              SizedBox(
                  width: 90.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .black, // Set the background color of the button
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewScreen(
                                    propertyType: [],
                                  )),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.view,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ))),
            ],
          )
        ],
      ),
    );
  }

// this fuction for getting places from api and show in typeahead package
  void onSuggestionSelected(dynamic suggestion) async {
    _textController.text = suggestion['description'];
    String placeId = suggestion['place_id'];
    String kPLACES_API_KEY = "AIzaSyClFplHsDAz86qsjXQ05yOfeX3OJvkQe4s";
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request = '$baseURL?place_id=$placeId&key=$kPLACES_API_KEY';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body)['result'];
      double lat = result['geometry']['location']['lat'];
      double lng = result['geometry']['location']['lng'];
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 5));
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }
}
