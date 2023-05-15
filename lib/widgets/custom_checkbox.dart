import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;
  final Widget? icon;

  const CustomCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.icon!,
          SizedBox(
            width: 7.w,
          ),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
      value: _value,
      onChanged: (newValue) {
        setState(() {
          _value = newValue!;
        });
        widget.onChanged(_value);
      },
    );
  }
}
