import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_side_widget.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';

class SalesReturn extends StatelessWidget {
  const SalesReturn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundGrey,
      appBar: OrientationMode.deviceMode == OrientationMode.verticalMode ? AppBarWidget(title: 'Sales Return') : null,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: _screenSize.width * .01, horizontal: _screenSize.width * .02),
            child: OrientationMode.deviceMode == OrientationMode.normalMode
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      //========================================                                  ========================================
                      //========================================     Sales Return Side Widget     ========================================
                      //========================================                                  ========================================
                      SalesReturnSideWidget(),

                      // //==================== Constant Width ====================
                      // kWidth20,

                      //========================================                                  ========================================
                      //======================================== Sales Return Product Side Widget ========================================
                      //========================================                                  ========================================
                      // SalesReturnProductSideWidget()
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      //========================================                                  ========================================
                      //========================================     Sales Return Side Widget     ========================================
                      //========================================                                  ========================================
                      // SalesReturnProductSideWidget(isVertical: true),

                      // //==================== Divider ====================
                      // Divider(thickness: 1, height: 10),

                      //========================================                                  ========================================
                      //======================================== Sales Return Product Side Widget ========================================
                      //========================================                                  ========================================
                      SalesReturnSideWidget(isVertical: true)
                    ],
                  )),
      ),
    );
  }
}
