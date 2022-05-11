import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shop_ez/api/invoice/pdf_action.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/core/utils/vat/vat.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

class PdfInvoice {
  static Future<List<File>> generate(SalesModel sale) async {
    final pdf = pw.Document();
    final pdfPreview = pw.Document();

    ByteData _bytes = await rootBundle.load('assets/images/invoice_logo.png');
    final logoBytes = _bytes.buffer.asUint8List();
    pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    // final emojiFont = await PdfGoogleFonts.notoColorEmoji();
    final arabicFont = await PdfGoogleFonts.iBMPlexSansArabicBold();

    final businessProfile = await UserUtils.instance.businessProfile;

    final customer =
        await CustomerDatabase.instance.getCustomerById(sale.customerId);

    final items =
        await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);

    pdfPreview.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      build: (context) {
        return [
          buildHeader2(
            businessProfileModel: businessProfile,
            arabicFont: arabicFont,
            logoImage: logoImage,
          ),
          pw.SizedBox(height: .01 * PdfPageFormat.a4.availableHeight),
          pw.SizedBox(height: .01 * PdfPageFormat.a4.availableHeight),
          buildTitle(arabicFont, businessProfile),
          pw.SizedBox(height: .01 * PdfPageFormat.a4.availableHeight),
          buildCustomerInfo(arabicFont, sale, customer),
          pw.SizedBox(height: .02 * PdfPageFormat.a4.availableHeight),
          buildInvoice(items),
          pw.Divider(),
          buildTotal(sale, arabicFont),
        ];
      },
    ));

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      header: (context) => buildHeader(
          businessProfileModel: businessProfile,
          arabicFont: arabicFont,
          logoImage: logoImage,
          businessProfile: businessProfile,
          sale: sale,
          customer: customer),
      build: (context) {
        return [
          buildInvoice(items),
          pw.Divider(),
          buildTotal(sale, arabicFont),
        ];
      },
    ));

    final pdfFile =
        await PdfAction.saveDocument(name: 'sale_invoice.pdf', pdf: pdf);
    final pdfPreviewFile = await PdfAction.saveDocument(
        name: 'sale_invoice_preview.pdf', pdf: pdfPreview);

    return [pdfFile, pdfPreviewFile];
  }

  //==================== Header Section ====================
  static pw.Widget buildHeader2({
    required BusinessProfileModel businessProfileModel,
    required pw.Font arabicFont,
    required pw.MemoryImage logoImage,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: buildEnglishCompanyInfo(businessProfileModel),
            ),
            pw.Expanded(
                child: pw.Container(
                    height: 50, width: 50, child: pw.Image(logoImage))),
            pw.Expanded(
              child: buildArabicCompanyInfo(businessProfileModel, arabicFont),
            )
          ],
        ),
      ],
    );
  }

//==================== Header Section ====================
  static pw.Widget buildHeader(
      {required BusinessProfileModel businessProfileModel,
      required pw.Font arabicFont,
      required pw.MemoryImage logoImage,
      required BusinessProfileModel businessProfile,
      required SalesModel sale,
      required CustomerModel customer}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: buildEnglishCompanyInfo(businessProfileModel),
            ),
            pw.Expanded(
                child: pw.Container(
                    height: 50, width: 50, child: pw.Image(logoImage))),
            pw.Expanded(
              child: buildArabicCompanyInfo(businessProfileModel, arabicFont),
            )
          ],
        ),
        pw.SizedBox(height: .01 * PdfPageFormat.a4.availableHeight),
        pw.SizedBox(height: .01 * PdfPageFormat.a4.availableHeight),
        buildTitle(arabicFont, businessProfile),
        pw.SizedBox(height: .01 * PdfPageFormat.a4.availableHeight),
        buildCustomerInfo(arabicFont, sale, customer),
        pw.SizedBox(height: .02 * PdfPageFormat.a4.availableHeight),
      ],
    );
  }

//==================== English Company Info ====================
  static pw.Widget buildEnglishCompanyInfo(BusinessProfileModel business) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(business.business,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: .01 * PdfPageFormat.a4.availableHeight),
          pw.Text(business.address),
          pw.Text('Tel: ${business.phoneNumber}'),
          pw.Text('Email: ${business.email}'),
        ],
      );

//==================== Arabic Company Info ====================
  static pw.Widget buildArabicCompanyInfo(
          BusinessProfileModel business, pw.Font arabicFont) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(business.businessArabic,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, font: arabicFont)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(
            business.addressArabic,
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(font: arabicFont),
          ),
          pw.Text(
            'هاتف: ${business.phoneNumber}',
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(font: arabicFont),
          ),
          pw.Text(
            'البريد: ${business.email}',
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(font: arabicFont),
          ),
        ],
      );

//==================== TAX INVOICE ====================
  static pw.Widget buildTitle(arabicFont, BusinessProfileModel business) {
    final kStyle = pw.TextStyle(
      font: arabicFont,
      fontWeight: pw.FontWeight.bold,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Stack(children: [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Container(
                color: PdfColors.green300,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    ' فاتورة ضريبية  TAX INVOICE ',
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      font: arabicFont,
                    ),
                  ),
                )),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Container(
              height: 50,
              width: 50,
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: 'lksdfl',
                drawText: false,
              ),
            ),
          ),
        ]),
        pw.SizedBox(height: 0.4 * PdfPageFormat.cm),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Expanded(
                child: pw.Text('VAT Registration Number',
                    textAlign: pw.TextAlign.center, style: kStyle)),
            pw.Expanded(
                child: pw.Text(business.vatNumber,
                    textAlign: pw.TextAlign.center, style: kStyle)),
            pw.Expanded(
                child: pw.Text(
              'الضريبي التسجيل رقم',
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.center,
              style: kStyle,
            )),
          ],
        ),
      ],
    );
  }

  //==================== Customer Info ====================
  static pw.Widget buildCustomerInfo(
      pw.Font arabicFont, SalesModel sale, CustomerModel customer) {
    final kStyle = pw.TextStyle(
      font: arabicFont,
      fontSize: 10,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration:
              pw.BoxDecoration(border: pw.Border.all(color: PdfColors.green)),
          width: double.infinity,
          height: .16 * PdfPageFormat.a4.availableHeight,
          child: pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                            child: pw.Text('Customer Name:',
                                textAlign: pw.TextAlign.left, style: kStyle)),
                        pw.Expanded(
                            child: pw.Text(customer.customer,
                                textAlign: pw.TextAlign.left, style: kStyle)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: .01 * PdfPageFormat.a4.availableWidth),
                  pw.Expanded(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                            child: pw.Text(
                          customer.customerArabic,
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.left,
                          style: kStyle,
                        )),
                        pw.Expanded(
                            child: pw.Text(
                          'العميل:',
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.left,
                          style: kStyle,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Customer Address:',
                            textAlign: pw.TextAlign.left, style: kStyle),
                        pw.SizedBox(
                            width: .01 * PdfPageFormat.a4.availableWidth),
                        pw.Expanded(
                            child: pw.Text(
                          customer.address ?? '',
                          textAlign: pw.TextAlign.left,
                          style: kStyle,
                          maxLines: 3,
                        )),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: .01 * PdfPageFormat.a4.availableWidth),
                  pw.Expanded(
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                            child: pw.Text(
                          customer.addressArabic ?? '',
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.left,
                          style: kStyle,
                          maxLines: 3,
                        )),
                        pw.SizedBox(
                            width: .01 * PdfPageFormat.a4.availableWidth),
                        pw.Text(
                          'عنوان العميل:',
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.right,
                          style: kStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Expanded(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                        child: pw.Text('Customer VAT Number',
                            textAlign: pw.TextAlign.left, style: kStyle)),
                    pw.Expanded(
                        child: pw.Text(customer.vatNumber ?? '',
                            textAlign: pw.TextAlign.center, style: kStyle)),
                    pw.Expanded(
                        child: pw.Text(
                      'الرقم الضريبي:',
                      textDirection: pw.TextDirection.rtl,
                      textAlign: pw.TextAlign.left,
                      style: kStyle,
                    )),
                  ],
                ),
              ),
              pw.Divider(color: PdfColors.grey),
              pw.Expanded(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(' :رقم الفاتورة Invoice/',
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.right,
                              style: kStyle),
                          pw.SizedBox(
                              width: .01 * PdfPageFormat.a4.availableWidth),
                          pw.Expanded(
                              child: pw.Text(
                            sale.invoiceNumber!,
                            textAlign: pw.TextAlign.right,
                            style: kStyle,
                          )),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: .10 * PdfPageFormat.a4.availableWidth),
                    pw.Expanded(
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(' :التاريخ Date/',
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.right,
                              style: kStyle),
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                Converter.dateTimeFormat
                                    .format(DateTime.parse(sale.dateTime)),
                                textAlign: pw.TextAlign.right,
                                style: kStyle,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

//==================== Invoice Table ====================
  static pw.Widget buildInvoice(List<SalesItemsModel> saleItems) {
    final headers = [
      'S.No',
      'Description',
      'Quantity',
      'Unit Price',
      'Sub Total',
      'VAT %',
      'VAT Amount',
      'Total Amount'
    ];
    int i = 0;
    final data = saleItems.map((item) {
      i++;
      final num exclusiveAmount;
      if (item.vatMethod == 'Inclusive') {
        exclusiveAmount = VatCalculator.getExclusiveAmount(
            sellingPrice: item.unitPrice, vatRate: item.vatRate);
      } else {
        exclusiveAmount = num.parse(item.unitPrice);
      }

      final totalAmount = num.parse(item.subTotal) + num.parse(item.vatTotal);

      return [
        '$i',
        item.productName,
        item.quantity,
        Converter.currency.format(exclusiveAmount).replaceAll('₹', ''),
        Converter.currency.format(num.parse(item.subTotal)).replaceAll('₹', ''),
        item.vatPercentage,
        Converter.currency.format(num.parse(item.vatTotal)).replaceAll('₹', ''),
        Converter.currency.format(totalAmount).replaceAll('₹', ''),
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellStyle: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.normal,
      ),
      headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: const {
        1: pw.FractionColumnWidth(0.20),
        2: pw.FractionColumnWidth(0.10),
        3: pw.FractionColumnWidth(0.15),
        4: pw.FractionColumnWidth(0.15),
        5: pw.FractionColumnWidth(0.10),
        6: pw.FractionColumnWidth(0.10),
        7: pw.FractionColumnWidth(0.15),
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
      },
    );
  }

//==================== Total Section ====================
  static pw.Widget buildTotal(SalesModel sale, pw.Font arabicFont) {
    return pw.Container(
        child: pw.Expanded(
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            flex: 5,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.max,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(height: 0.10 * PdfPageFormat.a4.availableWidth),
                buildFooter(arabicFont),
              ],
            ),
          ),
          pw.SizedBox(width: 0.05 * PdfPageFormat.a4.availableWidth),
          pw.Expanded(
            flex: 5,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildText(
                  title: ' / Total Amount  المبلغ اإلجمالي ',
                  value: Converter.currency
                      .format(num.parse(sale.subTotal))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Discount  مقدار الخصم',
                  value: Converter.currency
                      .format(num.parse(
                          sale.discount.isEmpty ? '0' : sale.discount))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Vat Amount  قيمة الضريبة',
                  value: Converter.currency
                      .format(num.parse(sale.vatAmount))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                pw.Divider(),
                buildText(
                  title: ' / Grant Total  المجموع الكل',
                  value: Converter.currency
                      .format(num.parse(sale.grantTotal))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Paid Amount  المبلغ المدفوع',
                  value: Converter.currency
                      .format(num.parse(sale.paid))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Balance  مقدار وسطي',
                  value: Converter.currency
                      .format(num.parse(sale.balance))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                pw.SizedBox(height: .5 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
                pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  static pw.Widget buildFooter(pw.Font arabicFont) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: buildSimpleText(
                    title: 'استلمت من قبل',
                    value: 'Received By',
                    arabicFont: arabicFont),
              ),
              pw.SizedBox(width: .05 * PdfPageFormat.a4.availableWidth),
              pw.Expanded(
                child: buildSimpleText(
                    title: 'تمت الموافقة عليه من قبل',
                    value: 'Approved By',
                    arabicFont: arabicFont),
              ),
              pw.SizedBox(width: .05 * PdfPageFormat.a4.availableWidth),
              pw.Expanded(
                child: buildSimpleText(
                    title: 'أعدت بواسطة',
                    value: 'Prepared By',
                    arabicFont: arabicFont),
              ),
            ],
          ),
          // pw.SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

//==================== TextField ====================
  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    required arabicFont,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ??
        pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          font: arabicFont,
        );

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(
              child: pw.Text(
            title,
            textDirection: pw.TextDirection.rtl,
            style: style,
          )),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
    required pw.Font arabicFont,
  }) {
    final style = pw.TextStyle(
        fontWeight: pw.FontWeight.bold, font: arabicFont, fontSize: 5);
    final eStyle = pw.TextStyle(
        fontWeight: pw.FontWeight.bold, font: arabicFont, fontSize: 8);

    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(title, style: style, textDirection: pw.TextDirection.rtl),
        pw.FittedBox(
          child: pw.Text(value, style: eStyle),
        )
      ],
    );
  }
}
