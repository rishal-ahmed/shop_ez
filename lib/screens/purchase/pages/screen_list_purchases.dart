import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

import '../widgets/purchase_card_widget.dart';

class PurchasesList extends StatelessWidget {
  const PurchasesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Purchases',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: FutureBuilder(
              future: PurchaseDatabase.instance.getAllPurchases(),
              builder: (context, AsyncSnapshot<List<PurchaseModel>> snapshot) {
                final List<PurchaseModel> _purchases;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());

                  case ConnectionState.done:

                  default:
                    _purchases = snapshot.data!;

                    return ListView.separated(
                      itemCount: _purchases.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          kHeight5,
                      itemBuilder: (BuildContext context, int index) {
                        return PurchaseCardWidget(
                            index: index, purchases: _purchases);
                      },
                    );
                }
              }),
        ),
      ),
    );
  }
}
