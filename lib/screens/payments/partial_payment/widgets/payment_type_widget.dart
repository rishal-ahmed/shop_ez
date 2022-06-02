import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/payment_details_table_widget.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/sizes.dart';
import '../../../../widgets/text_field_widgets/text_field_widgets.dart';

//========== DropDown Items ==========
const List types = ['Cash', 'Card'];

class PaymentTypeWidget extends StatelessWidget {
  const PaymentTypeWidget({
    required this.totalPayable,
    Key? key,
  }) : super(key: key);

  final num totalPayable;

  //========== Global Keys ==========
  static final GlobalKey<FormState> formKey = GlobalKey();

  //========== DropDown Controllers ==========
  static String? payingByController;

  //========== Text Editing Controllers ==========
  static final amountController = TextEditingController();
  static final payingNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log('PaymentTypeWidget() => build Called!');
    //========== MediaQuery ScreenSize ==========
    late Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        amountController.clear();
        payingNoteController.clear();
        payingByController = null;
        return true;
      },
      child: Container(
        color: kBackgroundGrey,
        width: _screenSize.width / 1,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //========== Rate Field ==========
                    Flexible(
                      flex: 1,
                      child: TextFeildWidget(
                        labelText: 'Amount *',
                        controller: amountController,
                        inputBorder: const OutlineInputBorder(),
                        textInputType: TextInputType.number,
                        inputFormatters: Validators.digitsOnly,
                        onChanged: (value) {
                          if (value != null) {
                            amountChanged(value.isNotEmpty ? value : '0');
                          }
                        },
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        constraints: const BoxConstraints(maxHeight: 45),
                        contentPadding: const EdgeInsets.all(10),
                        errorStyle: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          final _totalPayable = num.parse(Converter.currency.format(totalPayable));
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required*';
                          } else if (num.parse(value) > _totalPayable) {
                            return 'Amount is higher than payable*';
                          }
                          return null;
                        },
                      ),
                    ),

                    kWidth20,

                    //========== Type DropDown ==========
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          constraints: BoxConstraints(maxHeight: 45),
                          fillColor: kWhite,
                          filled: true,
                          isDense: true,
                          errorStyle: TextStyle(fontSize: 0.01),
                          contentPadding: EdgeInsets.all(10),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text('Paying By *', style: TextStyle(color: klabelColorBlack)),
                          border: OutlineInputBorder(),
                        ),
                        items: types
                            .map((values) => DropdownMenuItem<String>(
                                  value: values,
                                  child: Text(values),
                                ))
                            .toList(),
                        onChanged: (value) {
                          payingByController = value.toString();
                          log(payingByController!);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                kHeight20,
                Flexible(
                  flex: 1,
                  child: TextFeildWidget(
                    labelText: 'Payment Note',
                    controller: payingNoteController,
                    inputBorder: const OutlineInputBorder(),
                    textInputType: TextInputType.text,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //========== On Amount Changed ==========
  amountChanged(String amount) {
    final num? _totalPaying = num.tryParse(amount);
    PaymentDetailsTableWidget.totalPayingNotifier.value = _totalPaying ?? 0;

    final num _balance = totalPayable - _totalPaying!;
    PaymentDetailsTableWidget.balanceNotifier.value = _balance;
    log('Balance Amount == $_balance');
  }
}
