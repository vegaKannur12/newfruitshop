import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:orderapp/components/commoncolor.dart';
import 'package:orderapp/components/printingSale.dart';
import 'package:orderapp/components/sunmi.dart';
import 'package:orderapp/components/sunmi_screen.dart';
import 'package:orderapp/controller/controller.dart';
import 'package:orderapp/screen/ORDER/DateFinder.dart';
import 'package:orderapp/screen/historydataPopup.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodaySale extends StatefulWidget {
  const TodaySale({Key? key}) : super(key: key);

  @override
  State<TodaySale> createState() => _TodaySaleState();
}

class _TodaySaleState extends State<TodaySale> {
  DateTime dateti = DateTime.now();
  HistoryPopup popup = HistoryPopup();
  String? formattedDate;
  String? todaydate;
  DateFind dateFind = DateFind();

  String? sid;
  String? cid;

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    sid = prefs.getString('sid');
    cid = prefs.getString('cid');
    print("sid ......$sid");
    print("formattedDate...$formattedDate");
  }

/////////////////// bluetooth permission checking////////////////////
  // ///BluetoothConnection connection;
  // late BluetoothConnection connection;

  // connect(String address) async {
  //   try {
  //     connection = await BluetoothConnection.toAddress(address);
  //     print('Connected to the device');

  //     connection.input!.listen((Uint8List data) {
  //       //Data entry point
  //       print(ascii.decode(data));
  //     });
  //   } catch (exception) {
  //     print('Cannot connect, exception occured');
  //   }
  // }

  //     connection.input!.listen((Uint8List data) {
  //       //Data entry point
  //       print(ascii.decode(data));
  //     });
  //   } catch (exception) {
  //     print('Cannot connect, exception occured');
  //   }
  // }

  // checkPerm() async {
  //   print("blutooth connect");
  //   var blue = await Permission.bluetooth.status;
  //   print("gsdfsdf....$blue");
  //   if (blue.isDenied) {
  //     await Permission.bluetooth.request();
  //     print("blutooth connect  onnnn");
  //   }
  //   if (blue.isGranted) {
  //     await Permission.bluetooth.request();
  //     openAppSettings();

  //     //  print("request for permission");
  //   }
  //   if (blue.isLimited) {
  //     await Permission.bluetooth.request();
  //   }
  //   if (await Permission.bluetooth.status.isPermanentlyDenied) {
  //     await Permission.bluetooth.request();

  //     openAppSettings();
  //     print("blutooth connect  off");
  //   }
  // }

  @override
  void initState() {
    print("Hai");
    formattedDate = DateFormat('yyyy-MM-dd').format(dateti);
    todaydate = DateFormat('yyyy-MM-dd').format(dateti);

    sharedPref();
    // TODO: implement initState
    super.initState();
    print(
        "todaySalesList----${Provider.of<Controller>(context, listen: false).todaySalesList}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<Controller>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return SpinKitFadingCircle(
              color: P_Settings.wavecolor,
            );
          } else {
            if (value.todaySalesList.length == 0) {
              return Container(
                height: size.height * 0.7,
                width: double.infinity,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              dateFind.selectDateFind(
                                  context, "from date", "sales");
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: P_Settings.wavecolor,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            value.fromDate == null
                                ? todaydate.toString()
                                : value.fromDate.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        // IconButton(
                        //     onPressed: () {
                        //       dateFind.selectDateFind(context, "to date");
                        //     },
                        //     icon: Icon(Icons.calendar_month)),
                        // Text(dateFind.toDate.toString()),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                    ),
                    Image.asset(
                      'asset/noData1.png',
                      height: size.height * 0.09,
                      fit: BoxFit.cover,
                      color: P_Settings.collection1,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Text(
                      "No Sales!!!",
                      style: TextStyle(
                        fontSize: 18,
                        color: P_Settings.collection1,
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            dateFind.selectDateFind(
                                context, "from date", "sales");
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: P_Settings.wavecolor,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          value.fromDate == null
                              ? todaydate.toString()
                              : value.fromDate.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      // IconButton(
                      //     onPressed: () {
                      //       dateFind.selectDateFind(context, "to date");
                      //     },
                      //     icon: Icon(Icons.calendar_month)),
                      // Text(dateFind.toDate.toString()),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.todaySalesList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<Controller>(context,
                                          listen: false)
                                      .getSaleHistoryData('salesDetailTable',
                                          "sales_id='${value.todaySalesList[index]["sales_id"]}'");
                                  popup.buildPopupDialog(
                                      context,
                                      size,
                                      value.todaySalesList[index]["sale_Num"],
                                      value.todaySalesList[index]["Cus_id"],
                                      "sales");
                                },
                                child: Card(
                                    child: ListTile(
                                  tileColor: Colors.grey[100],
                                  title: Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          // Icon(Icons),
                                          // SizedBox(
                                          //   width: size.width * 0.02,
                                          // ),
                                          Text("Ord No : "),
                                          Text(
                                              value.todaySalesList[index]
                                                  ["sale_Num"],
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17)),
                                          Spacer(),
                                          IconButton(
                                            onPressed: () async {
                                              // checkPerm();
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .printSales(
                                                cid!,
                                                context,
                                                value.todaySalesList[index],
                                              );
                                              Sunmi printer = Sunmi();
                                              printer.printReceipt(
                                                  value.printSalesData);
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         SunmiScreen(),
                                              //   ),
                                              // );
                                            },
                                            icon: Icon(Icons.print),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          RichText(
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            text: TextSpan(
                                              text:
                                                  '${value.todaySalesList[index]["cus_name"]}',
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Text(" - "),
                                          Text(
                                            value.todaySalesList[index]
                                                ["Cus_id"],
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "No: of Items  :",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                              "${value.todaySalesList[index]["count"].toString()}",
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17)),
                                          Spacer(),
                                          Text(
                                            "Total  :",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            "\u{20B9}${value.todaySalesList[index]["net_amt"].toStringAsFixed(2)}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
