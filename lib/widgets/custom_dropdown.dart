import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../const/const.dart';

// ignore: must_be_immutable
class CustomDropdown extends StatefulWidget {
  CustomDropdown({super.key, required this.list, this.controller});
  final List<String> list;
  TextEditingController? controller = TextEditingController();
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue == null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        hint: Text(
          AppLocalizations.of(context)!.select,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
          size: 23.sp,
        ),
        isExpanded: true,
        style: TextStyle(
            color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w600),
        underline: const SizedBox(),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
            widget.controller!.text = dropdownValue.toString();
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
