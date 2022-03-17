import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/supplier_database/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);
  static const items = ['Cash Customer', 'Credit Customer'];
  static late Size _screenSize;
  static final supplierDB = SupplierDatabase.instance;

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyController = TextEditingController();
  final _companyArabicController = TextEditingController();
  final _customerController = TextEditingController();
  final _customerArabicController = TextEditingController();
  final _vatNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressArabicController = TextEditingController();
  final _cityController = TextEditingController();
  final _cityArabicController = TextEditingController();
  final _stateController = TextEditingController();
  final _stateArabicController = TextEditingController();
  final _countryController = TextEditingController();
  final _countryArabicController = TextEditingController();
  final _poBoxController = TextEditingController();
  String _customerTypeController = 'null';

  getSupplier() async {
    await CustomerScreen.supplierDB.getAllSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    // getSupplier();
    CustomerScreen._screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Customer',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //========== Company Field ==========
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Customer Type *',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    isExpanded: true,
                    items: CustomerScreen.items
                        .map(
                          (values) => DropdownMenuItem(
                              value: values, child: Text(values)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _customerTypeController = value.toString();
                      });
                    },
                    validator: (value) {
                      if (value == null || _customerTypeController == 'null') {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),

                  //========== Company Field ==========
                  TextFeildWidget(
                    controller: _companyController,
                    labelText: 'Company *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Company Arabic Field ==========
                  TextFeildWidget(
                    controller: _companyArabicController,
                    labelText: 'Company Arabic *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Customer Field ==========
                  TextFeildWidget(
                    controller: _customerController,
                    labelText: 'Customer Name *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Customer Arabic Field ==========
                  TextFeildWidget(
                    controller: _customerArabicController,
                    labelText: 'Customer Name Arabic *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== VAT Number Field ==========
                  TextFeildWidget(
                    controller: _vatNumberController,
                    labelText: 'VAT Number',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Email Field ==========
                  TextFeildWidget(
                    controller: _emailController,
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  kHeight10,

                  //========== Address Field ==========
                  TextFeildWidget(
                    controller: _addressController,
                    labelText: 'Address',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Address Arabic Field ==========
                  TextFeildWidget(
                    controller: _addressArabicController,
                    labelText: 'Address in Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== City Field ==========
                  TextFeildWidget(
                    controller: _cityController,
                    labelText: 'City',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== City Arabic Field ==========
                  TextFeildWidget(
                    controller: _cityArabicController,
                    labelText: 'City in Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== State Field ==========
                  TextFeildWidget(
                    controller: _stateController,
                    labelText: 'State',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== State Arabic Field ==========
                  TextFeildWidget(
                    controller: _stateArabicController,
                    labelText: 'State in Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Country Field ==========
                  TextFeildWidget(
                    controller: _countryController,
                    labelText: 'Country',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Country Arabic Field ==========
                  TextFeildWidget(
                    controller: _countryArabicController,
                    labelText: 'Country in Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== PO Box Field ==========
                  TextFeildWidget(
                    controller: _poBoxController,
                    labelText: 'PO Box',
                    textInputType: TextInputType.text,
                  ),
                  kHeight20,

                  //========== Submit Button ==========
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomerScreen._screenSize.width / 10),
                    child: CustomMaterialBtton(
                        buttonText: 'Submit',
                        onPressed: () {
                          // addCustomer(context: context);
                        }),
                  ),
                  kHeight10
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //========== Add Supplier ==========
  Future<void> addCustomer({context}) async {
    final String company,
        companyArabic,
        customer,
        customerArabic,
        vatNumber,
        email,
        address,
        addressArabic,
        city,
        cityArabic,
        state,
        stateArabic,
        country,
        countryArabic,
        poBox;

    final _formState = _formKey.currentState!;
    if (_formState.validate()) {
      //retieving values from TextFields to String
      company = _companyController.text;
      companyArabic = _companyArabicController.text;
      customer = _customerController.text;
      customerArabic = _customerArabicController.text;
      vatNumber = _vatNumberController.text;
      email = _emailController.text;
      address = _addressController.text;
      addressArabic = _addressArabicController.text;
      city = _cityController.text;
      cityArabic = _cityArabicController.text;
      state = _stateArabicController.text;
      stateArabic = _stateArabicController.text;
      country = _countryController.text;
      countryArabic = _countryArabicController.text;
      poBox = _poBoxController.text;

      final _supplierModel = SupplierModel(
        company: company,
        companyArabic: companyArabic,
        supplier: customer,
        supplierArabic: customerArabic,
        vatNumber: vatNumber,
        email: email,
        address: address,
        addressArabic: addressArabic,
        city: city,
        cityArabic: cityArabic,
        state: state,
        stateArabic: stateArabic,
        country: country,
        countryArabic: countryArabic,
        poBox: poBox,
      );
      try {
        await CustomerScreen.supplierDB.createSupplier(_supplierModel);
        log('Supplier $customer Added!');
        showSnackBar(
            context: context,
            color: kSnackBarSuccessColor,
            icon: const Icon(
              Icons.done,
              color: kSnackBarIconColor,
            ),
            content: 'Customer "$customer" added successfully!');
      } catch (e) {
        log('Commpany $company Already Exist!');
        showSnackBar(
            context: context,
            color: kSnackBarErrorColor,
            icon: const Icon(
              Icons.new_releases_outlined,
              color: kSnackBarIconColor,
            ),
            content: 'Customer "$customer" already exist!');
      }
    }
  }

  //========== Show SnackBar ==========
  void showSnackBar(
      {required BuildContext context,
      required String content,
      Color? color,
      Widget? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon ?? const Text(''),
            kWidth5,
            Text(content),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
