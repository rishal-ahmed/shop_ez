// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_buttons_widget.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_price_section.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../core/utils/device/device.dart';
import '../../../core/utils/snackbar/snackbar.dart';

class SalesReturnSideWidget extends StatelessWidget {
  const SalesReturnSideWidget({
    Key? key,
  }) : super(key: key);

  //==================== Value Notifiers ====================
  static final ValueNotifier<List<ItemMasterModel>> selectedProductsNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<String>> subTotalNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> itemTotalVatNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> quantityNotifier =
      ValueNotifier([]);

  static final ValueNotifier<String?> originalInvoiceNumberNotifier =
      ValueNotifier(null);
  static final ValueNotifier<int?> originalSaleIdNotifier = ValueNotifier(null);

  static final ValueNotifier<int?> customerIdNotifier = ValueNotifier(null);
  static final ValueNotifier<String?> customerNameNotifier =
      ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalVatNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalPayableNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final customerController = TextEditingController();
  static final saleInvoiceController = TextEditingController();

  //========== Database Instances ==========
  static final SalesDatabase salesDB = SalesDatabase.instance;
  static final SalesItemsDatabase salesItemDB = SalesItemsDatabase.instance;
  static final ItemMasterDatabase itemDB = ItemMasterDatabase.instance;

  @override
  Widget build(BuildContext context) {
    //========== Device Utils ==========
    final bool _isTablet = DeviceUtil.isTablet;
    Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        selectedProductsNotifier.value.clear();
        subTotalNotifier.value.clear();
        itemTotalVatNotifier.value.clear();
        customerController.clear();
        saleInvoiceController.clear();
        quantityNotifier.value.clear();
        totalItemsNotifier.value = 0;
        totalQuantityNotifier.value = 0;
        totalAmountNotifier.value = 0;
        totalVatNotifier.value = 0;
        totalPayableNotifier.value = 0;
        customerIdNotifier.value = null;
        customerNameNotifier.value = null;
        originalInvoiceNumberNotifier.value = null;
        originalSaleIdNotifier.value = null;
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
                //==================== Get All Customer Search Field ====================
                Flexible(
                  flex: 5,
                  child: ValueListenableBuilder(
                      valueListenable: originalSaleIdNotifier,
                      builder: (context, _, __) {
                        return TypeAheadField(
                          debounceDuration: const Duration(milliseconds: 500),
                          hideSuggestionsOnKeyboardHide: true,
                          textFieldConfiguration: TextFieldConfiguration(
                              enabled: originalSaleIdNotifier.value == null,
                              controller: customerController,
                              style: kText_10_12,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true,
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 10,
                                ),
                                suffixIcon: Padding(
                                  padding: kClearTextIconPadding,
                                  child: InkWell(
                                    child: const Icon(Icons.clear, size: 15),
                                    onTap: () {
                                      customerIdNotifier.value = null;
                                      customerController.clear();
                                    },
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(10),
                                hintText: 'Customer',
                                hintStyle: kText_10_12,
                                border: const OutlineInputBorder(),
                              )),
                          noItemsFoundBuilder: (context) => const SizedBox(
                              height: 50,
                              child: Center(child: Text('No customer Found!'))),
                          suggestionsCallback: (pattern) async {
                            return CustomerDatabase.instance
                                .getCustomerSuggestions(pattern);
                          },
                          itemBuilder: (context, CustomerModel suggestion) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: AutoSizeText(
                                suggestion.customer,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: _isTablet ? 12 : 10),
                                minFontSize: 10,
                                maxFontSize: 12,
                              ),
                            );
                          },
                          onSuggestionSelected: (CustomerModel suggestion) {
                            customerController.text = suggestion.customer;
                            customerNameNotifier.value = suggestion.customer;
                            customerIdNotifier.value = suggestion.id;
                            log(suggestion.company);
                          },
                        );
                      }),
                ),
                kWidth5,

                //==================== Get All Sales Invoices ====================
                Flexible(
                  flex: 5,
                  child: TypeAheadField(
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: saleInvoiceController,
                        style: kText_10_12,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 10,
                            minHeight: 10,
                          ),
                          suffixIcon: Padding(
                            padding: kClearTextIconPadding,
                            child: InkWell(
                              child: const Icon(
                                Icons.clear,
                                size: 15,
                              ),
                              onTap: () async {
                                saleInvoiceController.clear();
                                if (originalSaleIdNotifier.value != null) {
                                  return resetSalesReturn();
                                }
                                originalInvoiceNumberNotifier.value = null;
                                originalSaleIdNotifier.value = null;
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Invoice No',
                          hintStyle: kText_10_12,
                          border: const OutlineInputBorder(),
                        )),
                    noItemsFoundBuilder: (context) => SizedBox(
                        height: 50,
                        child: Center(
                            child:
                                Text('No Invoice Found!', style: kText_10_12))),
                    suggestionsCallback: (pattern) async {
                      return await salesDB
                          .getSalesByInvoiceSuggestions(pattern);
                    },
                    itemBuilder: (context, SalesModel suggestion) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          suggestion.invoiceNumber!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kText_10_12,
                        ),
                      );
                    },
                    onSuggestionSelected: (SalesModel sale) async {
                      resetSalesReturn();
                      saleInvoiceController.text = sale.invoiceNumber!;
                      originalInvoiceNumberNotifier.value = sale.invoiceNumber!;
                      originalSaleIdNotifier.value = sale.id;
                      await getSalesDetails(sale);

                      log(sale.invoiceNumber!);
                    },
                  ),
                ),
                kWidth5,

                //========== View customer Button ==========
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    child: IconButton(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minHeight: 45,
                          maxHeight: 45,
                        ),
                        onPressed: () {
                          if (customerIdNotifier.value != null) {
                            log('${customerIdNotifier.value}');

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
                                        id: customerIdNotifier.value,
                                        supplier: false,
                                      ),
                                    ));
                          } else {
                            kSnackBar(
                                context: context,
                                content:
                                    'Please select any Customer to show details!');
                          }
                        },
                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.blue,
                          size: 25,
                        )),
                  ),
                ),

                //========== Add customer Button ==========
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    child: IconButton(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minHeight: 45,
                          maxHeight: 45,
                        ),
                        onPressed: () async {
                          // DeviceUtil.isLandscape = false;
                          // await DeviceUtil.toPortrait();
                          final id = await Navigator.pushNamed(
                              context, routeCustomer,
                              arguments: true);

                          if (id != null) {
                            final addedCustomer = await CustomerDatabase
                                .instance
                                .getCustomerById(id as int);

                            customerController.text = addedCustomer.customer;
                            customerNameNotifier.value = addedCustomer.customer;
                            customerIdNotifier.value = addedCustomer.id;
                            log(addedCustomer.company);
                          }

                          // await DeviceUtil.toLandscape();
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.blue,
                          size: 25,
                        )),
                  ),
                ),
              ],
            ),

            kHeight5,
            //==================== Table Header ====================
            const SalesTableHeaderWidget(),

            //==================== Product Items Table ====================
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: selectedProductsNotifier,
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
                          final ItemMasterModel _product =
                              selectedProducts[index];
                          return TableRow(children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                _product.itemName,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: DeviceUtil.isTablet ? 10 : 7),
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 7,
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
                                _product.vatMethod == 'Exclusive'
                                    ? Converter.currency.format(
                                        num.parse(_product.sellingPrice))
                                    : Converter.currency.format(
                                        getExclusiveAmount(
                                            sellingPrice: _product.sellingPrice,
                                            vatRate: _product.vatRate)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: DeviceUtil.isTablet ? 10 : 7),
                                minFontSize: 7,
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
                                controller: quantityNotifier.value[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                                style: TextStyle(
                                    fontSize: DeviceUtil.isTablet ? 10 : 7,
                                    color: kBlack),
                                onChanged: (value) {
                                  onItemQuantityChanged(
                                      value, selectedProducts, index);
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
                                    valueListenable: subTotalNotifier,
                                    builder: (context, List<String> subTotal,
                                        child) {
                                      return AutoSizeText(
                                        Converter.currency.format(
                                            num.tryParse(subTotal[index])),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                DeviceUtil.isTablet ? 10 : 7),
                                        minFontSize: 7,
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
                                    subTotalNotifier.value.removeAt(index);
                                    itemTotalVatNotifier.value.removeAt(index);
                                    quantityNotifier.value.removeAt(index);
                                    subTotalNotifier.notifyListeners();
                                    selectedProductsNotifier.notifyListeners();
                                    totalItemsNotifier.value -= 1;
                                    getTotalQuantity();
                                    getTotalAmount();
                                    getTotalVAT();
                                    getTotalPayable();
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
            const SalesReturnPriceSectionWidget(),

            //==================== Payment Buttons Widget ====================
            const SalesReturnButtonsWidget()
          ],
        ),
      ),
    );
  }

  //==================== On Item Quantity Changed ====================
  void onItemQuantityChanged(
      String value, List<ItemMasterModel> selectedProducts, int index) {
    final qty = num.tryParse(value);
    if (qty != null) {
      getTotalQuantity();
      getSubTotal(selectedProducts, index, qty);
      getTotalAmount();
      getTotalVAT();
      getTotalPayable();
    }
  }

  //==================== Get SubTotal Amount ====================
  void getSubTotal(List<ItemMasterModel> selectedProducts, int index, num qty) {
    final cost = num.tryParse(selectedProducts[index].sellingPrice);
    final vatRate = selectedProducts[index].vatRate;
    if (selectedProducts[index].vatMethod == 'Inclusive') {
      final _exclusiveCost = getExclusiveAmount(
          sellingPrice: selectedProducts[index].sellingPrice, vatRate: vatRate);
      final _subTotal = _exclusiveCost * qty;
      subTotalNotifier.value[index] = '$_subTotal';
    } else {
      final _subTotal = cost! * qty;
      subTotalNotifier.value[index] = '$_subTotal';
    }

    subTotalNotifier.notifyListeners();
  }

  //==================== Get Total Quantity ====================
  Future<void> getTotalQuantity() async {
    num? _totalQuantiy = 0;

    for (var i = 0; i < selectedProductsNotifier.value.length; i++) {
      _totalQuantiy =
          _totalQuantiy! + num.tryParse(quantityNotifier.value[i].value.text)!;
    }
    await Future.delayed(const Duration(milliseconds: 0));
    totalQuantityNotifier.value = _totalQuantiy!;
  }

  //==================== Get Total Amount ====================
  void getTotalAmount() {
    num? _totalAmount = 0;
    num? subTotal = 0;
    if (subTotalNotifier.value.isEmpty) {
      totalAmountNotifier.value = 0;
    } else {
      for (var i = 0; i < subTotalNotifier.value.length; i++) {
        if (selectedProductsNotifier.value[i].vatMethod == 'Inclusive') {
          subTotal = num.tryParse(subTotalNotifier.value[i]);
        } else {
          subTotal = num.tryParse(subTotalNotifier.value[i]);
        }

        _totalAmount = _totalAmount! + subTotal!;
      }
      totalAmountNotifier.value = _totalAmount!;
      log('Total Amount ==  $_totalAmount');
    }
  }

  //==================== Get Item VAT ====================
  void getItemVat({
    required String vatMethod,
    required String amount,
    required int vatRate,
  }) {
    num? itemTotalVat;
    num sellingPrice = num.parse(amount);

    if (vatMethod == 'Inclusive') {
      sellingPrice =
          getExclusiveAmount(sellingPrice: '$sellingPrice', vatRate: vatRate);
    }

    itemTotalVat = sellingPrice * vatRate / 100;
    log('Item VAT == $itemTotalVat');
    itemTotalVatNotifier.value.add('$itemTotalVat');
  }

  //==================== Get Total VAT ====================
  void getTotalVAT() {
    num _totalVAT = 0;
    int _vatRate;
    num _subTotal;

    if (subTotalNotifier.value.isEmpty) {
      totalVatNotifier.value = 0;
    } else {
      for (var i = 0; i < subTotalNotifier.value.length; i++) {
        _subTotal = num.parse(subTotalNotifier.value[i]);
        _vatRate = selectedProductsNotifier.value[i].vatRate;
        itemTotalVatNotifier.value[i] = '${_subTotal * _vatRate / 100}';

        log('Item Total VAT == ${itemTotalVatNotifier.value[i]}');

        _totalVAT += _subTotal * _vatRate / 100;
      }
      log('Total VAT == $_totalVAT');
      totalVatNotifier.value = _totalVAT;
    }
  }

  //==================== Calculate Exclusive Amount from Inclusive Amount ====================
  num getExclusiveAmount({required String sellingPrice, required int vatRate}) {
    num _exclusiveAmount = 0;
    num percentageYouHave = vatRate + 100;

    final _inclusiveAmount = num.tryParse(sellingPrice);

    _exclusiveAmount = _inclusiveAmount! * 100 / percentageYouHave;

    // log('Product VAT == ' '${_inclusiveAmount * 15 / 115}');
    // log('Exclusive == ' '${_inclusiveAmount * 100 / 115}');
    // log('Inclusive == ' '${_inclusiveAmount * 115 / 100}');

    return _exclusiveAmount;
  }

//==================== Get Total VAT ====================
  void getTotalPayable() {
    final num _totalPayable =
        totalAmountNotifier.value + totalVatNotifier.value;
    totalPayableNotifier.value = _totalPayable;
    log('Total Payable == $_totalPayable');
  }

  //==================== Reset All Values ====================
  void resetSalesReturn() {
    selectedProductsNotifier.value.clear();
    subTotalNotifier.value.clear();
    itemTotalVatNotifier.value.clear();
    customerController.clear();
    saleInvoiceController.clear();
    quantityNotifier.value.clear();
    totalItemsNotifier.value = 0;
    totalQuantityNotifier.value = 0;
    totalAmountNotifier.value = 0;
    totalVatNotifier.value = 0;
    totalPayableNotifier.value = 0;
    customerIdNotifier.value = null;
    customerNameNotifier.value = null;
    originalInvoiceNumberNotifier.value = null;
    originalSaleIdNotifier.value = null;

    selectedProductsNotifier.notifyListeners();
    subTotalNotifier.notifyListeners();
    itemTotalVatNotifier.notifyListeners();
    quantityNotifier.notifyListeners();
    totalItemsNotifier.notifyListeners();
    totalQuantityNotifier.notifyListeners();
    totalAmountNotifier.notifyListeners();
    totalVatNotifier.notifyListeners();
    totalPayableNotifier.notifyListeners();
    customerIdNotifier.notifyListeners();
    customerNameNotifier.notifyListeners();
    originalInvoiceNumberNotifier.notifyListeners();
    originalSaleIdNotifier.notifyListeners();

    log('========== Sales Return values has been cleared! ==========');
  }

  //==================== Get Sales Details ====================
  Future<void> getSalesDetails(SalesModel sale) async {
    final List<ItemMasterModel> soldItems = [];

    customerController.text = sale.customerName;
    customerIdNotifier.value = sale.customerId;
    customerNameNotifier.value = sale.customerName;

    final salesItems = await salesItemDB.getSalesItemBySaleId(sale.id!);

    for (var i = 0; i < salesItems.length; i++) {
      final soldItem = salesItems[i];
      final items = await itemDB.getProductById(int.parse(soldItem.productId));
      final item = items.first;

      log('item Id == ' '${item.id}');
      log('item Name == ' + item.itemName);
      log('Category == ' + soldItem.category);
      log('Product Code == ' + soldItem.productCode);
      log('Cost == ' + soldItem.productCost);
      log('Unit Price == ' + soldItem.unitPrice);
      log('Net Unit Price == ' + soldItem.netUnitPrice);
      log('Quantity == ' + soldItem.quantity);
      log('Unit Code == ' + soldItem.unitCode);
      log('Vat Id == ' + soldItem.vatId);
      log('Products Vat Method == ' + item.vatMethod);
      log('Vat Method == ' + item.vatMethod);
      log('Vat Percentage == ' + soldItem.vatPercentage);
      log('Vat Total == ' + soldItem.vatTotal);

      soldItems.add(ItemMasterModel(
        id: item.id,
        productType: soldItem.productType,
        itemName: soldItem.productName,
        itemNameArabic: item.itemNameArabic,
        itemCode: soldItem.productCode,
        itemCategory: soldItem.category,
        itemSubCategory: item.itemSubCategory,
        itemBrand: item.itemBrand,
        itemCost: soldItem.productCost,
        sellingPrice: soldItem.unitPrice,
        secondarySellingPrice: item.secondarySellingPrice,
        vatMethod: item.vatMethod,
        productVAT: item.productVAT,
        vatId: soldItem.vatId,
        vatRate: item.vatRate,
        unit: soldItem.unitCode,
        expiryDate: item.expiryDate,
        openingStock: item.openingStock,
        alertQuantity: item.alertQuantity,
        itemImage: item.itemImage,
      ));

      quantityNotifier.value
          .add(TextEditingController(text: soldItem.quantity));

      subTotalNotifier.value.add(soldItem.subTotal);
      itemTotalVatNotifier.value.add(soldItem.vatTotal);
    }

    selectedProductsNotifier.value = soldItems;
    await getTotalQuantity();
    log(totalQuantityNotifier.value.toString());

    totalItemsNotifier.value = num.parse(sale.totalItems);
    totalAmountNotifier.value = num.parse(sale.subTotal);
    totalVatNotifier.value = num.parse(sale.vatAmount);
    totalPayableNotifier.value = num.parse(sale.grantTotal);

    selectedProductsNotifier.notifyListeners();
    subTotalNotifier.notifyListeners();
    itemTotalVatNotifier.notifyListeners();
    quantityNotifier.notifyListeners();
    totalItemsNotifier.notifyListeners();
    totalQuantityNotifier.notifyListeners();
    totalAmountNotifier.notifyListeners();
    totalVatNotifier.notifyListeners();
    totalPayableNotifier.notifyListeners();
    customerIdNotifier.notifyListeners();
    customerNameNotifier.notifyListeners();
    originalInvoiceNumberNotifier.notifyListeners();
    originalSaleIdNotifier.notifyListeners();
  }
}