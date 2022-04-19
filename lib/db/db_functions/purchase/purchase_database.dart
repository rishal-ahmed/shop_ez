import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';

class PurchaseDatabase {
  static final PurchaseDatabase instance = PurchaseDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  PurchaseDatabase._init();

//==================== Create Purchase ====================
  Future<int> createPurchase(PurchaseModel _purchaseModel) async {
    final db = await dbInstance.database;

    final _purchase = await db.rawQuery(
        "select * from $tablePurchase where ${PurchaseFields.invoiceNumber} = '${_purchaseModel.invoiceNumber}'");

    if (_purchase.isNotEmpty) {
      throw 'Invoice Number Already Exist!';
    } else {
      final _purchases = await db.query(tablePurchase);

      if (_purchases.isNotEmpty) {
        final _recentPurchase = PurchaseModel.fromJson(_purchases.last);

        final int? _recentPurchaseId = _recentPurchase.id;
        log('Recent id == $_recentPurchaseId');

        final String _invoiceNumber = 'PR-${_recentPurchaseId! + 1}';
        final _newPurchase =
            _purchaseModel.copyWith(invoiceNumber: _invoiceNumber);
        log('New Invoice Number == $_invoiceNumber');

        final id = await db.insert(tablePurchase, _newPurchase.toJson());
        log('Purchase Created! ($id)');
        return id;
      } else {
        final _newPurchase = _purchaseModel.copyWith(invoiceNumber: 'PR-1');

        log('New Invoice Number == ' + _newPurchase.invoiceNumber!);
        final id = await db.insert(tablePurchase, _newPurchase.toJson());
        log('Purchase Created! ($id)');
        return id;
      }
    }
  }

//========== Get All Purchases ==========
  Future<List<PurchaseModel>> getAllPurchases() async {
    final db = await dbInstance.database;
    final _result = await db.query(tablePurchase);
    // db.delete(tablePurchase);
    log('Purchases == $_result');
    if (_result.isNotEmpty) {
      final _purchases =
          _result.map((json) => PurchaseModel.fromJson(json)).toList();
      return _purchases;
    } else {
      throw 'Purchases is Empty!';
    }
  }
}