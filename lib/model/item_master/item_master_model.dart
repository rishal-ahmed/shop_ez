const String tableItemMaster = 'item_master';

class ItemMasterFields {
  static const id = '_id';
  static const productType = 'productType';
  static const itemName = 'itemName';
  static const itemNameArabic = 'itemNameArabic';
  static const itemCode = 'itemCode';
  static const itemCategory = 'itemCategory';
  static const itemSubCategory = 'itemSubCategory';
  static const itemBrand = 'itemBrand';
  static const itemCost = 'itemCost';
  static const sellingPrice = 'sellingPrice';
  static const secondarySellingPrice = 'secondarySellingPrice';
  static const productVAT = 'productVAT';
  static const unit = 'unit';
  static const openingStock = 'openingStock';
  static const vatMethod = 'vatMethod';
  static const alertQuantity = 'alertQuantity';
  static const itemImage = 'itemImage';
}

class ItemMasterModel {
  final int? id;
  final String productType,
      itemName,
      itemNameArabic,
      itemCode,
      itemCategory,
      itemCost,
      sellingPrice,
      productVAT,
      unit,
      vatMethod;
  final String? itemSubCategory,
      itemBrand,
      secondarySellingPrice,
      openingStock,
      alertQuantity,
      itemImage;

  ItemMasterModel({
    this.id,
    required this.productType,
    required this.itemName,
    required this.itemNameArabic,
    required this.itemCode,
    required this.itemCategory,
    required this.itemCost,
    required this.sellingPrice,
    required this.productVAT,
    required this.unit,
    required this.vatMethod,
    this.itemSubCategory,
    this.itemBrand,
    this.secondarySellingPrice,
    this.openingStock,
    this.alertQuantity,
    this.itemImage,
  });

  Map<String, Object?> toJson() => {
        ItemMasterFields.id: id,
        ItemMasterFields.productType: productType,
        ItemMasterFields.itemName: itemName,
        ItemMasterFields.itemNameArabic: itemNameArabic,
        ItemMasterFields.itemCode: itemCode,
        ItemMasterFields.itemCategory: itemCategory,
        ItemMasterFields.itemSubCategory: itemSubCategory,
        ItemMasterFields.itemBrand: itemBrand,
        ItemMasterFields.itemCost: itemCost,
        ItemMasterFields.sellingPrice: sellingPrice,
        ItemMasterFields.secondarySellingPrice: secondarySellingPrice,
        ItemMasterFields.productVAT: productVAT,
        ItemMasterFields.unit: unit,
        ItemMasterFields.openingStock: openingStock,
        ItemMasterFields.itemImage: itemImage,
        ItemMasterFields.vatMethod: vatMethod,
        ItemMasterFields.alertQuantity: alertQuantity,
      };

  static ItemMasterModel fromJson(Map<String, Object?> json) => ItemMasterModel(
        id: json[ItemMasterFields.id] as int,
        productType: json[ItemMasterFields.productType] as String,
        itemName: json[ItemMasterFields.itemName] as String,
        itemNameArabic: json[ItemMasterFields.itemNameArabic] as String,
        itemCode: json[ItemMasterFields.itemCode] as String,
        itemCategory: json[ItemMasterFields.itemCategory] as String,
        itemSubCategory: json[ItemMasterFields.itemSubCategory] as String,
        itemBrand: json[ItemMasterFields.itemBrand] as String,
        itemCost: json[ItemMasterFields.itemCost] as String,
        sellingPrice: json[ItemMasterFields.sellingPrice] as String,
        secondarySellingPrice:
            json[ItemMasterFields.secondarySellingPrice] as String,
        productVAT: json[ItemMasterFields.itemBrand] as String,
        unit: json[ItemMasterFields.itemBrand] as String,
        openingStock: json[ItemMasterFields.openingStock] as String,
        itemImage: json[ItemMasterFields.itemImage] as String,
        vatMethod: json[ItemMasterFields.vatMethod] as String,
        alertQuantity: json[ItemMasterFields.alertQuantity] as String,
      );
}