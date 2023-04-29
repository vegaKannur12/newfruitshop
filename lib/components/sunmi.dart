import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class Sunmi {
  // initialize sunmi printer
  Future<void> initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  }

  // print image
  Future<void> printLogoImage() async {
    await SunmiPrinter.lineWrap(1); // creates one line space
    Uint8List byte = await _getImageFromAsset('asset/1.png');
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.lineWrap(1); // creates one line space
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  // print text passed as parameter
  Future<void> printText(String text) async {
    await SunmiPrinter.lineWrap(1); // creates one line space
    await SunmiPrinter.printText(text,
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.lineWrap(1); // creates one line space
  }

//////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> printHeader(Map<String, dynamic> printSalesData) async {
    String? billType;
    if (printSalesData["master"]["payment_mode"] == "-2") {
      billType = "CASH BILL";
    } else if (printSalesData["master"]["payment_mode"] == "-3") {
      billType = "CREDIT BILL";
    }
    await SunmiPrinter.lineWrap(1); // creates one line space
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.printText(printSalesData["company"][0]["cnme"],
        style: SunmiStyle(
          fontSize: SunmiFontSize.LG,
          bold: true,
          // align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText(billType.toString(),
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
          // align: SunmiPrintAlign.CENTER,
        ));

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Bill No :",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${printSalesData["master"]["sale_Num"]}",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Date :",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${printSalesData["master"]["Date"]}",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Staff : ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${printSalesData["staff"][0]["sname"]}",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Party : ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${printSalesData["master"]["cus_name"]}",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: " ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${printSalesData["master"]["address"]}",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "GSTIN : ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${printSalesData["master"]["gstin"]}",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    // await SunmiPrinter.printRow(cols: [
    //   ColumnMaker(
    //     text: "O/S",
    //     width: 10,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: "${printSalesData["master"]["ba"].toStringAsFixed(2)}",
    //     width: 20,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    // ]);

    // await SunmiPrinter.lineWrap(1); // creates one line space
  }

  // print text as qrcode
  Future<void> printQRCode(String text) async {
    // set alignment center
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.lineWrap(1); // creates one line space
    await SunmiPrinter.printQRCode(text);
    await SunmiPrinter.lineWrap(4); // creates one line space
  }

  // print row and 2 columns
  Future<void> printRowAndColumns(Map<String, dynamic> printSalesData) async {
    await SunmiPrinter.lineWrap(1); // creates one line space

    // set alignment center
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.setCustomFontSize(20);
    await SunmiPrinter.bold();

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Item",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Qty",
        width: 7,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: "Rate",
        width: 7,
        align: SunmiPrintAlign.RIGHT,
      ),
      ColumnMaker(
        text: "Amount",
        width: 7,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.line();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.setCustomFontSize(20);
    await SunmiPrinter.bold();

    for (int i = 0; i < printSalesData["detail"].length; i++) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          // text:"jhdjsdjhdjsdjdhhhhhhhhhhhhhhhhh",
          text: printSalesData["detail"][i]["item"],
          width: 14,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: printSalesData["detail"][i]["qty"].toStringAsFixed(2),
          width: 7,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          //  text: "345622.00",
          text: printSalesData["detail"][i]["rate"].toStringAsFixed(2),
          width: 7,
          align: SunmiPrintAlign.RIGHT,
        ),
        ColumnMaker(
          // text:"123422.00",
          text: printSalesData["detail"][i]["gross"].toStringAsFixed(2),
          width: 7,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      // await SunmiPrinter.lineWrap(1);
    }

    // prints a row with 3 columns
    // total width of columns should be 30
    // await SunmiPrinter.printRow(cols: [
    //   ColumnMaker(
    //     text: "$column1",
    //     width: 10,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: "$column2",
    //     width: 10,
    //     align: SunmiPrintAlign.CENTER,
    //   ),
    //   ColumnMaker(
    //     text: "$column3",
    //     width: 10,
    //     align: SunmiPrintAlign.RIGHT,
    //   ),
    // ]);
    // await SunmiPrinter.lineWrap(1); // creates one line space
  }

  Future<void> printTotal(Map<String, dynamic> printSalesData) async {
    // creates one line space
    await SunmiPrinter.setCustomFontSize(23);
    await SunmiPrinter.bold();
    double tot =
        printSalesData["master"]["ba"] + printSalesData["master"]["net_amt"];
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Total ",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: printSalesData["master"]["net_amt"].toStringAsFixed(2),
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Balance",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${printSalesData["master"]["ba"].toStringAsFixed(2)}",
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    // await SunmiPrinter.printText("Grand Total : ${printSalesData["master"]["net_amt"].toStringAsFixed(2)}",
    //     style: SunmiStyle(
    //       fontSize: SunmiFontSize.MD,
    //       bold: true,
    //       align: SunmiPrintAlign.CENTER,
    //     ));

    await SunmiPrinter.line();

    await SunmiPrinter.bold();
    await SunmiPrinter.setCustomFontSize(23);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Grand Total",
        width: 14,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "${tot.toStringAsFixed(2)}",
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
  }

  Future<void> details(Map<String, dynamic> printSalesData) async {
    await SunmiPrinter.bold();

    await SunmiPrinter.setCustomFontSize(15);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Font size 15",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "F width 50 ",
        width: 30,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await SunmiPrinter.setCustomFontSize(18);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Font size 18",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "F width 40 ",
        width: 20,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await SunmiPrinter.setCustomFontSize(20);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Font size 20",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "F width 36 ",
        width: 16,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
  }

  /* its important to close the connection with the printer once you are done */
  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }

  // print one structure
  Future<void> printReceipt(Map<String, dynamic> printSalesData) async {
    print("value.printSalesData----${printSalesData}");
    await initialize();
    // await printLogoImage();
    // await printText("Flutter is awesome");
    await printHeader(printSalesData);
    await printRowAndColumns(printSalesData);
    await SunmiPrinter.line();
    await printTotal(printSalesData);

    // await details(printSalesData);

    // await printQRCode("Dart is powerful");
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.cut();
    await closePrinter();
  }
}
