import 'dart:io' as io;
import 'dart:io';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class BillPdfSyncfusionApi {
  Order orderModel;
  User customerModel;

  BillPdfSyncfusionApi({
    required this.orderModel,
    required this.customerModel,
  });

  //Generates the bill, writes it, saves it and then returns it. Means full creatation
  //of PDF.
  //isOriginal argument determines whether the bill is just for veiwing or is
  //original. Original bill contains payment details.
  Future<io.File?> generateBillPdf({bool isOriginal = false}) async {
    print("Generating and saving Bill...");
    try {
      String templateName = isOriginal
          ? 'receipt_template_pdf.pdf'
          : 'invoice_preview_template_pdf.pdf';

      final PdfDocument billPdfTemplate =
          await loadBillPdfTemplate(templateName: templateName);

      //Get the existing PDF page for detailed billing
      final PdfPage page = billPdfTemplate.pages[0];

      _createDetailedBillWithTemplate(page, isOriginal: isOriginal);

      String orignality = isOriginal ? 'original' : 'preview';
      io.File? file = await saveAndPrintSyncfusionDocument(
          fileName:
              '${orderModel.id.substring(orderModel.id.length - 5)}_$orignality.pdf',
          pdf: billPdfTemplate);
      return file;
    } catch (e) {
      debugPrint('Error Generating bill: $e');
      return null;
    }
  }

  //Writes the things in the bill having all the details.
  void _createDetailedBillWithTemplate(PdfPage page,
      {bool isOriginal = false}) {
    try {
      //Bill no
      _writeStringInPDF(
        page: page,
        content: orderModel.id.substring(orderModel.id.length - 5),
        style: 'Bill',
        left: 506,
        top: 196,
      );

      //Bill date
      _writeStringInPDF(
          page: page,
          content:
              '${orderModel.orderedAtDateTime?.day}/${orderModel.orderedAtDateTime?.month}/${orderModel.orderedAtDateTime?.year}', //Remove the longer name through code, define the max length
          style: 'Bill',
          left: 490,
          top: 218);

      //Customer Name
      _writeStringInPDF(
          page: page,
          content: customerModel.name,
          style: 'Customer',
          left: 285,
          top: 196);

      //Customer Contact no.
      _writeStringInPDF(
          page: page,
          content: customerModel.phoneNumber != null &&
                  customerModel.phoneNumber!.isNotEmpty
              ? customerModel.phoneNumber!
              : customerModel.email!,
          style: 'Customer',
          left: 270,
          top: 220);

      //Customer devliery address as provided in order
      _writeStringInPDF(
        page: page,
        content: orderModel.address,
        style: 'Customer',
        left: 273,
        top: 245,
      );

      int itemSubtotal = 0;
      int subtotalAfterDiscount = 0;
      double billItemRowGap = 37;
      //Adds items of the bill one by one.
      for (int i = 0; i < orderModel.products.length; i++) {
        int discountPcnt = ((orderModel.products[i]['markedPrice'] as int) -
                (orderModel.products[i]['price'] as int)) ~/
            (orderModel.products[i]['markedPrice'] as int);
        itemSubtotal += (orderModel.products[i]['markedPrice'] as int) *
            (orderModel.products[i]['quantity'] as int);
        subtotalAfterDiscount += (orderModel.products[i]['price'] as int) *
            (orderModel.products[i]['quantity'] as int);
        //Item name + (discount pcnt off)
        if (discountPcnt > 0) {
          _writeStringInPDF(
              page: page,
              content:
                  '${orderModel.products[i]['product']['name']} ($discountPcnt% off)',
              style: 'Bill Item',
              left: 70,
              top: 324.0 + (i * billItemRowGap));
        } else {
          _writeStringInPDF(
              page: page,
              content: orderModel.products[i]['product']['name'],
              style: 'Bill Item',
              left: 70,
              top: 324.0 + (i * billItemRowGap));
        }

        _drawCircleInPDF(
          page: page,
          color: PdfSolidBrush(
            PdfColor(
                Color(int.parse(orderModel.products[i]['color'])).red,
                Color(int.parse(orderModel.products[i]['color'])).green,
                Color(int.parse(orderModel.products[i]['color'])).blue,
                Color(int.parse(orderModel.products[i]['color'])).alpha),
          ),
          top: 324.0 + (i * billItemRowGap),
          left: 50,
          width: 13,
          height: 13,
        );

        //Quantity
        _writeStringInPDF(
          page: page,
          content: '${orderModel.products[i]['quantity']}',
          style: 'Bill Item',
          right: 300,
          top: 324.0 + (i * billItemRowGap),
          isAlignRight: true,
        );

        //Cost price of items without discount.
        _writeStringInPDF(
          page: page,
          content:
              '${UsefulFunctions.putCommasInNumbers(orderModel.products[i]['markedPrice'])}/-',
          style: 'Bill Item',
          right: 400,
          top: 324.0 + (i * billItemRowGap),
          isAlignRight: true,
        );

        //Subtotal of a item
        _writeStringInPDF(
          page: page,
          content:
              '${UsefulFunctions.putCommasInNumbers((orderModel.products[i]['markedPrice'] as int) * (orderModel.products[i]['quantity'] as int))}/-',
          style: 'Bill Item',
          right: 530,
          top: 324.0 + (i * billItemRowGap),
          isAlignRight: true,
        );
      }

      //Total Quantity
      _writeStringInPDF(
        page: page,
        content: '${orderModel.orderedQuantity}',
        style: 'Charges',
        color: PdfBrushes.darkBlue,
        right: 300,
        top: 552,
        isAlignRight: true,
      );

      //Subtotal
      _writeStringInPDF(
        page: page,
        content: '${UsefulFunctions.putCommasInNumbers(itemSubtotal)}/-',
        style: 'Charges',
        color: PdfBrushes.darkBlue,
        right: 530,
        top: 552,
        isAlignRight: true,
      );

      //This is a list having charge in order: Alteration, less, other charge 1,
      //other charge 2 & roundoff. Only three of these charges will be shown in
      //bill, with priority as above. If there are 4 charges other than round off
      //then other charges 1 and other charges 2 are added and shown in bill.
      Map<String, int> allChargesAndLess = {};
      int noOfCharges = 0;
      if (itemSubtotal != subtotalAfterDiscount) {
        allChargesAndLess['Discount'] = subtotalAfterDiscount - itemSubtotal;
        noOfCharges++;
      }
      if (subtotalAfterDiscount != orderModel.totalPrice) {
        allChargesAndLess['Delivery Charges'] =
            orderModel.totalPrice - subtotalAfterDiscount;
        noOfCharges++;
      }

      //If there are no charges applied on bill then default Alteration, other and
      //Round off are added.

      double headingPosition = 360;
      if (noOfCharges == 0) {
        //Alteration Heading
        _writeStringInPDF(
          page: page,
          content: 'Delivery Charge',
          style: 'Charges Heading',
          left: headingPosition,
          top: 589,
        );
        //Alteration amount
        _writeStringInPDF(
          page: page,
          content: '0/-',
          style: 'Charges',
          color: PdfBrushes.darkBlue,
          right: 530,
          top: 589,
          isAlignRight: true,
        );

        //Other charges Heading
        _writeStringInPDF(
          page: page,
          content: 'Other Charges',
          style: 'Charges Heading',
          left: headingPosition,
          top: 624,
        );
        //Other charges
        _writeStringInPDF(
          page: page,
          content: '0/-',
          style: 'Charges',
          color: PdfBrushes.darkBlue,
          right: 530,
          top: 624,
          isAlignRight: true,
        );
      }

      if (noOfCharges == 1) {
        //Alteration amount
        allChargesAndLess.forEach((key, value) {
          //Alteration Heading
          _writeStringInPDF(
            page: page,
            content: key,
            style: 'Charges Heading',
            left: headingPosition,
            top: 589,
          );
          _writeStringInPDF(
            page: page,
            content: '${UsefulFunctions.putCommasInNumbers(value)}/-',
            style: 'Charges',
            color: PdfBrushes.darkBlue,
            right: 530,
            top: 589,
            isAlignRight: true,
          );
        });

        //Alteration Heading
        _writeStringInPDF(
          page: page,
          content: 'Other Charges',
          style: 'Charges Heading',
          left: headingPosition,
          top: 624,
        );
        //Other charges
        _writeStringInPDF(
          page: page,
          content: '0/-',
          style: 'Charges',
          color: PdfBrushes.darkBlue,
          right: 530,
          top: 624,
          isAlignRight: true,
        );
      }

      if (noOfCharges == 2) {
        int i = 0;
        //Alteration amount
        allChargesAndLess.forEach((key, value) {
          _writeStringInPDF(
            page: page,
            content: key,
            style: 'Charges Heading',
            left: headingPosition,
            top: 589 + (i * 35),
          );
          _writeStringInPDF(
            page: page,
            content: '${UsefulFunctions.putCommasInNumbers(value)}/-',
            style: 'Charges',
            color: PdfBrushes.darkBlue,
            right: 530,
            top: 589 + (i * 35),
            isAlignRight: true,
          );
          i++;
        });

        //Alteration Heading
        _writeStringInPDF(
          page: page,
          content: 'Other Charges',
          style: 'Charges Heading',
          left: headingPosition,
          top: 659,
        );
        //Round off
        _writeStringInPDF(
          page: page,
          content: '0/-',
          style: 'Charges',
          color: PdfBrushes.darkBlue,
          right: 530,
          top: 659,
          isAlignRight: true,
        );
      }

      //Total amount
      _writeStringInPDF(
        page: page,
        content:
            '${UsefulFunctions.putCommasInNumbers(orderModel.totalPrice)}/-',
        style: 'Amount',
        color: PdfBrushes.white,
        right: 530,
        top: 699,
        isAlignRight: true,
      );

      //If bill is final and original then only payment details are updated.
      if (isOriginal) {}
    } catch (e) {
      debugPrint('Error creating bill with details: $e');
    }
  }

  //Defines the style of text to be written in Bill
  //Styles: Basic, Customer, Bill Item, Amount, Payment, Title
  void _writeStringInPDF({
    required PdfPage page,
    required String content,
    String style = 'Basic',
    PdfBrush? color,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    bool isAlignRight = false,
  }) {
    color ?? PdfSolidBrush(PdfColor(0, 0, 0));
    Rect bounds = Rect.fromLTRB(left, top, right, bottom);
    PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    //Used in customer names
    if (style == 'Customer') {
      font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    }
    //Used in bill date and no
    else if (style == 'Bill') {
      font = PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold);
    }
    //Used in items in bill
    else if (style == 'Bill Item') {
      font = PdfStandardFont(PdfFontFamily.helvetica, 16);
    }
    //Used in charges heading
    else if (style == 'Charges Heading') {
      font = PdfStandardFont(PdfFontFamily.timesRoman, 13,
          style: PdfFontStyle.bold);
    }
    //Used for subtotal and different charges and quantity
    else if (style == 'Charges') {
      font = PdfStandardFont(PdfFontFamily.helvetica, 16,
          style: PdfFontStyle.bold);
    }
    //Used for total amount
    else if (style == 'Amount') {
      font = PdfStandardFont(PdfFontFamily.helvetica, 20,
          style: PdfFontStyle.bold);
    } else if (style == 'Payment') {
      font = PdfStandardFont(PdfFontFamily.helvetica, 16);
    }

    page.graphics.drawString(
      content, //Remove the longer name through code, define the max length
      font,
      brush: color,
      bounds: bounds,
      format: PdfStringFormat(
        alignment:
            isAlignRight ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );
  }

  //Defines the style of text to be written in Bill
  //Styles: Basic, Customer, Bill Item, Amount, Payment, Title
  void _drawCircleInPDF({
    required PdfPage page,
    required PdfBrush color,
    double left = 0,
    double top = 0,
    double width = 0,
    double height = 0,
  }) {
    Rect bounds = Rect.fromLTWH(left, top, width, height);

    page.graphics.drawEllipse(
      bounds,
      brush: color,
    );
  }

  //Loads blank bill template, blank means wihout text just format.
  static Future<PdfDocument> loadBillPdfTemplate(
      {String templateName = 'receipt_template_pdf.pdf'}) async {
    print("Loading Bill template...");
    ByteData data = await rootBundle.load('assets/$templateName');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final PdfDocument billPdfTemplate = PdfDocument(inputBytes: bytes);
    return billPdfTemplate;
  }

  //Saves a syncfusion PDF in internal storage in mobile and in downloads in web.
  //Also, it prints if using web and opens the pdf if opened in mobile.
  static Future<io.File?> saveAndPrintSyncfusionDocument(
      {required String fileName, required PdfDocument pdf}) async {
    try {
      final bytes = await pdf.save();

      final dir = await getExternalStorageDirectory();
      final file = io.File('${dir?.path}/$fileName');

      await file.writeAsBytes(bytes);
      print("Bill saved at: ${dir?.path}/$fileName");

      //Opens the file in mobile
      BillPdfSyncfusionApi.openFile(file);
      return file;
    } catch (e) {
      print("Error saving and opening file: $e");
      return null;
    }
  }

  static Future openFile(File? file) async {
    if (file == null) {
      debugPrint('File provided for opening is null');
      return;
    }
    try {
      final url = file.path;
      print("Opening file at path: $url");
      await OpenFile.open(url);
    } catch (e) {
      print("Error opening file: $e");
    }
  }
}
