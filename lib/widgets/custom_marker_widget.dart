import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_functionalities/const/const.dart';

class CustomMarkerWidget extends StatelessWidget {
  CustomMarkerWidget({super.key, this.color = Colors.green, this.price});
  final String? price;
  Color color;
  GlobalKey markerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: markerKey,
      child: SizedBox(
        height: 75.h,
        width: 75.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Icon(
                Icons.arrow_drop_down,
                color: color,
                size: 50.sp,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15.h),
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(10.r)),
              child: Text(
                price!,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
