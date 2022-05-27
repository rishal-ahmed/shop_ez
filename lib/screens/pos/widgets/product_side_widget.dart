// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../db/db_functions/brand/brand_database.dart';
import '../../../db/db_functions/category/category_db.dart';
import '../../../db/db_functions/item_master/item_master_database.dart';
import '../../../db/db_functions/sub_category/sub_category_db.dart';
import '../../../model/item_master/item_master_model.dart';
import '../../../widgets/button_widgets/material_button_widget.dart';

class ProductSideWidget extends StatefulWidget {
  const ProductSideWidget({
    Key? key,
    this.isVertical = false,
  }) : super(key: key);

  final bool isVertical;

  //========== Value Notifiers ==========
  static final ValueNotifier<List<dynamic>> itemsNotifier = ValueNotifier([]);

  @override
  State<ProductSideWidget> createState() => _ProductSideWidgetState();
}

class _ProductSideWidgetState extends State<ProductSideWidget> {
  //========== Database Instances ==========
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final itemMasterDB = ItemMasterDatabase.instance;

  //========== FutureBuilder Database ==========
  Future<List<dynamic>>? futureGrid = ItemMasterDatabase.instance.getAllItems();

  //========== FutureBuilder ModelClass by Integer ==========
  int? _builderModel;

  //========== Lists ==========
  List categories = [], subCategories = [], brands = [], itemsList = [];

  //========== MediaQuery Screen Size ==========
  late Size _screenSize;

  //========== TextEditing Controllers ==========
  final _productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _builderModel = null;
    return SizedBox(
      width: widget.isVertical ? double.infinity : _screenSize.width / 1.9,
      height: widget.isVertical ? _screenSize.height / 2.25 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //==================== Search & Filter ====================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Get All Products Search Field ==========
                  Flexible(
                    flex: 9,
                    child: TypeAheadField(
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _productController,
                          style: const TextStyle(fontSize: 12),
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
                                onTap: () async {
                                  _productController.clear();
                                  _builderModel = null;
                                  futureGrid = ItemMasterDatabase.instance.getAllItems();
                                  if (itemsList.isNotEmpty) {
                                    ProductSideWidget.itemsNotifier.value = itemsList;
                                  } else {
                                    itemsList = await itemMasterDB.getAllItems();
                                    ProductSideWidget.itemsNotifier.value = itemsList;
                                  }
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Search product by name/code',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!'))),
                      suggestionsCallback: (pattern) async {
                        return itemMasterDB.getProductSuggestions(pattern);
                      },
                      itemBuilder: (context, ItemMasterModel suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.itemName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kText_10_12,
                          ),
                        );
                      },
                      onSuggestionSelected: (ItemMasterModel selectedItem) async {
                        _productController.text = selectedItem.itemName;
                        Future<List<dynamic>> future() async => [selectedItem];
                        futureGrid = future();
                        _builderModel = null;
                        ProductSideWidget.itemsNotifier.value = [selectedItem];
                        log(selectedItem.itemName);
                      },
                    ),
                  ),
                  kWidth5,
                  //========== Barcode Scanner Button ==========
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      child: IconButton(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          maxHeight: 30,
                        ),
                        onPressed: () async => await onBarcodeScan(),
                        icon: const Icon(Icons.qr_code, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              widget.isVertical ? kHeight5 : kNone,
              //========== Get All Customers Search Field ==========
              widget.isVertical
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 8,
                          child: TypeAheadField(
                            debounceDuration: const Duration(milliseconds: 500),
                            hideSuggestionsOnKeyboardHide: true,
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: SaleSideWidget.customerController,
                                style: const TextStyle(fontSize: 12),
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
                                        SaleSideWidget.customerIdNotifier.value = null;
                                        SaleSideWidget.customerController.clear();
                                      },
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: 'Customer',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: const OutlineInputBorder(),
                                )),
                            noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Customer Found!'))),
                            suggestionsCallback: (pattern) async {
                              return CustomerDatabase.instance.getCustomerSuggestions(pattern);
                            },
                            itemBuilder: (context, CustomerModel suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion.customer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10),
                                ),
                              );
                            },
                            onSuggestionSelected: (CustomerModel suggestion) {
                              SaleSideWidget.customerController.text = suggestion.customer;
                              SaleSideWidget.customerNameNotifier.value = suggestion.customer;
                              SaleSideWidget.customerIdNotifier.value = suggestion.id;
                              log(suggestion.company);
                            },
                          ),
                        ),
                        kWidth5,

                        //========== View Customer Button ==========
                        Flexible(
                          flex: 1,
                          child: FittedBox(
                            child: IconButton(
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                constraints: const BoxConstraints(
                                  minHeight: 30,
                                  maxHeight: 30,
                                ),
                                onPressed: () {
                                  if (SaleSideWidget.customerIdNotifier.value != null) {
                                    log('Customer Id == ${SaleSideWidget.customerIdNotifier.value}');

                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: kTransparentColor,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                        builder: (context) => DismissibleWidget(
                                              context: context,
                                              child: CustomBottomSheetWidget(id: SaleSideWidget.customerIdNotifier.value),
                                            ));
                                  } else {
                                    kSnackBar(context: context, content: 'Please select any Customer to show details!');
                                  }
                                },
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                  size: 25,
                                )),
                          ),
                        ),

                        //========== Add Customer Button ==========
                        Flexible(
                          flex: 1,
                          child: FittedBox(
                            child: IconButton(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(
                                minHeight: 30,
                                maxHeight: 30,
                              ),
                              onPressed: () async {
                                // OrientationMode.isLandscape = false;
                                // await OrientationMode.toPortrait();
                                final id = await Navigator.pushNamed(context, routeAddCustomer, arguments: true);

                                if (id != null) {
                                  final addedCustomer = await CustomerDatabase.instance.getCustomerById(id as int);

                                  SaleSideWidget.customerController.text = addedCustomer.customer;
                                  SaleSideWidget.customerNameNotifier.value = addedCustomer.customer;
                                  SaleSideWidget.customerIdNotifier.value = addedCustomer.id;
                                  log(addedCustomer.company);
                                }

                                // await OrientationMode.toLandscape();
                              },
                              icon: const Icon(
                                Icons.person_add,
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : kNone
            ],
          ),

          //==================== Quick Filter Buttons ====================
          Padding(
            padding: widget.isVertical ? const EdgeInsets.symmetric(vertical: 5.0) : const EdgeInsets.only(bottom: 5),
            child: SizedBox(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: CustomMaterialBtton(
                        buttonColor: Colors.blue,
                        onPressed: () async {
                          _builderModel = 0;

                          if (categories.isNotEmpty) {
                            log('loading Categories..');
                            ProductSideWidget.itemsNotifier.value = categories;
                            ProductSideWidget.itemsNotifier.notifyListeners();
                          } else {
                            log('fetching Categories..');
                            categories = await categoryDB.getAllCategories();
                            ProductSideWidget.itemsNotifier.value = categories;
                            ProductSideWidget.itemsNotifier.notifyListeners();
                          }
                        },
                        padding: kPadding0,
                        fontSize: 12,
                        buttonText: 'Categories'),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 5,
                    child: CustomMaterialBtton(
                        onPressed: () async {
                          _builderModel = 1;
                          if (subCategories.isNotEmpty) {
                            ProductSideWidget.itemsNotifier.value = subCategories;
                          } else {
                            subCategories = await subCategoryDB.getAllSubCategories();
                            ProductSideWidget.itemsNotifier.value = subCategories;
                          }
                        },
                        padding: kPadding0,
                        fontSize: 12,
                        buttonColor: Colors.orange,
                        buttonText: 'Sub Categories'),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 3,
                    child: CustomMaterialBtton(
                      onPressed: () async {
                        _builderModel = 2;
                        if (brands.isNotEmpty) {
                          ProductSideWidget.itemsNotifier.value = brands;
                        } else {
                          brands = await brandDB.getAllBrands();
                          ProductSideWidget.itemsNotifier.value = brands;
                        }
                      },
                      padding: kPadding0,
                      buttonColor: Colors.indigo,
                      fontSize: 12,
                      buttonText: 'Brands',
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: () async {
                        _productController.clear();
                        _builderModel = null;

                        if (itemsList.isNotEmpty) {
                          ProductSideWidget.itemsNotifier.value = itemsList;
                        } else {
                          itemsList = await itemMasterDB.getAllItems();
                          ProductSideWidget.itemsNotifier.value = itemsList;
                        }
                      },
                      color: Colors.blue,
                      child: const Icon(
                        Icons.rotate_left,
                        color: kWhite,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          //==================== Product Listing Grid ====================
          Expanded(
            flex: widget.isVertical ? 1 : 1,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FutureBuilder(
                  future: futureGrid,
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    log('Future Builder() => Called!');

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.done:
                      default:
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('No Item Found!'),
                          );
                        }
                        if (snapshot.hasData) {
                          ProductSideWidget.itemsNotifier.value = snapshot.data!;
                        } else {
                          ProductSideWidget.itemsNotifier.value = [];
                        }

                        return ValueListenableBuilder(
                          valueListenable: ProductSideWidget.itemsNotifier,
                          builder: (context, List<dynamic> itemList, _) {
                            log('Total Products == ${ProductSideWidget.itemsNotifier.value.length}');

                            return ProductSideWidget.itemsNotifier.value.isNotEmpty
                                ? GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: widget.isVertical ? 4 : 5,
                                      childAspectRatio: (1 / .75),
                                    ),
                                    itemCount: itemList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          if (_builderModel == 0) {
                                            log(itemList[index].category);
                                            final categoryId = itemList[index].id;
                                            _builderModel = null;
                                            ProductSideWidget.itemsNotifier.value = await itemMasterDB.getProductByCategoryId(categoryId);
                                          } else if (_builderModel == 1) {
                                            log(itemList[index].subCategory);
                                            final subCategoryId = itemList[index].id;
                                            _builderModel = null;
                                            ProductSideWidget.itemsNotifier.value = await itemMasterDB.getProductBySubCategoryId(subCategoryId);
                                          } else if (_builderModel == 2) {
                                            log(itemList[index].brand);
                                            final brandId = itemList[index].id;
                                            _builderModel = null;
                                            ProductSideWidget.itemsNotifier.value = await itemMasterDB.getProductByBrandId(brandId);
                                          } else {
                                            //===================================== if the Product Already Added ====================================
                                            isProductAlreadyAdded(itemList as List<ItemMasterModel>, index);
                                            //=======================================================================================================

                                            SaleSideWidget.selectedProductsNotifier.notifyListeners();

                                            SaleSideWidget.totalQuantityNotifier.value++;
                                          }
                                        },
                                        child: Card(
                                          elevation: 10,
                                          child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                              child: _builderModel == null
                                                  ? Column(
                                                      children: [
                                                        Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            itemList[index].itemName ?? '',
                                                            textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            style: kItemsTextStyle,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Qty : ' + itemList[index].openingStock,
                                                            textAlign: TextAlign.center,
                                                            style: kItemsTextStyle,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            Converter.currency.format(num.tryParse(itemList[index].sellingPrice)),
                                                            style: kItemsTextStyle,
                                                            maxLines: 1,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          _builderModel == 0
                                                              ? itemList[index].category
                                                              : _builderModel == 1
                                                                  ? itemList[index].subCategory
                                                                  : _builderModel == 2
                                                                      ? itemList[index].brand
                                                                      : '',
                                                          textAlign: TextAlign.center,
                                                          softWrap: true,
                                                          style: kItemsTextStyle,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: _builderModel == 0 && itemList[index].category.toString().contains(' ')
                                                              ? 2
                                                              : _builderModel == 1 && itemList[index].subCategory.toString().contains(' ')
                                                                  ? 2
                                                                  : _builderModel == 2 && itemList[index].brand.toString().contains(' ')
                                                                      ? 2
                                                                      : 1,
                                                        ),
                                                      ],
                                                    )),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text('No Item Found!'),
                                  );
                          },
                        );
                      // : const Center(
                      //     child: Text('No Item Found!'),
                      //   );
                    }
                  },
                )),
          )
        ],
      ),
    );
  }

// Checking if the product already added then Increasing the Quantity
//====================================================================
  void isProductAlreadyAdded(List<ItemMasterModel> itemList, int index) {
    final vatMethod = itemList[index].vatMethod;
    log('VAT Method = ' + vatMethod);

    for (var i = 0; i < SaleSideWidget.selectedProductsNotifier.value.length; i++) {
      //========== If Product already added ==========
      if (SaleSideWidget.selectedProductsNotifier.value[i].id == itemList[index].id) {
        final _currentQty = num.tryParse(SaleSideWidget.quantityNotifier.value[i].value.text);

        SaleSideWidget.quantityNotifier.value[i].text = '${_currentQty! + 1}';

//==================== On Item Quantity Changed ====================
        const SaleSideWidget().onItemQuantityChanged(
          SaleSideWidget.quantityNotifier.value[i].text,
          SaleSideWidget.selectedProductsNotifier.value,
          i,
        );
        return;
      }
    }
    SaleSideWidget.selectedProductsNotifier.value.add(itemList[index]);

    final String unitPrice = vatMethod == 'Inclusive'
        ? Converter.amountRounder(
            const SaleSideWidget().getExclusiveAmount(sellingPrice: itemList[index].sellingPrice, vatRate: itemList[index].vatRate))
        : Converter.amountRounder(num.tryParse(itemList[index].sellingPrice)!);

    SaleSideWidget.unitPriceNotifier.value.add(TextEditingController(text: unitPrice));

    SaleSideWidget.quantityNotifier.value.add(TextEditingController(text: '1'));

    SaleSideWidget.subTotalNotifier.value.add(vatMethod == 'Inclusive'
        ? '${const SaleSideWidget().getExclusiveAmount(sellingPrice: itemList[index].sellingPrice, vatRate: itemList[index].vatRate)}'
        : itemList[index].sellingPrice);

    SaleSideWidget.totalItemsNotifier.value++;

    const SaleSideWidget().getItemVat(vatMethod: vatMethod, amount: itemList[index].sellingPrice, vatRate: itemList[index].vatRate);
    const SaleSideWidget().getTotalAmount();
    const SaleSideWidget().getTotalVAT();
    const SaleSideWidget().getTotalPayable();
  }

  Future onBarcodeScan() async {
    final String _scanResult;

    try {
      _scanResult = await FlutterBarcodeScanner.scanBarcode(
        scannerColor,
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      log('Item Code == $_scanResult');
      if (_scanResult == '-1') return;
      final String _itemCode = _scanResult;
      _builderModel = null;
      ProductSideWidget.itemsNotifier.value = await itemMasterDB.getProductByItemCode(_itemCode);
    } on PlatformException catch (_) {
      log('Failed to get Platform version!');
    } catch (e) {
      log(e.toString());
    }

    if (!mounted) return;
  }
}
