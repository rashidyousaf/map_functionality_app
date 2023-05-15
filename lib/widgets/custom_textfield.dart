import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/const.dart';

class CustomTextfield extends StatelessWidget {
  CustomTextfield(
      {super.key, this.visible = false, required this.hint, this.controller});
  TextEditingController? controller = TextEditingController();
  bool visible;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: hintColor,
      cursorHeight: 20.h,
      decoration: InputDecoration(
        prefixIcon: visible
            ? Icon(
                Icons.location_on,
                size: 25.sp,
                color: hintColor,
              )
            : null,
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.w, color: hintColor),
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.w, color: hintColor),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}
