import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/const.dart';

class CustomRadioGroup extends StatefulWidget {
  final List<String> options;
  final Function(int) onChanged;
  final int initialValue;

  const CustomRadioGroup({
    Key? key,
    required this.options,
    required this.onChanged,
    this.initialValue = 0,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.options.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;
        final isSelected = _selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
              widget.onChanged(_selectedIndex);
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: Colors.black),
              borderRadius: BorderRadius.circular(24),
              color: isSelected ? Colors.black : Colors.white,
            ),
            child: Text(
              value,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16.sp,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
