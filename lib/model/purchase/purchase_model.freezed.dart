// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'purchase_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PurchaseModel _$PurchaseModelFromJson(Map<String, dynamic> json) {
  return _PurchaseModel.fromJson(json);
}

/// @nodoc
mixin _$PurchaseModel {
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  String? get invoiceNumber => throw _privateConstructorUsedError;
  String get referenceNumber => throw _privateConstructorUsedError;
  String get dateTime => throw _privateConstructorUsedError;
  int get supplierId => throw _privateConstructorUsedError;
  String get supplierName => throw _privateConstructorUsedError;
  String get billerName => throw _privateConstructorUsedError;
  String get purchaseNote => throw _privateConstructorUsedError;
  String get totalItems => throw _privateConstructorUsedError;
  String get vatAmount => throw _privateConstructorUsedError;
  String get subTotal => throw _privateConstructorUsedError;
  String get discount => throw _privateConstructorUsedError;
  String get grantTotal => throw _privateConstructorUsedError;
  String get paid => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  String get purchaseStatus => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseModelCopyWith<PurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseModelCopyWith<$Res> {
  factory $PurchaseModelCopyWith(
          PurchaseModel value, $Res Function(PurchaseModel) then) =
      _$PurchaseModelCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: '_id') int? id,
      String? invoiceNumber,
      String referenceNumber,
      String dateTime,
      int supplierId,
      String supplierName,
      String billerName,
      String purchaseNote,
      String totalItems,
      String vatAmount,
      String subTotal,
      String discount,
      String grantTotal,
      String paid,
      String balance,
      String paymentType,
      String purchaseStatus,
      String paymentStatus,
      String createdBy});
}

/// @nodoc
class _$PurchaseModelCopyWithImpl<$Res>
    implements $PurchaseModelCopyWith<$Res> {
  _$PurchaseModelCopyWithImpl(this._value, this._then);

  final PurchaseModel _value;
  // ignore: unused_field
  final $Res Function(PurchaseModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? invoiceNumber = freezed,
    Object? referenceNumber = freezed,
    Object? dateTime = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? billerName = freezed,
    Object? purchaseNote = freezed,
    Object? totalItems = freezed,
    Object? vatAmount = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? grantTotal = freezed,
    Object? paid = freezed,
    Object? balance = freezed,
    Object? paymentType = freezed,
    Object? purchaseStatus = freezed,
    Object? paymentStatus = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: invoiceNumber == freezed
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: referenceNumber == freezed
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: dateTime == freezed
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
      supplierId: supplierId == freezed
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: supplierName == freezed
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      billerName: billerName == freezed
          ? _value.billerName
          : billerName // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseNote: purchaseNote == freezed
          ? _value.purchaseNote
          : purchaseNote // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: totalItems == freezed
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as String,
      vatAmount: vatAmount == freezed
          ? _value.vatAmount
          : vatAmount // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: subTotal == freezed
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as String,
      discount: discount == freezed
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String,
      grantTotal: grantTotal == freezed
          ? _value.grantTotal
          : grantTotal // ignore: cast_nullable_to_non_nullable
              as String,
      paid: paid == freezed
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as String,
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      paymentType: paymentType == freezed
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseStatus: purchaseStatus == freezed
          ? _value.purchaseStatus
          : purchaseStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: paymentStatus == freezed
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$PurchaseModelCopyWith<$Res>
    implements $PurchaseModelCopyWith<$Res> {
  factory _$PurchaseModelCopyWith(
          _PurchaseModel value, $Res Function(_PurchaseModel) then) =
      __$PurchaseModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: '_id') int? id,
      String? invoiceNumber,
      String referenceNumber,
      String dateTime,
      int supplierId,
      String supplierName,
      String billerName,
      String purchaseNote,
      String totalItems,
      String vatAmount,
      String subTotal,
      String discount,
      String grantTotal,
      String paid,
      String balance,
      String paymentType,
      String purchaseStatus,
      String paymentStatus,
      String createdBy});
}

/// @nodoc
class __$PurchaseModelCopyWithImpl<$Res>
    extends _$PurchaseModelCopyWithImpl<$Res>
    implements _$PurchaseModelCopyWith<$Res> {
  __$PurchaseModelCopyWithImpl(
      _PurchaseModel _value, $Res Function(_PurchaseModel) _then)
      : super(_value, (v) => _then(v as _PurchaseModel));

  @override
  _PurchaseModel get _value => super._value as _PurchaseModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? invoiceNumber = freezed,
    Object? referenceNumber = freezed,
    Object? dateTime = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? billerName = freezed,
    Object? purchaseNote = freezed,
    Object? totalItems = freezed,
    Object? vatAmount = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? grantTotal = freezed,
    Object? paid = freezed,
    Object? balance = freezed,
    Object? paymentType = freezed,
    Object? purchaseStatus = freezed,
    Object? paymentStatus = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_PurchaseModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: invoiceNumber == freezed
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: referenceNumber == freezed
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: dateTime == freezed
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
      supplierId: supplierId == freezed
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: supplierName == freezed
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      billerName: billerName == freezed
          ? _value.billerName
          : billerName // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseNote: purchaseNote == freezed
          ? _value.purchaseNote
          : purchaseNote // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: totalItems == freezed
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as String,
      vatAmount: vatAmount == freezed
          ? _value.vatAmount
          : vatAmount // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: subTotal == freezed
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as String,
      discount: discount == freezed
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String,
      grantTotal: grantTotal == freezed
          ? _value.grantTotal
          : grantTotal // ignore: cast_nullable_to_non_nullable
              as String,
      paid: paid == freezed
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as String,
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      paymentType: paymentType == freezed
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseStatus: purchaseStatus == freezed
          ? _value.purchaseStatus
          : purchaseStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: paymentStatus == freezed
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PurchaseModel implements _PurchaseModel {
  const _$_PurchaseModel(
      {@JsonKey(name: '_id') this.id,
      this.invoiceNumber,
      required this.referenceNumber,
      required this.dateTime,
      required this.supplierId,
      required this.supplierName,
      required this.billerName,
      required this.purchaseNote,
      required this.totalItems,
      required this.vatAmount,
      required this.subTotal,
      required this.discount,
      required this.grantTotal,
      required this.paid,
      required this.balance,
      required this.paymentType,
      required this.purchaseStatus,
      required this.paymentStatus,
      required this.createdBy});

  factory _$_PurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$$_PurchaseModelFromJson(json);

  @override
  @JsonKey(name: '_id')
  final int? id;
  @override
  final String? invoiceNumber;
  @override
  final String referenceNumber;
  @override
  final String dateTime;
  @override
  final int supplierId;
  @override
  final String supplierName;
  @override
  final String billerName;
  @override
  final String purchaseNote;
  @override
  final String totalItems;
  @override
  final String vatAmount;
  @override
  final String subTotal;
  @override
  final String discount;
  @override
  final String grantTotal;
  @override
  final String paid;
  @override
  final String balance;
  @override
  final String paymentType;
  @override
  final String purchaseStatus;
  @override
  final String paymentStatus;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'PurchaseModel(id: $id, invoiceNumber: $invoiceNumber, referenceNumber: $referenceNumber, dateTime: $dateTime, supplierId: $supplierId, supplierName: $supplierName, billerName: $billerName, purchaseNote: $purchaseNote, totalItems: $totalItems, vatAmount: $vatAmount, subTotal: $subTotal, discount: $discount, grantTotal: $grantTotal, paid: $paid, balance: $balance, paymentType: $paymentType, purchaseStatus: $purchaseStatus, paymentStatus: $paymentStatus, createdBy: $createdBy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.invoiceNumber, invoiceNumber) &&
            const DeepCollectionEquality()
                .equals(other.referenceNumber, referenceNumber) &&
            const DeepCollectionEquality().equals(other.dateTime, dateTime) &&
            const DeepCollectionEquality()
                .equals(other.supplierId, supplierId) &&
            const DeepCollectionEquality()
                .equals(other.supplierName, supplierName) &&
            const DeepCollectionEquality()
                .equals(other.billerName, billerName) &&
            const DeepCollectionEquality()
                .equals(other.purchaseNote, purchaseNote) &&
            const DeepCollectionEquality()
                .equals(other.totalItems, totalItems) &&
            const DeepCollectionEquality().equals(other.vatAmount, vatAmount) &&
            const DeepCollectionEquality().equals(other.subTotal, subTotal) &&
            const DeepCollectionEquality().equals(other.discount, discount) &&
            const DeepCollectionEquality()
                .equals(other.grantTotal, grantTotal) &&
            const DeepCollectionEquality().equals(other.paid, paid) &&
            const DeepCollectionEquality().equals(other.balance, balance) &&
            const DeepCollectionEquality()
                .equals(other.paymentType, paymentType) &&
            const DeepCollectionEquality()
                .equals(other.purchaseStatus, purchaseStatus) &&
            const DeepCollectionEquality()
                .equals(other.paymentStatus, paymentStatus) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(id),
        const DeepCollectionEquality().hash(invoiceNumber),
        const DeepCollectionEquality().hash(referenceNumber),
        const DeepCollectionEquality().hash(dateTime),
        const DeepCollectionEquality().hash(supplierId),
        const DeepCollectionEquality().hash(supplierName),
        const DeepCollectionEquality().hash(billerName),
        const DeepCollectionEquality().hash(purchaseNote),
        const DeepCollectionEquality().hash(totalItems),
        const DeepCollectionEquality().hash(vatAmount),
        const DeepCollectionEquality().hash(subTotal),
        const DeepCollectionEquality().hash(discount),
        const DeepCollectionEquality().hash(grantTotal),
        const DeepCollectionEquality().hash(paid),
        const DeepCollectionEquality().hash(balance),
        const DeepCollectionEquality().hash(paymentType),
        const DeepCollectionEquality().hash(purchaseStatus),
        const DeepCollectionEquality().hash(paymentStatus),
        const DeepCollectionEquality().hash(createdBy)
      ]);

  @JsonKey(ignore: true)
  @override
  _$PurchaseModelCopyWith<_PurchaseModel> get copyWith =>
      __$PurchaseModelCopyWithImpl<_PurchaseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PurchaseModelToJson(this);
  }
}

abstract class _PurchaseModel implements PurchaseModel {
  const factory _PurchaseModel(
      {@JsonKey(name: '_id') final int? id,
      final String? invoiceNumber,
      required final String referenceNumber,
      required final String dateTime,
      required final int supplierId,
      required final String supplierName,
      required final String billerName,
      required final String purchaseNote,
      required final String totalItems,
      required final String vatAmount,
      required final String subTotal,
      required final String discount,
      required final String grantTotal,
      required final String paid,
      required final String balance,
      required final String paymentType,
      required final String purchaseStatus,
      required final String paymentStatus,
      required final String createdBy}) = _$_PurchaseModel;

  factory _PurchaseModel.fromJson(Map<String, dynamic> json) =
      _$_PurchaseModel.fromJson;

  @override
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  @override
  String? get invoiceNumber => throw _privateConstructorUsedError;
  @override
  String get referenceNumber => throw _privateConstructorUsedError;
  @override
  String get dateTime => throw _privateConstructorUsedError;
  @override
  int get supplierId => throw _privateConstructorUsedError;
  @override
  String get supplierName => throw _privateConstructorUsedError;
  @override
  String get billerName => throw _privateConstructorUsedError;
  @override
  String get purchaseNote => throw _privateConstructorUsedError;
  @override
  String get totalItems => throw _privateConstructorUsedError;
  @override
  String get vatAmount => throw _privateConstructorUsedError;
  @override
  String get subTotal => throw _privateConstructorUsedError;
  @override
  String get discount => throw _privateConstructorUsedError;
  @override
  String get grantTotal => throw _privateConstructorUsedError;
  @override
  String get paid => throw _privateConstructorUsedError;
  @override
  String get balance => throw _privateConstructorUsedError;
  @override
  String get paymentType => throw _privateConstructorUsedError;
  @override
  String get purchaseStatus => throw _privateConstructorUsedError;
  @override
  String get paymentStatus => throw _privateConstructorUsedError;
  @override
  String get createdBy => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PurchaseModelCopyWith<_PurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
