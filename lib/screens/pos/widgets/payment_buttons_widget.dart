import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/logged_user.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';

import '../../../core/utils/device/device.dart';
import '../../../core/utils/text/converters.dart';
import '../../../core/constant/sizes.dart';
import '../../../db/db_functions/sales/sales_database.dart';

class PaymentButtonsWidget extends StatelessWidget {
  const PaymentButtonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = DeviceUtil.isTablet;
    Size _screenSize = MediaQuery.of(context).size;
    SalesDatabase.instance.getAllSales();

    return Column(
      children: [
        Container(
          height: _screenSize.width / 25,
          padding: const EdgeInsets.all(8),
          color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Total Payable',
                style: TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 12 : 11),
                minFontSize: 8,
              ),
              kWidth5,
              Flexible(
                child: ValueListenableBuilder(
                  valueListenable: SaleSideWidget.totalPayableNotifier,
                  builder: (context, totalPayable, child) {
                    return AutoSizeText(
                      totalPayable == 0
                          ? '0'
                          : Converter.currency.format(totalPayable),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 12 : 11,
                      ),
                      minFontSize: 8,
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text(
                            'Credit Payment!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          content: const Text('Do you want to add this sale?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  final String _balance = SaleSideWidget
                                      .totalPayableNotifier.value
                                      .toString();
                                  addSale(
                                    context,
                                    argPaid: '0',
                                    argBalance: _balance,
                                    argPaymentStatus: 'Credit',
                                    argPaymentType: '',
                                  );
                                },
                                child: const Text('Accept')),
                          ],
                        );
                      },
                    );
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.yellow[800],
                  child: Center(
                    child: AutoSizeText(
                      'Credit Payment',
                      style: TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 12 : 11),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text(
                            'Full Payment!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          content: const Text('Do you want to add this sale?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  addSale(context);
                                },
                                child: const Text('Accept')),
                          ],
                        );
                      },
                    );
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.green[700],
                  child: Center(
                    child: AutoSizeText(
                      'Full Payment',
                      style: TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 12 : 11),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.all(5),
                  color: Colors.red[400],
                  child: Center(
                    child: AutoSizeText(
                      'Cancel',
                      style: TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 12 : 11),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, routePartialPayment,
                        arguments: {
                          'totalPayable':
                              SaleSideWidget.totalPayableNotifier.value,
                          'totalItems': SaleSideWidget.totalItemsNotifier.value,
                        });
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.lightGreen[700],
                  child: Center(
                    child: AutoSizeText(
                      'Partial Payment',
                      style: TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 12 : 11),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

//==================== Add Sale ====================
  addSale(
    BuildContext context, {
    String? argBalance,
    String? argPaymentStatus,
    String? argPaymentType,
    String? argPaid,
  }) async {
    final String dateTime,
        cusomerId,
        customerName,
        billerName,
        salesNote,
        totalItems,
        vatAmount,
        subTotal,
        discount,
        grantTotal,
        paid,
        balance,
        paymentType,
        salesStatus,
        paymentStatus,
        createdBy;

    final _loggedUser = await UserUtils.instance.loggedUser;
    final String _user = _loggedUser!.shopName;
    log('Logged User ==== $_user');

    final _businessProfile = await UserUtils.instance.businessProfile;
    final String _biller = _businessProfile!.billerName;
    log('Biller Name ==== $_biller');

//Checking if it's Partial Payment then Including Balance Amount

    if (argPaymentStatus != null) {
      paymentStatus = argPaymentStatus;
    } else {
      paymentStatus = 'Paid';
    }

    if (argBalance != null) {
      balance = argBalance;
    } else {
      balance = '0';
    }

    if (argPaymentType != null) {
      paymentType = argPaymentType;
    } else {
      paymentType = 'Cash';
    }

    if (argPaid != null) {
      paid = argPaid;
    } else {
      paid = SaleSideWidget.totalPayableNotifier.value.toString();
    }

    dateTime = DateTime.now().toIso8601String();
    cusomerId = SaleSideWidget.customerIdNotifier.value.toString();
    customerName = SaleSideWidget.customerNameNotifier.value!;
    billerName = _biller;
    salesNote = 'New Sale';
    totalItems = SaleSideWidget.totalItemsNotifier.value.toString();
    vatAmount = SaleSideWidget.totalVatNotifier.value.toString();
    subTotal = SaleSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    grantTotal = SaleSideWidget.totalPayableNotifier.value.toString();
    salesStatus = 'Completed';
    createdBy = _user;

    final SalesModel _salesModel = SalesModel(
        dateTime: dateTime,
        cusomerId: cusomerId,
        customerName: customerName,
        billerName: billerName,
        salesNote: salesNote,
        totalItems: totalItems,
        vatAmount: vatAmount,
        subTotal: subTotal,
        discount: discount,
        grantTotal: grantTotal,
        paid: paid,
        balance: balance,
        paymentType: paymentType,
        salesStatus: salesStatus,
        paymentStatus: paymentStatus,
        createdBy: createdBy);

    try {
      final SalesDatabase salesDB = SalesDatabase.instance;
      salesDB.createSales(_salesModel);
      kSnackBar(
        context: context,
        color: kSnackBarSuccessColor,
        icon: const Icon(
          Icons.done,
          color: kSnackBarIconColor,
        ),
        content: "Sale Added Successfully!",
      );
    } catch (e) {
      log('$e');
    }
  }
}
