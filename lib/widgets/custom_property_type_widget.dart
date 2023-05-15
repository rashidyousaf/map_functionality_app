import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const/const.dart';

class CustomPropertyTypeWidget extends StatefulWidget {
  final List<String> options;
  final Function(List<int>) onChanged;
  final List<int> initialValue;

  const CustomPropertyTypeWidget({
    Key? key,
    required this.options,
    required this.onChanged,
    this.initialValue = const [],
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomPropertyTypeWidgetState createState() =>
      _CustomPropertyTypeWidgetState();
}

class _CustomPropertyTypeWidgetState extends State<CustomPropertyTypeWidget> {
  List<int> _selectedIndexes = [];
  final List<IconData> _icons = [
    Icons.home,
    Icons.villa_sharp,
    Icons.apartment,
    Icons.hotel,
    Icons.school_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndexes = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.w,
      runSpacing: 16.h,
      children: widget.options.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;
        final isSelected = _selectedIndexes.contains(index);

        final icon = _icons[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedIndexes.contains(index)) {
                _selectedIndexes.remove(index);
              } else {
                _selectedIndexes = [..._selectedIndexes, index];
              }
              widget.onChanged(_selectedIndexes);
            });
          },
          child: Container(
            height: 100.h,
            width: 150.w,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: Colors.black),
              borderRadius: BorderRadius.circular(24.r),
              color: isSelected ? greyColor : Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 40.sp,
                ),
                SizedBox(height: 10.h),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
