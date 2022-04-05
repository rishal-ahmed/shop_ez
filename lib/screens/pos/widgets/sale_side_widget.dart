// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/db/db_functions/customer_database/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/pos/screen_pos.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/pos/widgets/price_section_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../widgets/gesture_dismissible_widget/dismissible_widget.dart';

class SaleSideWidget extends StatelessWidget {
  const SaleSideWidget({
    Key? key,
  }) : super(key: key);

  // //==================== Singleton Instance ====================
  // static final SaleSideWidget instance = SaleSideWidget._internal();
  // factory SaleSideWidget._internal() {
  //   return instance;
  // }

  //For retrieving selected Products (instead of State-Management)
  callback(List<ItemMasterModel> selectedProducts) {
    log('SaleSideWidget() => called!');

    _selectedProductsNotifier.value = selectedProducts;
    totalItemsNotifier.value = _selectedProductsNotifier.value.length;

    //adding subtotals to _subTotalNotfier from Selected Products
    for (var i = 0; i < _selectedProductsNotifier.value.length; i++) {
      _subTotalNotifier.value.add(_selectedProductsNotifier.value[i].itemCost);
      log('subotal == ' + _subTotalNotifier.value[i]);
    }
    _subTotalNotifier.notifyListeners();
    _selectedProductsNotifier.notifyListeners();
    getTotalAmount();
  }

  //==================== Value Notifiers ====================
  static final ValueNotifier<List<ItemMasterModel>> _selectedProductsNotifier =
      ValueNotifier([]);

  static final ValueNotifier<List<String>> _subTotalNotifier =
      ValueNotifier([]);

  static final ValueNotifier<int?> _customerIdNotifier = ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final _customerController = TextEditingController();
  static final List<TextEditingController> _quantityController = [];

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        _selectedProductsNotifier.value.clear();
        _subTotalNotifier.value.clear();
        _customerController.clear();
        _quantityController.clear();
        totalItemsNotifier.value = 0;
        totalQuantityNotifier.value = 0;
        _customerIdNotifier.value = null;
        return true;
      },
      child: SizedBox(
        width: _screenSize.width / 2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //==================== Get All Customers Search Field ====================
                Flexible(
                  flex: 8,
                  child: TypeAheadField(
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: false,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _customerController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 10,
                            minHeight: 10,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: const Icon(Icons.clear),
                              onTap: () {
                                _customerIdNotifier.value = null;
                                _customerController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Cash Customer',
                          border: const OutlineInputBorder(),
                        )),
                    noItemsFoundBuilder: (context) => const SizedBox(
                        height: 50,
                        child: Center(child: Text('No Customer Found!'))),
                    suggestionsCallback: (pattern) async {
                      return CustomerDatabase.instance
                          .getCustomerSuggestions(pattern);
                    },
                    itemBuilder: (context, CustomerModel suggestion) {
                      return ListTile(
                        title: AutoSizeText(suggestion.customer,
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            )),
                      );
                    },
                    onSuggestionSelected: (CustomerModel suggestion) {
                      _customerController.text = suggestion.customer;
                      _customerIdNotifier.value = suggestion.id;
                      log(suggestion.company);
                    },
                  ),
                ),
                kWidth5,

                //========== View Customer Button ==========
                Flexible(
                  flex: 1,
                  child: IconButton(
                      color: kBlack,
                      onPressed: () {
                        if (_customerIdNotifier.value != null) {
                          log('$_customerIdNotifier');

                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: kTransparentColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (context) => DismissibleWidget(
                                    context: context,
                                    child: CustomBottomSheetWidget(
                                        customerId: _customerIdNotifier.value),
                                  ));
                        } else {
                          showSnackBar(
                              context: context,
                              content:
                                  'Please select any Customer to show details!');
                        }
                      },
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.blue,
                      )),
                ),

                //========== Add Customer Button ==========
                Flexible(
                  flex: 1,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.blue,
                      )),
                ),
              ],
            ),

            //==================== Table Header ====================
            const SalesTableHeaderWidget(),

            //==================== Product Items Table ====================
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: _selectedProductsNotifier,
                  builder:
                      (context, List<ItemMasterModel> selectedProducts, child) {
                    return Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.30),
                        1: FractionColumnWidth(0.23),
                        2: FractionColumnWidth(0.12),
                        3: FractionColumnWidth(0.23),
                        4: FractionColumnWidth(0.12),
                      },
                      border: TableBorder.all(color: Colors.grey, width: 0.5),
                      children: List<TableRow>.generate(
                        selectedProducts.length,
                        (index) {
                          _quantityController
                              .add(TextEditingController(text: '1'));
                          getTotalQuantity();

                          return TableRow(children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                selectedProducts[index].itemName,
                                softWrap: true,
                                style: const TextStyle(fontSize: 9),
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 8,
                                maxFontSize: 10,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                selectedProducts[index].itemCost,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 9),
                                minFontSize: 8,
                                maxFontSize: 10,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                controller: _quantityController[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                                style:
                                    const TextStyle(fontSize: 9, color: kBlack),
                                onChanged: (value) {
                                  final qty = num.tryParse(value);
                                  if (qty != null) {
                                    log('$qty');
                                    getSubTotal(selectedProducts, index, qty);
                                    getTotalQuantity();
                                    getTotalAmount();
                                  }
                                },
                              ),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: ValueListenableBuilder(
                                    valueListenable: _subTotalNotifier,
                                    builder: (context, List<String> subTotal,
                                        child) {
                                      return AutoSizeText(
                                        subTotal[index],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 9),
                                        minFontSize: 8,
                                        maxFontSize: 10,
                                      );
                                    })),
                            Container(
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    selectedProducts.removeAt(index);
                                    _subTotalNotifier.value.removeAt(index);
                                    _quantityController.removeAt(index);
                                    _subTotalNotifier.notifyListeners();
                                    _selectedProductsNotifier.notifyListeners();
                                    totalItemsNotifier.value -= 1;
                                    getTotalQuantity();
                                    getTotalAmount();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 16,
                                  ),
                                ))
                          ]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            kHeight5,

            //==================== Price Sections ====================
            PriceSectionWidget(screenSize: _screenSize),

            //==================== Payment Buttons Widget ====================
            PaymentButtonsWidget(screenSize: _screenSize)
          ],
        ),
      ),
    );
  }

  //==================== Get SubTotal Amount ====================
  void getSubTotal(List<ItemMasterModel> selectedProducts, int index, num qty) {
    final cost = num.tryParse(
        selectedProducts[index].itemCost.replaceAll(RegExp(r'[^0-9]'), ''));

    final subTotal = cost! * qty;
    _subTotalNotifier.value[index] = '$subTotal';
    _subTotalNotifier.notifyListeners();
  }

  //==================== Get Total Quantity ====================
  void getTotalQuantity() async {
    num? _totalQuantiy = 0;

    for (var i = 0; i < _selectedProductsNotifier.value.length; i++) {
      _totalQuantiy =
          _totalQuantiy! + num.tryParse(_quantityController[i].value.text)!;
    }
    log('$_totalQuantiy');
    await Future.delayed(const Duration(milliseconds: 0));
    totalQuantityNotifier.value = _totalQuantiy!;
  }

  //==================== Get Total Amount ====================
  void getTotalAmount() {
    num? _totalAmount = 0;
    if (_subTotalNotifier.value.isEmpty) totalAmountNotifier.value = 0;
    for (var i = 0; i < _selectedProductsNotifier.value.length; i++) {
      log(_subTotalNotifier.value[i]);
      _totalAmount = _totalAmount! +
          num.tryParse(
              _subTotalNotifier.value[i].replaceAll(RegExp(r'[^0-9]'), ''))!;
      totalAmountNotifier.value = _totalAmount;
    }
  }
}
