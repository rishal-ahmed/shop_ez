// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SalesReturnModal _$$_SalesReturnModalFromJson(Map<String, dynamic> json) =>
    _$_SalesReturnModal(
      id: json['_id'] as int?,
      saleId: json['saleId'] as int?,
      invoiceNumber: json['invoiceNumber'] as String?,
      originalInvoiceNumber: json['originalInvoiceNumber'] as String?,
      customerId: json['customerId'] as int,
      dateTime: json['dateTime'] as String,
      customerName: json['customerName'] as String,
      billerName: json['billerName'] as String,
      salesNote: json['salesNote'] as String,
      totalItems: json['totalItems'] as String,
      vatAmount: json['vatAmount'] as String,
      subTotal: json['subTotal'] as String,
      discount: json['discount'] as String,
      grantTotal: json['grantTotal'] as String,
      paid: json['paid'] as String,
      balance: json['balance'] as String,
      paymentType: json['paymentType'] as String,
      salesStatus: json['salesStatus'] as String,
      paymentStatus: json['paymentStatus'] as String,
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$$_SalesReturnModalToJson(_$_SalesReturnModal instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'saleId': instance.saleId,
      'invoiceNumber': instance.invoiceNumber,
      'originalInvoiceNumber': instance.originalInvoiceNumber,
      'customerId': instance.customerId,
      'dateTime': instance.dateTime,
      'customerName': instance.customerName,
      'billerName': instance.billerName,
      'salesNote': instance.salesNote,
      'totalItems': instance.totalItems,
      'vatAmount': instance.vatAmount,
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'grantTotal': instance.grantTotal,
      'paid': instance.paid,
      'balance': instance.balance,
      'paymentType': instance.paymentType,
      'salesStatus': instance.salesStatus,
      'paymentStatus': instance.paymentStatus,
      'createdBy': instance.createdBy,
    };