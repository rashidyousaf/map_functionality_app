import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_functionalities/const/const.dart';
import 'package:map_functionalities/views/view_screen.dart';
import 'package:map_functionalities/widgets/custom_checkbox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../service/firebase_service.dart';
import '../widgets/custom_property_type_widget.dart';
import '../widgets/custom_radio_widget.dart';

// ignore: must_be_immutable
class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _currentRangeValues = const RangeValues(20, 200);

  bool _isChecked = false;
// this section for applances essentials list
  List<String> essentials = [];
  @override
  Widget build(BuildContext context) {
    RangeLabels labels = RangeLabels(_currentRangeValues.start.toString(),
        _currentRangeValues.end.toString());

    // this int value for beds
    int? beds;
    // this int value for baths
    int? baths;

    // this list for rooms,villas,Apartments, hotel
    List<dynamic> propertyType = [];

    // this string for price minimum ang maximum
    String miniPrice = _currentRangeValues.start.toString();
    String maxPrice = _currentRangeValues.end.toString();
    // this controller for price minimum ang maximum
    TextEditingController controller = TextEditingController(text: miniPrice);
    TextEditingController controller2 = TextEditingController(text: maxPrice);

    FirestoreService fS = FirestoreService();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.cancel_outlined,
                  size: 25.sp,
                ),
              ),
              Container(
                color: greenColor,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                AppLocalizations.of(context)!.filters,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(
            color: hintColor,
            thickness: 1.h,
          ),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.priceRange,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      RangeSlider(
                        activeColor: Colors.grey.shade300,
                        values: _currentRangeValues,
                        min: 0,
                        max: 300,
                        divisions: 10,
                        labels: labels,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 8.w, top: 2.h, right: 7.w),
                            width: 100.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.w,
                                  color: hintColor,
                                ),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.minimum,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  SizedBox(
                                      height: 15.h,
                                      child: TextField(
                                        controller: controller,
                                        cursorColor: Colors.black,
                                        decoration: const InputDecoration(
                                          prefix: Text('\$'),
                                          border: InputBorder.none,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.only(
                                left: 7.w, top: 2.h, right: 7.w),
                            width: 100.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.w,
                                  color: hintColor,
                                ),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.maximum,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  SizedBox(
                                      height: 15.h,
                                      child: TextField(
                                        controller: controller2,
                                        cursorColor: Colors.black,
                                        decoration: const InputDecoration(
                                          prefix: Text('\$'),
                                          border: InputBorder.none,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Divider(
                        color: hintColor,
                        thickness: 1.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bedsAndBaths,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        AppLocalizations.of(context)!.beds,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomRadioGroup(
                        options: [
                          AppLocalizations.of(context)!.any,
                          '1',
                          '2',
                          '3',
                          '4'
                        ],
                        initialValue: 0,
                        onChanged: (index) {
                          beds = index;
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bathrooms,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomRadioGroup(
                        options: [
                          AppLocalizations.of(context)!.any,
                          '1',
                          '2',
                          '3',
                          '4'
                        ],
                        initialValue: 0,
                        onChanged: (index) {
                          // do something with the selected index
                          baths = index;
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Divider(
                        color: hintColor,
                        thickness: 1.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        AppLocalizations.of(context)!.propertyType,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // CustomPropertyTypeWidget(
                      //   options: const [
                      //     'rooms',
                      //     'villas',
                      //     'Apartments',
                      //     'Hotel'
                      //   ],
                      //   onChanged: (indexes) {
                      //     selectedOptions =
                      //         indexes.map((index) => options[index]).toList();
                      //     print(selectedOptions);
                      //   },
                      // ),
                      CustomPropertyTypeWidget(
                        options: [
                          AppLocalizations.of(context)!.rooms,
                          AppLocalizations.of(context)!.villas,
                          AppLocalizations.of(context)!.apartments,
                          AppLocalizations.of(context)!.hotels,
                        ],
                        onChanged: (indexes) {
                          propertyType.clear();
                          if (indexes.contains(0)) {
                            propertyType.add('Rooms');
                          }
                          if (indexes.contains(1)) {
                            propertyType.add('Villas');
                          }
                          if (indexes.contains(2)) {
                            propertyType.add('Apartments');
                          }
                          if (indexes.contains(3)) {
                            propertyType.add('Hotels');
                          }
                          log('Selected options: $propertyType');
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Divider(
                        color: hintColor,
                        thickness: 1.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.amenites,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              AppLocalizations.of(context)!.essentials,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label: AppLocalizations.of(context)!.wifi,
                              value: essentials.contains('wifi'),
                              icon: Icon(
                                Icons.wifi,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('wifi');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('wifi');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label: AppLocalizations.of(context)!.kitchen,
                              value: essentials.contains('kitchen'),
                              icon: Icon(
                                Icons.soup_kitchen,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('kitchen');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('kitchen');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label:
                                  AppLocalizations.of(context)!.washingMachine,
                              value: essentials.contains('washingMachine'),
                              icon: Icon(
                                Icons.hot_tub_rounded,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('washingMachine');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('washingMachine');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label: AppLocalizations.of(context)!.dryer,
                              value: essentials.contains('dryer'),
                              icon: Icon(
                                Icons.dry_cleaning,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('dryer');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('dryer');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label:
                                  AppLocalizations.of(context)!.airConditioning,
                              value: essentials.contains('airConditioning'),
                              icon: Icon(
                                Icons.ac_unit,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('airConditioning');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('airConditioning');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label: AppLocalizations.of(context)!.heating,
                              value: essentials.contains('heating'),
                              icon: Icon(
                                Icons.heat_pump_outlined,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('heating');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('heating');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label: AppLocalizations.of(context)!
                                  .dedicatedWorkspace,
                              value: essentials.contains('dedicatedWorkspace'),
                              icon: Icon(
                                Icons.house,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('dedicatedWorkspace');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('dedicatedWorkspace');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label: AppLocalizations.of(context)!.tv,
                              value: essentials.contains('tv'),
                              icon: Icon(
                                Icons.tv,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('tv');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('tv');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            // CustomCheckbox(
                            //   label: 'Hiar dryer',
                            //   value: essentials.contains('hairDryer'),
                            //   onChanged: (newValue) {
                            //     setState(() {
                            //       if (newValue) {
                            //         essentials.add('hairDryer');
                            //         log('$essentials');
                            //       } else {
                            //         essentials.remove('hairDryer');
                            //         log('$essentials');
                            //       }
                            //     });
                            //   },
                            // ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomCheckbox(
                              label: AppLocalizations.of(context)!.iron,
                              value: essentials.contains('iron'),
                              icon: Icon(
                                Icons.iron,
                                size: 20.sp,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue) {
                                    essentials.add('iron');
                                    log('$essentials');
                                  } else {
                                    essentials.remove('iron');
                                    log('$essentials');
                                  }
                                });
                              },
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: hintColor,
          ),
          SizedBox(
            width: double.maxFinite,
            height: 70.h,
            child: Row(
              children: [
                SizedBox(
                  width: 15.w,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewScreen(
                                  miniPrice: 0,
                                  maxPrice: 0,
                                  beds: 0,
                                  baths: 0,
                                  essentials: [],
                                  propertyType: [],
                                )));
                    setState(() {});
                  },
                  child: Text(
                    AppLocalizations.of(context)!.clearAll,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    double miniPrice = double.parse(controller.text.toString());
                    double maxPrice = double.parse(controller2.text.toString());

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewScreen(
                                  miniPrice: miniPrice.round(),
                                  maxPrice: maxPrice.round(),
                                  beds: beds,
                                  baths: baths,
                                  essentials: essentials,
                                  propertyType: propertyType,
                                  // rooms: rooms,
                                  // villas: villas,
                                  // apartments: apartments,
                                  // hotel: hotel,
                                )));
                    setState(() {});
                    // log('mini price ${controller.text.toString()} max pric ${controller2.text.toString()} beds $beds baths $baths property ${propertyType} essentials $essentials');
                  },
                  child: Text(
                    AppLocalizations.of(context)!.showplaces,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
