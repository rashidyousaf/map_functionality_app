import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:map_functionalities/const/const.dart';
import 'package:map_functionalities/service/firebase_service.dart';
import 'package:map_functionalities/views/filter_screen.dart';
import 'package:map_functionalities/widgets/custom_marker_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../main.dart';
import '../model/language.dart';
import '../model/map_model.dart';

// ignore: must_be_immutable
class ViewScreen extends StatefulWidget {
  ViewScreen({
    super.key,
    this.miniPrice,
    this.maxPrice,
    this.beds,
    this.baths,
    this.essentials,
    required this.propertyType,
    this.house,
    this.flat,
    this.guestHouse,
    this.hotel,
  });

  // this value getting from filter screen

  int? miniPrice;
  int? maxPrice;
  int? beds;
  int? baths;
  String? house;
  String? guestHouse;
  String? flat;
  String? hotel;
  List<dynamic> propertyType = [];
  List<String>? essentials = [];

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // this section for searching place from api
    _textController.addListener(() {
      onChange();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.835094531355026, 2.7917470782995224),
    zoom: 6,
  );

// this section for serach places
  List<dynamic> _placesList = [];
  TextEditingController _textController = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '122344';

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

  // this is for bottom map
  MapModel? mapModelData;

  @override
  Widget build(BuildContext context) {
    List<dynamic> propertyType = [];
    // this combination of essentials and propertytype
    log("widget.propetyType: ${widget.propertyType}");
    FirestoreService fS = FirestoreService();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                setState(() {
                  mapModelData = null;
                });
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
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: greyColor,
      //     child: Icon(
      //       Icons.my_location_rounded,
      //       size: 30.sp,
      //       color: Colors.black,
      //     ),
      //     onPressed: () async {
      //       getUserCurrentLocation().then((value) async {
      //         GoogleMapController controller = await _controller.future;
      //         controller.animateCamera(
      //           CameraUpdate.newCameraPosition(
      //             CameraPosition(
      //                 target: LatLng(value.latitude, value.longitude), zoom: 6),
      //           ),
      //         );
      //         setState(() {});
      //       });
      //     }),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      SizedBox(
                        width: 300.w,
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.textfieldHint,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: hintColor, width: 2.w),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: hintColor, width: 1.w),
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
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              mapModelData = null;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FilterScreen()));
                          },
                          icon: SizedBox(
                            width: 30.w,
                            height: 35,
                            child: Image.asset(
                              'assets/icons/icSetting.png',
                              fit: BoxFit.fill,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.amber,
                    controller: _tabController,
                    unselectedLabelStyle: const TextStyle(color: Colors.amber),
                    onTap: (int index) {
                      setState(() {});
                    },
                    tabs: [
                      Tab(
                        text: AppLocalizations.of(context)!.all,
                        icon: const Icon(Icons.all_inbox),
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.rooms,
                        icon: const Icon(Icons.home),
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.villas,
                        icon: const Icon(Icons.villa_sharp),
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.apartments,
                        icon: const Icon(Icons.apartment),
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.hotels,
                        icon: const Icon(Icons.hotel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 635.h,
                child: DefaultTabController(
                  length: 4,
                  child: FutureBuilder<QuerySnapshot>(
                    future: () {
                      if (_tabController!.index == 0) {
                        // when on index 0, show all property types

                        List<String> toRemove = [
                          'Rooms',
                          'Villas',
                          'Apartments',
                          'Hotels'
                        ];

                        propertyType
                            .removeWhere((item) => toRemove.contains(item));

                        log('propertyType: ${propertyType}');

                        return fS.getFilteredMapData(
                            minPrice: widget.miniPrice,
                            maxPrice: widget.maxPrice,
                            beds: widget.beds,
                            baths: widget.baths,
                            essentials: widget.essentials);
                      } else if (_tabController!.index == 1) {
                        // when on index 1, show all except Rooms

                        List<String> toRemove = [
                          'Villas',
                          'Apartments',
                          'Hotels'
                        ];
                        propertyType
                            .removeWhere((item) => toRemove.contains(item));
                        if (!propertyType.contains('Rooms')) {
                          propertyType.add('Rooms');
                        }
                        log("list of properties: ${propertyType}");
                        return fS.getFilteredMapData(
                            minPrice: widget.miniPrice,
                            maxPrice: widget.maxPrice,
                            beds: widget.beds,
                            baths: widget.baths,
                            essentials: widget.essentials);
                      } else if (_tabController!.index == 2) {
                        // when on index 0, show all property types

                        List<String> toRemove = [
                          'Rooms',
                          'Apartments',
                          'Hotels'
                        ];
                        propertyType
                            .removeWhere((item) => toRemove.contains(item));
                        if (!propertyType.contains('Villas')) {
                          propertyType.add('Villas');
                        }

                        log("list of properties: ${propertyType}");
                        return fS.getFilteredMapData(
                            minPrice: widget.miniPrice,
                            maxPrice: widget.maxPrice,
                            beds: widget.beds,
                            baths: widget.baths,
                            essentials: widget.essentials);
                      } else if (_tabController!.index == 3) {
                        List<String> toRemove = ['Rooms', 'Villas', 'Hotels'];
                        propertyType
                            .removeWhere((item) => toRemove.contains(item));
                        if (!propertyType.contains('Apartments')) {
                          propertyType.add('Apartments');
                        }

                        log("list of properties: ${propertyType}");

                        return fS.getFilteredMapData(
                            minPrice: widget.miniPrice,
                            maxPrice: widget.maxPrice,
                            beds: widget.beds,
                            baths: widget.baths,
                            essentials: widget.essentials);
                      } else {
                        List<String> toRemove = [
                          'Rooms',
                          'Villas',
                          'Apartments',
                        ];
                        propertyType
                            .removeWhere((item) => toRemove.contains(item));
                        if (!propertyType.contains('Hotels')) {
                          propertyType.add('Hotels');
                        }

                        log("list of properties: ${propertyType}");
                        return fS.getFilteredMapData(
                            minPrice: widget.miniPrice,
                            maxPrice: widget.maxPrice,
                            beds: widget.beds,
                            baths: widget.baths,
                            essentials: widget.essentials);
                      }
                    }(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<MapModel> mapModels =
                            snapshot.data!.docs.map((doc) {
                          return MapModel.fromJson(
                              doc.data() as Map<String, dynamic>);
                        }).toList();
                        // this setion for filter data
                        List<MapModel> filteredModels = [];

                        if (widget.propertyType.isNotEmpty) {
                          filteredModels = mapModels
                              .where((model) =>
                                  widget.propertyType.contains(model.type))
                              .toList();
                        } else if (propertyType.isNotEmpty) {
                          filteredModels = mapModels
                              .where(
                                  (model) => propertyType.contains(model.type))
                              .toList();
                        } else {
                          filteredModels = mapModels;
                        }

                        return FutureBuilder<List<Marker>>(
                          future: () async {
                            List<Marker> markersList = [];
                            for (var mapModel in filteredModels) {
                              var marker = Marker(
                                  markerId: MarkerId(mapModel.price.toString()),
                                  position: LatLng(mapModel.location!.latitude,
                                      mapModel.location!.longitude),
                                  icon: await CustomMarkerWidget(
                                    price: mapModel.price.toString(),
                                    color:
                                        mapModel.availablity == "Not Available"
                                            ? Colors.red
                                            : Colors.green,
                                  ).toBitmapDescriptor(),
                                  // infoWindow: InfoWindow(
                                  //   title: mapModel.price!,
                                  // ),
                                  onTap: () {
                                    setState(() {
                                      mapModelData = mapModel;
                                    });
                                  });
                              markersList.add(marker);
                            }
                            return markersList;
                          }(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Set<Marker> markers = snapshot.data!.toSet();
                              return Stack(
                                children: [
                                  SizedBox(
                                    child: GoogleMap(
                                      initialCameraPosition: _kGooglePlex,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                      markers: markers,
                                      onTap: (argument) {
                                        setState(() {
                                          mapModelData = null;
                                        });
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 340.w,
                                    child: IconButton(
                                        onPressed: () async {
                                          getUserCurrentLocation()
                                              .then((value) async {
                                            GoogleMapController controller =
                                                await _controller.future;
                                            controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(
                                                        value.latitude,
                                                        value.longitude),
                                                    zoom: 6),
                                              ),
                                            );
                                            log('clicked');
                                            setState(() {});
                                          });
                                        },
                                        icon: Icon(
                                          Icons.my_location_rounded,
                                          color: Colors.black,
                                          size: 35.sp,
                                        )),
                                  ),
                                  if (mapModelData != null)
                                    Positioned(
                                      top: 420.h,
                                      left: 45.w,
                                      child: Container(
                                        width: 300.w,
                                        height: 100.h,
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(15.r)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 100.w,
                                              height: 100.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.horizontal(
                                                        left: Radius.circular(
                                                            15.r)),
                                                child: Image.network(
                                                  '${mapModelData!.imgUrl}',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  '${mapModelData!.name}',
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Text(
                                                  '${mapModelData!.type}',
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Price:',
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      '${mapModelData!.price}',
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        mapModelData = null;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      size: 20.sp,
                                                    )),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 20.sp,
                                                    ),
                                                    Text(
                                                      '4.8',
                                                      style: TextStyle(
                                                          fontSize: 18.sp),
                                                    ),
                                                    SizedBox(
                                                      width: 2.w,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // this fuction for range slider

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
