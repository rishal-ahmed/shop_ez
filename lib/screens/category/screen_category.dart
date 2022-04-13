import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _categoryEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final categoryDB = CategoryDatabase.instance;

  @override
  Widget build(BuildContext context) {
    categoryDB.getAllCategories();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Category',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Category Field ==========
              Form(
                key: _formKey,
                child: TextFeildWidget(
                  labelText: 'Category *',
                  controller: _categoryEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),
              ),
              kHeight20,

              //========== Submit Button ==========
              CustomMaterialBtton(
                buttonText: 'Submit',
                onPressed: () async {
                  final category = _categoryEditingController.text.trim();
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Category == ' + category);
                    final _category = CategoryModel(category: category);

                    try {
                      await categoryDB.createCategory(_category);
                      kSnackBar(
                          context: context,
                          color: kSnackBarSuccessColor,
                          icon: const Icon(
                            Icons.done,
                            color: kSnackBarIconColor,
                          ),
                          content: 'Category "$category" added successfully!');
                      _categoryEditingController.clear();
                      return setState(() {});
                    } catch (e) {
                      kSnackBar(
                          context: context,
                          color: kSnackBarErrorColor,
                          icon: const Icon(
                            Icons.new_releases_outlined,
                            color: kSnackBarIconColor,
                          ),
                          content: 'Category "$category" already exist!');
                      // _categoryEditingController.clear();
                    }
                  }
                },
              ),

              //========== Category List Field ==========
              kHeight50,
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: categoryDB.getAllCategories(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            itemBuilder: (context, index) {
                              final item = snapshot.data[index];
                              log('item == $item');
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: kTransparentColor,
                                  child: Text(
                                    '${index + 1}'.toString(),
                                    style:
                                        const TextStyle(color: kTextColorBlack),
                                  ),
                                ),
                                title: Text(item.category),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: snapshot.data.length,
                          )
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
