import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/customer_database/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/pos/widgets/price_section_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

//========== TextEditing Controllers ==========
  final _customerController = TextEditingController();

//========== MediaQuery Screen Size ==========
  late Size _screenSize;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: _screenSize.width * .015,
              horizontal: _screenSize.width * .02),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            //==================== Both Sides ====================
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //==================== Left Side ====================
                SaleSideWidget(
                  screenSize: _screenSize,
                  customerController: _customerController,
                ),
                kWidth20,

                //==================== Right Side ====================
                ProductSideWidget(screenSize: _screenSize)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//==================== Sale Side Widget ====================
class SaleSideWidget extends StatefulWidget {
  const SaleSideWidget({
    Key? key,
    required this.customerController,
    required Size screenSize,
  })  : _screenSize = screenSize,
        super(key: key);

//========== MediaQuery Screen Size ==========
  final Size _screenSize;

//========== TextEditing Controllers ==========
  final TextEditingController customerController;

  @override
  State<SaleSideWidget> createState() => _SaleSideWidgetState();
}

class _SaleSideWidgetState extends State<SaleSideWidget> {
  int? _customerId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._screenSize.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //========== Get All Customers Search Field ==========
              Flexible(
                flex: 8,
                child: TypeAheadField(
                  debounceDuration: const Duration(milliseconds: 500),
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: widget.customerController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Cash Customer',
                        border: OutlineInputBorder(),
                      )),
                  noItemsFoundBuilder: (context) => const SizedBox(
                      height: 50,
                      child: Center(child: Text('No Customer Found!'))),
                  suggestionsCallback: (pattern) async {
                    return CustomerDatabase.instance
                        .getCustomerSuggestions(pattern);
                  },
                  itemBuilder: (context, CustomerModel suggestion) {
                    return ListTile(title: Text(suggestion.customer));
                  },
                  onSuggestionSelected: (CustomerModel suggestion) {
                    widget.customerController.text = suggestion.customer;
                    _customerId = suggestion.id;
                    setState(() {});
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
                      if (_customerId != null) {
                        log('$_customerId');

                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: kTransparentColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) => customerSheet());
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
              child: Table(
                columnWidths: const {
                  0: FractionColumnWidth(0.30),
                  1: FractionColumnWidth(0.23),
                  2: FractionColumnWidth(0.12),
                  3: FractionColumnWidth(0.23),
                  4: FractionColumnWidth(0.12),
                },
                border: TableBorder.all(color: Colors.grey, width: 0.5),
                children: List<TableRow>.generate(
                  10,
                  (index) => TableRow(children: [
                    Container(
                      color: Colors.white,
                      height: 30,
                      child: const Center(
                        child: Text('Apple',
                            style: TextStyle(
                              color: kBlack,
                            )),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 30,
                      child: const Center(
                        child: Text(
                          '130.0',
                          style: TextStyle(
                            color: kBlack,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 30,
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: kBlack,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 30,
                      child: const Center(
                        child: Text(
                          '130.0',
                          style: TextStyle(
                            color: kBlack,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        color: Colors.white,
                        height: 30,
                        child: const Center(
                            child: Icon(
                          Icons.close,
                          size: 18,
                        )))
                  ]),
                ),
              ),
            ),
          ),
          kHeight5,

          //==================== Price Sections ====================
          PriceSectionWidget(screenSize: widget._screenSize),

          //==================== Payment Buttons Widget ====================
          PaymentButtonsWidget(screenSize: widget._screenSize)
        ],
      ),
    );
  }

  Widget makeDismissable({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: child,
      );

  //==================== Customer Bottom Sheet ====================
  Widget customerSheet() {
    return makeDismissable(
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * .50,
              vertical: MediaQuery.of(context).size.height * .05),
          child: SingleChildScrollView(
              controller: scrollController,
              child: FutureBuilder(
                future: CustomerDatabase.instance.getCustomerById(_customerId!),
                builder: (context, AsyncSnapshot<CustomerModel> snapshot) =>
                    snapshot.hasData
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const AutoSizeText(
                                    'Customer Type',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const AutoSizeText(
                                    '  : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.customerType,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const AutoSizeText(
                                    'Company',
                                    maxFontSize: 50,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const AutoSizeText(
                                    '  : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.company,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Company Arabic : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.companyArabic,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Customer Name : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.customer,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Customer Name Arabic : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.customerArabic,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'VAT Number : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.vatNumber!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Email : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.email!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Address : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.address!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Address Arabic : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.addressArabic!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'City : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.city!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'City Arabic : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.cityArabic!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'State : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.state!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'State Arabic : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.stateArabic!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Country : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.country!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'Country Arabic : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.countryArabic!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const AutoSizeText(
                                    'PO Box : ',
                                    maxFontSize: 50,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  AutoSizeText(
                                    snapshot.data!.poBox!,
                                    maxFontSize: 50,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              kHeight10,
                            ],
                          )
                        : const CircularProgressIndicator(),
              )),
        ),
      ),
    );
  }
}

//==================== Product Side Widget ====================
class ProductSideWidget extends StatelessWidget {
  const ProductSideWidget({
    Key? key,
    required Size screenSize,
  })  : _screenSize = screenSize,
        super(key: key);

  final Size _screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _screenSize.width / 1.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              hintText: 'Search product by name/code',
              border: OutlineInputBorder(),
            ),
          ),

          //==================== Quick Filter Buttons ====================
          Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomMaterialBtton(
                    buttonColor: Colors.blue,
                    onPressed: () {},
                    buttonText: 'Categories'),
              ),
              kWidth5,
              Expanded(
                flex: 5,
                child: CustomMaterialBtton(
                    onPressed: () {},
                    buttonColor: Colors.orange,
                    buttonText: 'Sub Categories'),
              ),
              kWidth5,
              Expanded(
                flex: 3,
                child: CustomMaterialBtton(
                  onPressed: () {},
                  buttonColor: Colors.indigo,
                  buttonText: 'Brands',
                ),
              ),
              kWidth5,
              Expanded(
                flex: 2,
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.blue,
                  child: const Icon(
                    Icons.rotate_left,
                    color: kWhite,
                  ),
                ),
              )
            ],
          ),

          //==================== Product Listing Grid ====================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.count(
                childAspectRatio: (1 / .75),
                crossAxisCount: 5,
                children: List.generate(
                  30,
                  (index) => Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          AutoSizeText(
                            'Shavarma Grillided Chicken',
                            textAlign: TextAlign.center,
                            minFontSize: 8,
                            softWrap: true,
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          AutoSizeText(
                            'Qty: 10',
                            minFontSize: 8,
                            style: TextStyle(fontSize: 10),
                          ),
                          AutoSizeText(
                            '90.00',
                            minFontSize: 8,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
