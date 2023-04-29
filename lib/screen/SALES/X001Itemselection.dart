import 'package:badges/badges.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:orderapp/components/commoncolor.dart';

import 'package:orderapp/components/customSearchTile.dart';
import 'package:orderapp/components/customSnackbar.dart';
import 'package:orderapp/components/popupPayment.dart';
import 'package:orderapp/components/showMoadal.dart';
import 'package:orderapp/controller/controller.dart';
import 'package:orderapp/db_helper.dart';
import 'package:orderapp/screen/SALES/saleFilteredProductList.dart';
import 'package:orderapp/screen/SALES/saleItemDetails.dart';
import 'package:orderapp/screen/SALES/sale_bag_X001.dart';
import 'package:orderapp/screen/SALES/sale_cart.dart';

import 'package:provider/provider.dart';

import '../../components/X001_bottomsheet.dart';

class SalesItem extends StatefulWidget {
  // List<Map<String,dynamic>>  products;
  String customerId;
  String os;
  String areaId;
  String areaName;
  String type;
  bool _isLoading = false;
  String gtype;

  SalesItem(
      {required this.customerId,
      required this.areaId,
      required this.os,
      required this.areaName,
      required this.type,
      required this.gtype});

  @override
  State<SalesItem> createState() => _SalesItemState();
}

class _SalesItemState extends State<SalesItem> {
  PaymentSelect paysheet = PaymentSelect();
  CoconutSheet cocosheet = CoconutSheet();
  // double baseRate = 1.0;
  // String rate1 = "1";
  String? selected;
  String tempcode = "";
  double? temp;
  double? newqty = 0.0;
  TextEditingController searchcontroll = TextEditingController();
  ShowModal showModal = ShowModal();
  SaleItemDetails saleDetails = SaleItemDetails();
  List<Map<String, dynamic>> products = [];
  SearchTile search = SearchTile();
  DateTime now = DateTime.now();
  // CustomSnackbar snackbar = CustomSnackbar();
  List<String> s = [];
  String? date;
  bool loading = true;
  bool loading1 = false;
  CustomSnackbar snackbar = CustomSnackbar();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    searchcontroll.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("customer id....os....${widget.customerId}--${widget.os}");
    products = Provider.of<Controller>(context, listen: false).productName;
    print("products---${products}");
    Provider.of<Controller>(context, listen: false).selectSettings(
        "set_code in ('SL_RATE_EDIT','SL_TAX_CALC','SL_UPLOAD_DIRECT') ");
    Provider.of<Controller>(context, listen: false).getOrderno();
    date = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    s = date!.split(" ");

    // Provider.of<Controller>(context, listen: false)
    //     .getSaleProductList(widget.customerId);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        // shape: shape,
        // color: P_Settings.ratecolor,
        child: Consumer<Controller>(
          builder: (context, value, child) {
            return Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    // width: size.width * 0.3,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: P_Settings.ratecolor, // background
                        ),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Provider.of<Controller>(context, listen: false)
                              .selectSettings(
                                  "set_code in ('SL_RATE_EDIT','SL_TAX_CALC','SL_UPLOAD_DIRECT') ");

                          Provider.of<Controller>(context, listen: false)
                              .getSaleBagDetails(widget.customerId, widget.os);

                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false, // set to false
                              pageBuilder: (_, __, ___) => SaleCartX001(
                                areaId: widget.areaId,
                                custmerId: widget.customerId,
                                os: widget.os,
                                areaname: widget.areaName,
                                type: widget.type,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "View Data",
                          style: GoogleFonts.aBeeZee(
                            textStyle: Theme.of(context).textTheme.bodyText2,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: P_Settings.tableheadingColor,
                          ),
                        )),
                  ),
                  Expanded(
                    // width: size.width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // background
                      ),
                      onPressed: () {
                        print("hai");
                        if (value.salebagList.length > 0) {
                          paysheet.showpaymentSheet(
                              context,
                              widget.areaId,
                              widget.areaName,
                              widget.customerId,
                              s[0],
                              s[1],
                              " ",
                              " ",
                              value.orderTotal2[11]);
                        }
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.aBeeZee(
                          textStyle: Theme.of(context).textTheme.bodyText2,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: P_Settings.tableheadingColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    // width: size.width * 0.3,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                        ),
                        onPressed: () async {
                          if (value.salebagList.length > 0) {
                            _discardAlert(context, widget.customerId);
                          }
                        },
                        child: Text(
                          "Discard",
                          style: GoogleFonts.aBeeZee(
                            textStyle: Theme.of(context).textTheme.bodyText2,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: P_Settings.tableheadingColor,
                          ),
                        )),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<Controller>(context, listen: false).filterCompany =
                false;
            Provider.of<Controller>(context, listen: false)
                .filteredProductList
                .clear();
            Provider.of<Controller>(context, listen: false).searchkey = "";
            Provider.of<Controller>(context, listen: false).newList = products;
            Provider.of<Controller>(context, listen: false).fetchwallet();
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: P_Settings.salewaveColor,
        actions: <Widget>[
          // Consumer<Controller>(
          //   builder: (context, _value, child) {
          //     return PopupMenuButton<String>(
          //       onSelected: (value) {
          //         print("selected val............$selected");
          //         //  Provider.of<Controller>(context, listen: false)
          //         //     .filteredeValue = value;

          //         // if (value == "0") {
          //         //   setState(() {
          //         //     Provider.of<Controller>(context, listen: false)
          //         //         .filterCompany = false;
          //         //   });

          //         //   Provider.of<Controller>(context, listen: false)
          //         //       .filteredProductList
          //         //       .clear();
          //         //   Provider.of<Controller>(context, listen: false)
          //         //       .getProductList(widget.customerId);
          //         // } else {
          //         //   print("value---$value");
          //         //   Provider.of<Controller>(context, listen: false)
          //         //         .filterCompany = true;
          //         //   Provider.of<Controller>(context, listen: false)
          //         //       .filterwithCompany(widget.customerId, value,"sale order");
          //         // }///////////////

          //         Provider.of<Controller>(context, listen: false)
          //             .salefilteredeValue = value;
          //         if (value == "0") {
          //           setState(() {
          //             Provider.of<Controller>(context, listen: false)
          //                 .salefilterCompany = false;
          //           });

          //           Provider.of<Controller>(context, listen: false)
          //               .salefilteredProductList
          //               .clear();
          //           Provider.of<Controller>(context, listen: false)
          //               .getSaleProductList(widget.customerId);
          //         } else {
          //           print("value---$value");
          //           Provider.of<Controller>(context, listen: false)
          //               .salefilterCompany = true;
          //           Provider.of<Controller>(context, listen: false)
          //               .filterwithCompany(widget.customerId, value, "sales");
          //         }
          //       },
          //       itemBuilder: (context) => _value.productcompanyList
          //           .map((item) => PopupMenuItem<String>(
          //                 value: item["comid"],
          //                 child: Text(
          //                   item["comanme"],
          //                 ),
          //               ))
          //           .toList(),
          //     );
          //   },
          // ),
        ],
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) {
          return Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: size.width * 0.95,
                  height: size.height * 0.09,
                  child: TextField(
                    controller: searchcontroll,
                    onChanged: (value) {
                      Provider.of<Controller>(context, listen: false)
                          .setisVisible(true);
                      // Provider.of<Controller>(context, listen: false).isSearch=true;

                      // Provider.of<Controller>(context, listen: false)
                      //     .searchkey = value;

                      // Provider.of<Controller>(context, listen: false)
                      //     .searchProcess(widget.customerId, widget.os);
                      value = searchcontroll.text;
                    },
                    decoration: InputDecoration(
                      hintText: "Search with  Product code/Name/category",
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                      suffixIcon: value.isVisible
                          ? Wrap(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.done,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      // Provider.of<Controller>(context,
                                      //         listen: false)
                                      //     .getSaleProductList(
                                      //         widget.customerId);

                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .getSaleBagDetails(
                                              widget.customerId, widget.os);
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .searchkey = searchcontroll.text;

                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .setIssearch(true);
                                      // print("hjdf----$list");

                                      Provider.of<Controller>(context,
                                                  listen: false)
                                              .salefilterCompany
                                          ? Provider.of<Controller>(context,
                                                  listen: false)
                                              .searchProcess_X001(
                                                  widget.customerId,
                                                  widget.os,
                                                  Provider.of<Controller>(
                                                          context,
                                                          listen: false)
                                                      .salefilteredeValue!,
                                                  "sales",
                                                  value.salesitemList2,"sales")
                                          : Provider.of<Controller>(context,
                                                  listen: false)
                                              .searchProcess_X001(
                                                  widget.customerId,
                                                  widget.os,
                                                  "",
                                                  "sales",
                                                  value.salesitemList2,"sales");
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .fromSalesbagTable_X001(
                                              widget.customerId,"sales");
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .setIssearch(false);

                                      value.setisVisible(false);
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .newList
                                          .clear();

                                      searchcontroll.clear();
                                    }),
                              ],
                            )
                          : Icon(
                              Icons.search,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ),
              value.isLoading
                  ? Container(
                      child: CircularProgressIndicator(
                      color: P_Settings.salewaveColor,
                    ))
                  : value.salesitemList2.length == 0
                      ? _isLoading
                          ? CircularProgressIndicator()
                          : Container(
                              height: size.height * 0.6,
                              child: Text(
                                "No Products !!!",
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                      : Expanded(
                          child: value.isSearch
                              ? value.isListLoading
                                  ? Center(
                                      child: SpinKitCircle(
                                        color: P_Settings.salewaveColor,
                                        size: 40,
                                      ),
                                    )
                                  : value.newList.length == 0
                                      ? Container(
                                          child: Text("No data Found!!!!"),
                                        )
                                      : ListView.builder(
                                          itemExtent: 60,
                                          shrinkWrap: true,
                                          itemCount: value.newList.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.4,
                                                  right: 0.4,
                                                  bottom: 0.2),
                                              child: Card(
                                                child: Ink(
                                                  // color: value.newList[index][
                                                  //                 "cartrowno"] ==
                                                  //             null ||
                                                  //         value.qty[index]
                                                  //                 .text ==
                                                  //             null ||
                                                  //         value.qty[index].text
                                                  //             .isEmpty
                                                  //     ? value.selected[index]
                                                  //         ? Color.fromARGB(255,
                                                  //             226, 225, 225)
                                                  //         : Colors.white
                                                  //     : Color.fromARGB(
                                                  //         255, 226, 225, 225),
                                                  child: ListTile(
                                                    onTap: () async {
                                                      print("clickedddd---");
                                                      Provider.of<Controller>(
                                                                  context,
                                                                  listen: false)
                                                              .product_code =
                                                          value.newList[index]
                                                              ["prcode"];

                                                      // Provider.of<Controller>(
                                                      //         context,
                                                      //         listen: false)
                                                      //     .fetchProductUnits(
                                                      //         value.salesitemList2[
                                                      //                 index]
                                                      //             ["prid"]);
                                                      await Provider.of<
                                                                  Controller>(
                                                              context,
                                                              listen: false)
                                                          .fromSalesListData_X001(
                                                              widget.customerId,
                                                              value
                                                                  .product_code!,
                                                              index);
                                                      value.selectedunit_X001 =
                                                          null;
                                                      print(
                                                          "item name...${value.salesitemListdata2[0]['item']}");
                                                      if (value.isLoading) {
                                                        CircularProgressIndicator();
                                                      } else {
                                                        value
                                                            .discount_prercent_X001[
                                                                index]
                                                            .text = "0.0";
                                                        value
                                                            .discount_amount_X001[
                                                                index]
                                                            .text = "0.0";
                                                        print(
                                                            "kjdjfkj-${value.salesitemListdata2[0]['code']}----${value.salesitemListdata2[0]['item']}---${value.salesitemListdata2[0]['rate1']}----${value.salesitemListdata2[0]['tax']}");
                                                        // value.selectedItem =
                                                        //     null;
                                                        value.selectedunit_X001 =
                                                            null;
                                                        value.gross = 0.00;
                                                        value.net_amt = 0.00;
                                                        value.tax = 0.00;
                                                        value.salesqty_X001[
                                                                index]
                                                            .clear();
                                                        value.salesrate_X001[
                                                                index]
                                                            .clear();
                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .setUnitSale_X001(
                                                                value
                                                                    .frstDropDown!,
                                                                index);
                                                        value.selectedItem =
                                                            value.frstDropDown;

                                                        value
                                                            .salesqty_X001[
                                                                index]
                                                            .text = "1.0";
                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .rawCalculation_X001(
                                                                double.parse(value
                                                                    .salesrate_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                    .salesqty_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                    .discount_prercent_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                    .discount_amount_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                        .salesitemListdata2[0]
                                                                    ['tax']),
                                                                0.0,
                                                                value
                                                                    .settingsList1[1]
                                                                        ['set_value']
                                                                    .toString(),
                                                                0,
                                                                index,
                                                                true,
                                                                "");

                                                        cocosheet
                                                            .showsalesMoadlBottomsheet(
                                                          value.salesitemListdata2[
                                                              0]['item'],
                                                          value.salesitemListdata2[
                                                              0]['code'],
                                                          double.parse(value
                                                                  .salesitemListdata2[
                                                              0]['rate1']),
                                                          0.00,
                                                          0.00,
                                                          double.parse(value
                                                                  .salesitemListdata2[
                                                              0]['tax']),
                                                          0.00,
                                                          0.00,
                                                          context,
                                                          size,
                                                          index,
                                                          widget.customerId,
                                                          widget.os,
                                                          0.0,
                                                          s[0],
                                                          s[1],
                                                        );
                                                      }
                                                    },
                                                    dense: true,
                                                    title: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          flex: 5,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${value.newList[index]["pritem"]}' +
                                                                    '- ' +
                                                                    '${value.newList[index]["prcode"]}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    // color: value.newList[index]
                                                                    //             [
                                                                    //             "cartrowno"] ==
                                                                    //         null
                                                                    //     ? value.selected[
                                                                    //             index]
                                                                    //         ? Colors
                                                                    //             .black
                                                                    //         : Colors
                                                                    //             .black
                                                                    //     : Colors
                                                                    //         .black,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // value.newList[index]
                                                              //             [
                                                              //             "qty"] ==
                                                              //         null
                                                              //     ? Container()
                                                              //     : Text(
                                                              //         "${value.newList[index]["qty"]}",
                                                              //         style: TextStyle(
                                                              //             fontSize:
                                                              //                 18,
                                                              //             fontWeight: FontWeight
                                                              //                 .bold,
                                                              //             color:
                                                              //                 P_Settings.wavecolor),
                                                              //       ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.012),
                                                        // Row(
                                                        //   children: [
                                                        //     value.newList[index]
                                                        //                 [
                                                        //                 "prunit"] ==
                                                        //             null
                                                        //         ? Container()
                                                        //         : Row(
                                                        //             mainAxisAlignment:
                                                        //                 MainAxisAlignment
                                                        //                     .start,
                                                        //             children: [
                                                        //               // SizedBox(
                                                        //               //   width: size.width *
                                                        //               //       0.03,
                                                        //               // ),
                                                        //               Container(
                                                        //                   child:
                                                        //                       Text(
                                                        //                 value.newList[index]["prunit"] ==
                                                        //                         null
                                                        //                     ? " "
                                                        //                     : value.newList[index]["prunit"].toString(),
                                                        //                 style: TextStyle(
                                                        //                     color:
                                                        //                         P_Settings.unitcolor,
                                                        //                     fontWeight: FontWeight.bold,
                                                        //                     fontSize: 15),
                                                        //               )),
                                                        //               SizedBox(
                                                        //                 width: size.width *
                                                        //                     0.02,
                                                        //               ),
                                                        //               Container(
                                                        //                 child:
                                                        //                     Text(
                                                        //                   ' / ${value.newList[index]["pkg"]}',
                                                        //                   style: TextStyle(
                                                        //                       color: Colors.black,
                                                        //                       fontSize: 15,
                                                        //                       fontWeight: FontWeight.bold),
                                                        //                 ),
                                                        //               ),
                                                        //               // value.qty[index].text == "0" ||
                                                        //               //         value.qty[index].text ==
                                                        //               //             null
                                                        //               //     ? Container()
                                                        //               //     : BlinkText(
                                                        //               //         '${value.qty[index].text}',
                                                        //               //         style: TextStyle(
                                                        //               //           fontWeight: FontWeight.bold,
                                                        //               //           color: Color.fromARGB(255, 25, 66, 26),
                                                        //               //           fontStyle: FontStyle.italic,
                                                        //               //         ),
                                                        //               //         endColor: Colors.white,
                                                        //               //         duration: Duration(milliseconds: 2000)),
                                                        //             ],
                                                        //           ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),
                                                    // trailing: Text(
                                                    //   '  \u{20B9}${value.newList[index]["prrate1"]}',
                                                    //   style: const TextStyle(
                                                    //     fontSize: 16,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //     color: Color.fromARGB(
                                                    //         255, 25, 55, 185),
                                                    //     fontStyle:
                                                    //         FontStyle.italic,
                                                    //   ),
                                                    // ),
                                                    // trailing: Row(
                                                    //   mainAxisSize:
                                                    //       MainAxisSize.min,
                                                    //   children: [
                                                    //     SizedBox(
                                                    //       width: 10,
                                                    //     ),
                                                    //     IconButton(
                                                    //       icon: Icon(
                                                    //         Icons.add,
                                                    //       ),
                                                    //       onPressed: () async {
                                                    //         var total;

                                                    //         double qty;

                                                    //         if (value
                                                    //                 .qty[index]
                                                    //                 .text
                                                    //                 .isNotEmpty ||
                                                    //             value.qty[index]
                                                    //                     .text !=
                                                    //                 null) {
                                                    //           newqty = value
                                                    //                   .qty[
                                                    //                       index]
                                                    //                   .text
                                                    //                   .isEmpty
                                                    //               ? 0
                                                    //               : double.parse(value
                                                    //                   .qty[
                                                    //                       index]
                                                    //                   .text);
                                                    //           temp =
                                                    //               newqty! + 1;
                                                    //           print(
                                                    //               "temp--.........$newqty--${temp}");
                                                    //         } else {
                                                    //           newqty = 0.0;
                                                    //           temp = 0;
                                                    //           print(
                                                    //               "temp--.........--${temp}");
                                                    //         }

                                                    //         value.qty[index]
                                                    //                 .text =
                                                    //             temp.toString();
                                                    //         total = value
                                                    //                 .newList[
                                                    //                     index][
                                                    //                     "prrate1"]
                                                    //                 .toDouble() *
                                                    //             double.parse(value
                                                    //                 .qty[index]
                                                    //                 .text);

                                                    //         String os = "S" +
                                                    //             "${value.ordernum[0]["os"]}";
                                                    //         // value.qtyups(
                                                    //         //   index,
                                                    //         //   "salesBagTable",
                                                    //         //   value.productName[
                                                    //         //       index]["code"],
                                                    //         //   widget.customerId,os
                                                    //         // );
                                                    //         Provider.of<Controller>(
                                                    //                 context,
                                                    //                 listen:
                                                    //                     false)
                                                    //             .selectSettings(
                                                    //                 "set_code in ('SL_RATE_EDIT','SL_TAX_CALC','SL_UPLOAD_DIRECT') ");

                                                    //         setState(() {
                                                    //           if (value.selected[
                                                    //                   index] ==
                                                    //               false) {
                                                    //             value.selected[
                                                    //                     index] =
                                                    //                 !value.selected[
                                                    //                     index];
                                                    //             // selected = index;
                                                    //           }
                                                    //         });
                                                    //         ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    //         int max = await OrderAppDB
                                                    //             .instance
                                                    //             .getMaxCommonQuery(
                                                    //                 'salesBagTable',
                                                    //                 'cartrowno',
                                                    //                 "os='${os}' AND customerid='${widget.customerId}'");
                                                    //         String? unit_name =
                                                    //             Provider.of<Controller>(
                                                    //                     context,
                                                    //                     listen:
                                                    //                         false)
                                                    //                 .selectunit;

                                                    //         var pid = value
                                                    //                 .newList[
                                                    //             index]['prid'];

                                                    //         // var unitres = await OrderAppDB
                                                    //         //     .instance
                                                    //         //     .selectAllcommon(
                                                    //         //         "productUnits",
                                                    //         //         "unit_name=='$unit_name' AND pid = '${value.newList[index]['pid']}'");
                                                    //         // print(
                                                    //         //     "unit packet curresponds to unitname........$pid...$unitres....$unit_name");

                                                    //         // print(
                                                    //         //     "base rate val for............$baseRate.....$rate1");

                                                    //         // print(
                                                    //         //     "total rate..... $total");

                                                    //         double qtyNew = 0.0;
                                                    //         double
                                                    //             discounamttNew =
                                                    //             0.0;
                                                    //         double
                                                    //             discounpertNew =
                                                    //             0.0;
                                                    //         double cesspertNew =
                                                    //             0.0;

                                                    //         String result = Provider.of<Controller>(context, listen: false).rawCalculation(
                                                    //             value.newList[
                                                    //                     index][
                                                    //                     "prrate1"]
                                                    //                 .toDouble(),
                                                    //             double.parse(value
                                                    //                 .qty[index]
                                                    //                 .text),
                                                    //             discounpertNew,
                                                    //             discounamttNew,
                                                    //             double.parse(value
                                                    //                     .newList[index]
                                                    //                 ["prtax"]),
                                                    //             cesspertNew,
                                                    //             value
                                                    //                 .settingsList1[1]
                                                    //                     ['set_value']
                                                    //                 .toString(),
                                                    //             int.parse(widget.gtype),
                                                    //             index,
                                                    //             false,
                                                    //             "");

                                                    //         print(
                                                    //             "result----$result");
                                                    //         if (result ==
                                                    //             "success") {
                                                    //           print(
                                                    //               "prrate1------${value.newList[index]["prrate1"]}------${value.taxable_rate}");
                                                    //           var res = await OrderAppDB.instance.insertsalesBagTable(
                                                    //               value.newList[index]["pritem"],
                                                    //               s[0],
                                                    //               s[1],
                                                    //               widget.os,
                                                    //               widget.customerId,
                                                    //               max,
                                                    //               value.newList[index]["prcode"],
                                                    //               double.parse(value.qty[index].text),
                                                    //               value.newList[index]["prrate1"].toString(),
                                                    //               value.taxable_rate,
                                                    //               total,
                                                    //               "0",
                                                    //               value.newList[index]["prhsn"],
                                                    //               double.parse(
                                                    //                 value.newList[
                                                    //                         index]
                                                    //                     [
                                                    //                     "prtax"],
                                                    //               ),
                                                    //               value.tax,
                                                    //               value.cgst_per,
                                                    //               value.cgst_amt,
                                                    //               value.sgst_per,
                                                    //               value.sgst_amt,
                                                    //               value.igst_per,
                                                    //               value.igst_amt,
                                                    //               discounpertNew,
                                                    //               discounamttNew,
                                                    //               0.0,
                                                    //               value.cess,
                                                    //               0,
                                                    //               value.net_amt,
                                                    //               pid,
                                                    //               value.newList[index]["prunit"],
                                                    //               value.newList[index]["pkg"].toDouble(),
                                                    //               double.parse(value.newList[index]["prbaserate"]));

                                                    //           snackbar.showSnackbar(
                                                    //               context,
                                                    //               "${value.newList[index]["prcode"] + value.newList[index]['pritem']} - Added to cart",
                                                    //               "sales");
                                                    //           Provider.of<Controller>(
                                                    //                   context,
                                                    //                   listen:
                                                    //                       false)
                                                    //               .countFromTable(
                                                    //             "salesBagTable",
                                                    //             widget.os,
                                                    //             widget
                                                    //                 .customerId,
                                                    //           );
                                                    //         }

                                                    //         /////////////////////////
                                                    //         (widget.customerId.isNotEmpty ||
                                                    //                     widget.customerId !=
                                                    //                         null) &&
                                                    //                 (value.newList[index]["prcode"].isNotEmpty ||
                                                    //                     value.newList[index]["prcode"] !=
                                                    //                         null)
                                                    //             ? Provider.of<
                                                    //                         Controller>(
                                                    //                     context,
                                                    //                     listen:
                                                    //                         false)
                                                    //                 .calculatesalesTotal(
                                                    //                     widget
                                                    //                         .os,
                                                    //                     widget
                                                    //                         .customerId)
                                                    //             : Text(
                                                    //                 "No data");
                                                    //       },
                                                    //       color: Colors.black,
                                                    //     ),
                                                    //     IconButton(
                                                    //         icon: Icon(
                                                    //           Icons.delete,
                                                    //           size: 18,
                                                    //           // color: Colors.redAccent,
                                                    //         ),
                                                    //         onPressed: value.newList[
                                                    //                         index]
                                                    //                     [
                                                    //                     "cartrowno"] ==
                                                    //                 null
                                                    //             ? value.selected[
                                                    //                     index]
                                                    //                 ? () async {
                                                    //                     String
                                                    //                         item =
                                                    //                         value.newList[index]["prcode"] +
                                                    //                             value.newList[index]["pritem"];
                                                    //                     Provider.of<Controller>(context, listen: false).getSaleBagDetails(
                                                    //                         widget.customerId,
                                                    //                         widget.os);
                                                    //                     showModal.showMoadlBottomsheet(
                                                    //                         widget.os,
                                                    //                         widget.customerId,
                                                    //                         item,
                                                    //                         size,
                                                    //                         context,
                                                    //                         "newlist just added",
                                                    //                         value.newList[index]["prcode"],
                                                    //                         index,
                                                    //                         "no filter",
                                                    //                         "",
                                                    //                         value.qty[index],
                                                    //                         "sales");
                                                    //                   }
                                                    //                 : null
                                                    //             : () async {
                                                    //                 String item = value.newList[index]
                                                    //                         [
                                                    //                         "prcode"] +
                                                    //                     value.newList[index]
                                                    //                         [
                                                    //                         "pritem"];

                                                    //                 showModal.showMoadlBottomsheet(
                                                    //                     widget
                                                    //                         .os,
                                                    //                     widget
                                                    //                         .customerId,
                                                    //                     item,
                                                    //                     size,
                                                    //                     context,
                                                    //                     "newlist already in cart",
                                                    //                     value.newList[index]
                                                    //                         [
                                                    //                         "prcode"],
                                                    //                     index,
                                                    //                     "no filter",
                                                    //                     "",
                                                    //                     value.qty[
                                                    //                         index],
                                                    //                     "sales");
                                                    //               })
                                                    //   ],
                                                    // ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                              : value.salefilterCompany
                                  ? SaleFilteredProduct(
                                      type: widget.type,
                                      customerId: widget.customerId,
                                      os: widget.os,
                                      s: s,
                                      value: Provider.of<Controller>(context,
                                              listen: false)
                                          .salefilteredeValue,
                                      gtype: widget.gtype,
                                    )
                                  : value.isLoading
                                      ? CircularProgressIndicator()
                                      : ListView.builder(
                                          itemExtent: 60,
                                          shrinkWrap: true,
                                          itemCount:
                                              value.salesitemList2.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.4,
                                                  right: 0.4,
                                                  bottom: 0.2),
                                              child: Card(
                                                child: Ink(
                                                  // color: value.salesitemList2[
                                                  //                 index]
                                                  //             ["cartrowno"] ==
                                                  //         null
                                                  //     ? value.selected[index]
                                                  //         ? Color.fromARGB(255,
                                                  //             226, 225, 225)
                                                  //         : Colors.white
                                                  //     : Color.fromARGB(
                                                  //         255, 226, 225, 225),
                                                  child: ListTile(
                                                    onTap: () async {
                                                      Provider.of<Controller>(
                                                                  context,
                                                                  listen: false)
                                                              .product_code =
                                                          value.salesitemList2[
                                                              index]["prcode"];

                                                      // Provider.of<Controller>(
                                                      //         context,
                                                      //         listen: false)
                                                      //     .fetchProductUnits(
                                                      //         value.salesitemList2[
                                                      //                 index]
                                                      //             ["prid"]);
                                                      await Provider.of<
                                                                  Controller>(
                                                              context,
                                                              listen: false)
                                                          .fromSalesListData_X001(
                                                              widget.customerId,
                                                              value
                                                                  .product_code!,
                                                              index);
                                                      value.selectedunit_X001 =
                                                          null;
                                                      print(
                                                          "item name...${value.salesitemListdata2[0]['item']}");
                                                      if (value.isLoading) {
                                                        CircularProgressIndicator();
                                                      } else {
                                                        value
                                                            .discount_prercent_X001[
                                                                index]
                                                            .text = "0.0";
                                                        value
                                                            .discount_amount_X001[
                                                                index]
                                                            .text = "0.0";
                                                        print(
                                                            "kjdjfkj-${value.salesitemListdata2[0]['code']}----${value.salesitemListdata2[0]['item']}---${value.salesitemListdata2[0]['rate1']}----${value.salesitemListdata2[0]['tax']}");
                                                        // value.selectedItem =
                                                        //     null;
                                                        value.gross = 0.00;
                                                        value.net_amt = 0.00;
                                                        value.tax = 0.00;
                                                        value.salesqty_X001[
                                                                index]
                                                            .clear();
                                                        value.salesrate_X001[
                                                                index]
                                                            .clear();

                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .setUnitSale_X001(
                                                                value
                                                                    .frstDropDown!,
                                                                index);
                                                        value.selectedItem =
                                                            value.frstDropDown;

                                                        value
                                                            .salesqty_X001[
                                                                index]
                                                            .text = "1.0";
                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .rawCalculation_X001(
                                                                double.parse(value
                                                                    .salesrate_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                    .salesqty_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                    .discount_prercent_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                    .discount_amount_X001[
                                                                        index]
                                                                    .text),
                                                                double.parse(value
                                                                        .salesitemListdata2[0]
                                                                    ['tax']),
                                                                0.0,
                                                                value
                                                                    .settingsList1[1]
                                                                        ['set_value']
                                                                    .toString(),
                                                                0,
                                                                index,
                                                                true,
                                                                "");

                                                        cocosheet
                                                            .showsalesMoadlBottomsheet(
                                                          value.salesitemListdata2[
                                                              0]['item'],
                                                          value.salesitemListdata2[
                                                              0]['code'],
                                                          double.parse(value
                                                                  .salesitemListdata2[
                                                              0]['rate1']),
                                                          0.00,
                                                          0.00,
                                                          double.parse(value
                                                                  .salesitemListdata2[
                                                              0]['tax']),
                                                          0.00,
                                                          0.00,
                                                          context,
                                                          size,
                                                          index,
                                                          widget.customerId,
                                                          widget.os,
                                                          0.0,
                                                          s[0],
                                                          s[1],
                                                        );
                                                      }
                                                    },
                                                    dense: true,
                                                    title: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          flex: 5,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${value.salesitemList2[index]["pritem"]}' +
                                                                    '- ' +
                                                                    '${value.salesitemList2[index]["prcode"]}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    // color: value.salesitemList2[index]
                                                                    //             [
                                                                    //             "cartrowno"] ==
                                                                    //         null
                                                                    //     ? value.selected[
                                                                    //             index]
                                                                    //         ? Colors
                                                                    //             .black
                                                                    //         : Colors
                                                                    //             .black
                                                                    //     : Colors
                                                                    //         .black,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // value.salesitemList2[index]
                                                              //             [
                                                              //             "qty"] ==
                                                              //         null
                                                              //     ? Container()
                                                              //     : Text(
                                                              //         "${value.salesitemList2[index]["qty"]}",
                                                              //         style: TextStyle(
                                                              //             fontSize:
                                                              //                 18,
                                                              //             fontWeight: FontWeight
                                                              //                 .bold,
                                                              //             color:
                                                              //                 P_Settings.wavecolor),
                                                              //       ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.012),
                                                        // Row(
                                                        //   children: [
                                                        //     value.productName[
                                                        //                     index]
                                                        //                 [
                                                        //                 "prunit"] ==
                                                        //             null
                                                        //         ? Container()
                                                        //         : Row(
                                                        //             mainAxisAlignment:
                                                        //                 MainAxisAlignment
                                                        //                     .start,
                                                        //             children: [
                                                        //               // value.qty[index].text == "0" ||
                                                        //               //         value.qty[index].text ==
                                                        //               //             null
                                                        //               //     ? Container()
                                                        //               //     : BlinkText(
                                                        //               //         '${value.qty[index].text}',
                                                        //               //         style: TextStyle(
                                                        //               //           fontWeight: FontWeight.bold,
                                                        //               //           color: Color.fromARGB(255, 25, 66, 26),
                                                        //               //           fontStyle: FontStyle.italic,
                                                        //               //         ),
                                                        //               //         endColor: Colors.white,
                                                        //               //         duration: Duration(milliseconds: 2000)),
                                                        //               // SizedBox(
                                                        //               //   width: size.width *
                                                        //               //       0.03,
                                                        //               // ),
                                                        //               Container(
                                                        //                   child:
                                                        //                       Text(
                                                        //                 value.productName[index]["prunit"] ==
                                                        //                         null
                                                        //                     ? " "
                                                        //                     : value.productName[index]["prunit"].toString(),
                                                        //                 style: TextStyle(
                                                        //                     color:
                                                        //                         P_Settings.unitcolor,
                                                        //                     fontWeight: FontWeight.bold,
                                                        //                     fontSize: 15),
                                                        //               )),
                                                        //               SizedBox(
                                                        //                 width: size.width *
                                                        //                     0.02,
                                                        //               ),
                                                        //               Container(
                                                        //                 child:
                                                        //                     Text(
                                                        //                   ' / ${value.productName[index]["pkg"]}',
                                                        //                   style: TextStyle(
                                                        //                       color: Colors.black,
                                                        //                       fontSize: 15,
                                                        //                       fontWeight: FontWeight.bold),
                                                        //                 ),
                                                        //               ),
                                                        //             ],
                                                        //           ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),

                                                    // trailing: Text(
                                                    //   '  \u{20B9}${value.productName[index]["prrate1"]}',
                                                    //   style: const TextStyle(
                                                    //     fontSize: 16,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //     color: Color.fromARGB(
                                                    //         255, 25, 55, 185),
                                                    //     fontStyle:
                                                    //         FontStyle.italic,
                                                    //   ),
                                                    // ),
                                                    // trailing: Wrap(
                                                    //   spacing: 0,
                                                    //   children: [
                                                    //     Row(
                                                    //       // mainAxisAlignment: MainAxisAlignment.center,
                                                    //       // crossAxisAlignment: CrossAxisAlignment.center,
                                                    //       mainAxisSize:
                                                    //           MainAxisSize.min,
                                                    //       children: [
                                                    //         /////////////////////////////////////////
                                                    //         Container(
                                                    //           width:
                                                    //               size.width *
                                                    //                   0.15,
                                                    //           child: TextField(
                                                    //             autofocus: true,
                                                    //             onTap: () {
                                                    //               // value.coconutRate[index].selection = TextSelection(
                                                    //               //     baseOffset:
                                                    //               //         0,
                                                    //               // extentOffset: value
                                                    //               //     .productName[
                                                    //               //         index]
                                                    //               //         [
                                                    //               //         "prrate1"]
                                                    //               //     .text
                                                    //               //     .length);
                                                    //             },
                                                    //             style:
                                                    //                 TextStyle(
                                                    //               fontSize:
                                                    //                   15.0,
                                                    //             ),
                                                    //             decoration:
                                                    //                 const InputDecoration(
                                                    //               isDense: true,
                                                    //               contentPadding:
                                                    //                   EdgeInsets
                                                    //                       .all(
                                                    //                           0), //  <- you can it to 0.0 for no space

                                                    //               //border: InputBorder.none
                                                    //             ),
                                                    //             keyboardType:
                                                    //                 TextInputType
                                                    //                     .number,
                                                    //             onSubmitted:
                                                    //                 (values) async {
                                                    //               print(
                                                    //                   "values----$values");
                                                    //               double
                                                    //                   valuerate =
                                                    //                   0.0;
                                                    //               // value.discount_amount[index].text=;
                                                    //               if (values
                                                    //                   .isNotEmpty) {
                                                    //                 print(
                                                    //                     "emtyyyy");
                                                    //                 valuerate =
                                                    //                     double.parse(
                                                    //                         values);
                                                    //               } else {
                                                    //                 valuerate =
                                                    //                     0.00;
                                                    //               }
                                                    //               var total;
                                                    //               String os = "S" +
                                                    //                   "${value.ordernum[0]["os"]}";
                                                    //               int max = await OrderAppDB
                                                    //                   .instance
                                                    //                   .getMaxCommonQuery(
                                                    //                       'salesBagTable',
                                                    //                       'cartrowno',
                                                    //                       "os='${os}' AND customerid='${widget.customerId}'");

                                                    //               total = double.parse(value
                                                    //                       .coconutRate[
                                                    //                           index]
                                                    //                       .text) *
                                                    //                   double.parse(value
                                                    //                       .qty[
                                                    //                           index]
                                                    //                       .text);
                                                    //               print(
                                                    //                   "total rate.....$total");
                                                    //               print(
                                                    //                   "new rate..........${value.coconutRate[index].text}");
                                                    //               var pid = value
                                                    //                           .productName[
                                                    //                       index]
                                                    //                   ['prid'];
                                                    //               var res = await OrderAppDB.instance.insertsalesBagTable(
                                                    //                   value.productName[index]["pritem"],
                                                    //                   s[0],
                                                    //                   s[1],
                                                    //                   widget.os,
                                                    //                   widget.customerId,
                                                    //                   max,
                                                    //                   value.productName[index]["prcode"],
                                                    //                   value.productName[index]["qty"],
                                                    //                   value.coconutRate[index].text.toString(),
                                                    //                   value.taxable_rate,
                                                    //                   total,
                                                    //                   "0",
                                                    //                   value.productName[index]["prhsn"],
                                                    //                   double.parse(
                                                    //                     value.productName[index]
                                                    //                         [
                                                    //                         "prtax"],
                                                    //                   ),
                                                    //                   value.tax,
                                                    //                   value.cgst_per,
                                                    //                   value.cgst_amt,
                                                    //                   value.sgst_per,
                                                    //                   value.sgst_amt,
                                                    //                   value.igst_per,
                                                    //                   value.igst_amt,
                                                    //                   0.0,
                                                    //                   0.0,
                                                    //                   0.0,
                                                    //                   value.cess,
                                                    //                   0,
                                                    //                   value.net_amt,
                                                    //                   pid,
                                                    //                   value.productName[index]["prunit"],
                                                    //                   value.productName[index]["pkg"].toDouble(),
                                                    //                   double.parse(value.productName[index]["prbaserate"]));
                                                    //             },
                                                    //             textAlign:
                                                    //                 TextAlign
                                                    //                     .right,
                                                    //             controller:
                                                    //                 value.coconutRate[
                                                    //                     index],
                                                    //           ),
                                                    //         ),
                                                    //         // Container(
                                                    //         //   child: Text(
                                                    //         //     '  \u{20B9}${value.productName[index]["prrate1"]}',
                                                    //         //     style:
                                                    //         //         const TextStyle(
                                                    //         //       fontSize: 16,
                                                    //         //       fontWeight:
                                                    //         //           FontWeight
                                                    //         //               .bold,
                                                    //         //       color: Color
                                                    //         //           .fromARGB(
                                                    //         //               255,
                                                    //         //               25,
                                                    //         //               55,
                                                    //         //               185),
                                                    //         //       fontStyle:
                                                    //         //           FontStyle
                                                    //         //               .italic,
                                                    //         //     ),
                                                    //         //   ),
                                                    //         // ),
                                                    //         IconButton(
                                                    //           icon: Icon(
                                                    //             Icons.add,
                                                    //           ),
                                                    //           onPressed:
                                                    //               () async {
                                                    //             var total;
                                                    //             print(
                                                    //                 "quantity............${value.qty[index].text}");
                                                    //             double? qty =
                                                    //                 0.0;
                                                    //             if (value
                                                    //                     .qty[
                                                    //                         index]
                                                    //                     .text
                                                    //                     .isNotEmpty ||
                                                    //                 value.qty[index]
                                                    //                         .text !=
                                                    //                     null) {
                                                    //               newqty = value
                                                    //                       .qty[
                                                    //                           index]
                                                    //                       .text
                                                    //                       .isEmpty
                                                    //                   ? 0
                                                    //                   : double.parse(value
                                                    //                       .qty[
                                                    //                           index]
                                                    //                       .text);
                                                    //               temp =
                                                    //                   newqty! +
                                                    //                       1;
                                                    //               print(
                                                    //                   "temp--.........$newqty--${temp}");
                                                    //             } else {
                                                    //               newqty = 0.0;
                                                    //               temp = 0;
                                                    //               print(
                                                    //                   "temp--.........--${temp}");
                                                    //             }

                                                    //             value.qty[index]
                                                    //                     .text =
                                                    //                 temp.toString();

                                                    //             print(
                                                    //                 "tttt--......$temp--${value.qty[index].text}");
                                                    //             total = products[index]
                                                    //                         [
                                                    //                         "prrate1"]
                                                    //                     .toDouble() *
                                                    //                 double.parse(value
                                                    //                     .qty[
                                                    //                         index]
                                                    //                     .text);

                                                    //             print(
                                                    //                 "var total-----$total");

                                                    //             String os = "S" +
                                                    //                 "${value.ordernum[0]["os"]}";

                                                    //             Provider.of<Controller>(
                                                    //                     context,
                                                    //                     listen:
                                                    //                         false)
                                                    //                 .selectSettings(
                                                    //                     "set_code in ('SL_RATE_EDIT','SL_TAX_CALC','SL_UPLOAD_DIRECT') ");

                                                    //             setState(() {
                                                    //               if (value.selected[
                                                    //                       index] ==
                                                    //                   false) {
                                                    //                 value.selected[
                                                    //                     index] = !value
                                                    //                         .selected[
                                                    //                     index];
                                                    //                 // selected = index;
                                                    //               }
                                                    //             });
                                                    //             ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    //             int max = await OrderAppDB
                                                    //                 .instance
                                                    //                 .getMaxCommonQuery(
                                                    //                     'salesBagTable',
                                                    //                     'cartrowno',
                                                    //                     "os='${os}' AND customerid='${widget.customerId}'");
                                                    //             String? unit_name = Provider.of<
                                                    //                         Controller>(
                                                    //                     context,
                                                    //                     listen:
                                                    //                         false)
                                                    //                 .selectunit;

                                                    //             var pid = value
                                                    //                     .productName[
                                                    //                 index]['prid'];

                                                    //             var unitres = await OrderAppDB
                                                    //                 .instance
                                                    //                 .selectAllcommon(
                                                    //                     "productUnits",
                                                    //                     "unit_name=='$unit_name' AND pid = '${value.productName[index]['pid']}'");

                                                    //             double qtyNew =
                                                    //                 0.0;
                                                    //             double
                                                    //                 discounamttNew =
                                                    //                 0.0;
                                                    //             double
                                                    //                 discounpertNew =
                                                    //                 0.0;
                                                    //             double
                                                    //                 cesspertNew =
                                                    //                 0.0;

                                                    //             List
                                                    //                 qtyNewList =
                                                    //                 await OrderAppDB
                                                    //                     .instance
                                                    //                     .selectAllcommon(
                                                    //                         'salesBagTable',
                                                    //                         "os='${os}' AND customerid='${widget.customerId}' AND code='${value.productName[index]["prcode"]}'");

                                                    //             print(
                                                    //                 "qtynewlisy=======$qtyNewList");

                                                    //             if (qtyNewList
                                                    //                     .length >
                                                    //                 0) {
                                                    //               discounamttNew =
                                                    //                   qtyNewList[
                                                    //                           0]
                                                    //                       [
                                                    //                       "discount_amt"];
                                                    //               discounpertNew =
                                                    //                   qtyNewList[
                                                    //                           0]
                                                    //                       [
                                                    //                       "discount_per"];
                                                    //               cesspertNew =
                                                    //                   qtyNewList[
                                                    //                           0]
                                                    //                       [
                                                    //                       "ces_per"];
                                                    //             }

                                                    //             String result = Provider.of<Controller>(context, listen: false).rawCalculation(
                                                    //                 products[index]
                                                    //                         [
                                                    //                         "prrate1"]
                                                    //                     .toDouble(),
                                                    //                 double.parse(value
                                                    //                     .qty[
                                                    //                         index]
                                                    //                     .text),
                                                    //                 discounpertNew,
                                                    //                 discounamttNew,
                                                    //                 double.parse(
                                                    //                     value.productName[index]
                                                    //                         [
                                                    //                         "prtax"]),
                                                    //                 cesspertNew,
                                                    //                 value
                                                    //                     .settingsList1[1]
                                                    //                         ['set_value']
                                                    //                     .toString(),
                                                    //                 int.parse(widget.gtype),
                                                    //                 index,
                                                    //                 false,
                                                    //                 "");

                                                    //             print(
                                                    //                 "result----$result");
                                                    //             if (result ==
                                                    //                 "success") {
                                                    //               print(
                                                    //                   "prrate1------${products[index]["prrate1"]}------${value.taxable_rate}");
                                                    //               var res = await OrderAppDB.instance.insertsalesBagTable(
                                                    //                   products[index]["pritem"],
                                                    //                   s[0],
                                                    //                   s[1],
                                                    //                   widget.os,
                                                    //                   widget.customerId,
                                                    //                   max,
                                                    //                   products[index]["prcode"],
                                                    //                   double.parse(value.qty[index].text),
                                                    //                   products[index]["prrate1"].toString(),
                                                    //                   value.taxable_rate,
                                                    //                   total,
                                                    //                   "0",
                                                    //                   products[index]["prhsn"],
                                                    //                   double.parse(
                                                    //                     products[index]
                                                    //                         [
                                                    //                         "prtax"],
                                                    //                   ),
                                                    //                   value.tax,
                                                    //                   value.cgst_per,
                                                    //                   value.cgst_amt,
                                                    //                   value.sgst_per,
                                                    //                   value.sgst_amt,
                                                    //                   value.igst_per,
                                                    //                   value.igst_amt,
                                                    //                   discounpertNew,
                                                    //                   discounamttNew,
                                                    //                   0.0,
                                                    //                   value.cess,
                                                    //                   0,
                                                    //                   value.net_amt,
                                                    //                   pid,
                                                    //                   products[index]["prunit"],
                                                    //                   products[index]["pkg"].toDouble(),
                                                    //                   double.parse(products[index]["prbaserate"]));

                                                    //               snackbar.showSnackbar(
                                                    //                   context,
                                                    //                   "${products[index]["prcode"] + products[index]['pritem']} - Added to cart",
                                                    //                   "sales");
                                                    //               Provider.of<Controller>(
                                                    //                       context,
                                                    //                       listen:
                                                    //                           false)
                                                    //                   .countFromTable(
                                                    //                 "salesBagTable",
                                                    //                 widget.os,
                                                    //                 widget
                                                    //                     .customerId,
                                                    //               );
                                                    //             }

                                                    //             /////////////////////////
                                                    //             (widget.customerId.isNotEmpty ||
                                                    //                         widget.customerId !=
                                                    //                             null) &&
                                                    //                     (products[index]["prcode"].isNotEmpty ||
                                                    //                         products[index]["prcode"] !=
                                                    //                             null)
                                                    //                 ? Provider.of<Controller>(
                                                    //                         context,
                                                    //                         listen:
                                                    //                             false)
                                                    //                     .calculatesalesTotal(
                                                    //                         widget
                                                    //                             .os,
                                                    //                         widget
                                                    //                             .customerId)
                                                    //                 : Text(
                                                    //                     "No data");
                                                    //           },
                                                    //           color:
                                                    //               Colors.black,
                                                    //         ),
                                                    //         IconButton(
                                                    //             icon:
                                                    //                 const Icon(
                                                    //               Icons.delete,
                                                    //               size: 18,
                                                    //               // color: Colors.redAccent,
                                                    //             ),
                                                    //             onPressed: value.productName[index]
                                                    //                         [
                                                    //                         "cartrowno"] ==
                                                    //                     null
                                                    //                 ? value.selected[
                                                    //                         index]
                                                    //                     ? () async {
                                                    //                         String
                                                    //                             item =
                                                    //                             products[index]["prcode"] + products[index]["pritem"];
                                                    //                         Provider.of<Controller>(context, listen: false).getSaleBagDetails(widget.customerId,
                                                    //                             widget.os);
                                                    //                         showModal.showMoadlBottomsheet(
                                                    //                             widget.os,
                                                    //                             widget.customerId,
                                                    //                             item,
                                                    //                             size,
                                                    //                             context,
                                                    //                             "just added",
                                                    //                             products[index]["prcode"],
                                                    //                             index,
                                                    //                             "no filter",
                                                    //                             "",
                                                    //                             value.qty[index],
                                                    //                             "sales");
                                                    //                       }
                                                    //                     : null
                                                    //                 : () async {
                                                    //                     String
                                                    //                         item =
                                                    //                         products[index]["prcode"] +
                                                    //                             products[index]["pritem"];
                                                    //                     showModal.showMoadlBottomsheet(
                                                    //                         widget.os,
                                                    //                         widget.customerId,
                                                    //                         item,
                                                    //                         size,
                                                    //                         context,
                                                    //                         "already in cart",
                                                    //                         products[index]["prcode"],
                                                    //                         index,
                                                    //                         "no filter",
                                                    //                         "",
                                                    //                         value.qty[index],
                                                    //                         "sales");
                                                    //                   })
                                                    //       ],
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                        ),
            ],
          );
        },
      ),
    );
  }

  // buildPopupDialog(BuildContext context, Size size, int index) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //           return AlertDialog(
  //             content: Consumer<Controller>(builder: (context, value, child) {
  //               if (value.isLoading) {
  //                 return CircularProgressIndicator();
  //               } else {
  //                 return Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Container(
  //                       color: Colors.grey[200],
  //                       height: size.height * 0.04,
  //                       child: DropdownButton<String>(
  //                         value: selected,
  //                         // isDense: true,
  //                         hint: Text("Select package"),
  //                         // isExpanded: true,
  //                         autofocus: false,
  //                         underline: SizedBox(),
  //                         elevation: 0,
  //                         items: value.productUnitList
  //                             .map((item) => DropdownMenuItem<String>(
  //                                 value: value == null
  //                                     ? null
  //                                     : item["unit_name"].toString(),
  //                                 child: Container(
  //                                   width: size.width * 0.5,
  //                                   child: Text(
  //                                     '${item["pid"].toString()}'
  //                                     '-'
  //                                     '${item["unit_name"].toString()}',
  //                                     style: TextStyle(fontSize: 14),
  //                                   ),
  //                                 )))
  //                             .toList(),
  //                         onChanged: (item) {
  //                           print("clicked");

  //                           if (item != null) {
  //                             setState(() {
  //                               selected = item;
  //                             });
  //                             print("se;ected---$item");
  //                             // selected = "";

  //                           }
  //                         },
  //                       ),
  //                     ),
  //                     ElevatedButton(
  //                         onPressed: () async {
  //                           if (selected != null) {
  //                             print("Selected unit.............$selected");

  //                             Provider.of<Controller>(context, listen: false)
  //                                 .selectunit = selected;
  //                             print(
  //                                 "selected uniiiiiiiiii..${Provider.of<Controller>(context, listen: false).selectunit}");

  //                             //       .
  //                             // Provider.of<Controller>(context, listen: false)
  //                             //     .areaId = selected;
  //                             //   Provider.of<Controller>(context, listen: false)
  //                             //       .areaSelection(selected!);
  //                             //   Provider.of<Controller>(context, listen: false)
  //                             //       .dashboardSummery(
  //                             //           sid!, s[0], selected!, context);
  //                             //   String? gen_area = Provider.of<Controller>(
  //                             //           context,
  //                             //           listen: false)
  //                             //       .areaidFrompopup;
  //                             //   if (gen_area != null) {
  //                             //     gen_condition =
  //                             //         " and accountHeadsTable.area_id=$gen_area";
  //                             //   } else {
  //                             //     gen_condition = " ";
  //                             //   }
  //                             //   Provider.of<Controller>(context, listen: false)
  //                             //       .getCustomer(gen_area!);
  //                             //   Provider.of<Controller>(context, listen: false)
  //                             //       .todayOrder(s[0], gen_condition!);
  //                             //   Provider.of<Controller>(context, listen: false)
  //                             //       .todayCollection(s[0], gen_condition!);
  //                             //   Provider.of<Controller>(context, listen: false)
  //                             //       .todaySales(s[0], gen_condition!);
  //                             //   Provider.of<Controller>(context, listen: false)
  //                             //       .selectReportFromOrder(
  //                             //           context, sid!, s[0], "");
  //                           }

  //                           Navigator.pop(context);
  //                         },
  //                         child: Text("save"))
  //                   ],
  //                 );
  //               }
  //             }),
  //           );
  //         });
  //       });
  // }

  //////////////////////////////////////////////////////////////////////////////////
}

_discardAlert(BuildContext context, String customerId) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to Discard ? '),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () async {
              await OrderAppDB.instance.deleteFromTableCommonQuery(
                  "salesBagTable", "customerid='${customerId}'");
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
