import 'package:flutter/material.dart';
import 'package:orderapp/components/commoncolor.dart';
import 'package:orderapp/components/customSnackbar.dart';
import 'package:orderapp/controller/controller.dart';
import 'package:orderapp/db_helper.dart';
import 'package:orderapp/screen/ADMIN_/adminController.dart';
import 'package:orderapp/screen/ORDER/3_staffLoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyDetails extends StatefulWidget {
  String? type;
  String? msg;

  CompanyDetails({this.type, this.msg});
  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  String? cid;
  String? firstMenu;
  String? versof;
  String? data;
  String? fingerprint;

  CustomSnackbar _snackbar = CustomSnackbar();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCid();
  }

  getCid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cid = prefs.getString("cid");
    versof = prefs.getString("versof");

    fingerprint = prefs.getString("fp");
    print("fingerprint-----$fingerprint");
    if (cid != null) {
      Provider.of<AdminController>(context, listen: false)
          .getCategoryReport(cid!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: P_Settings.detailscolor,
      appBar: widget.type == ""
          ? AppBar(
              backgroundColor: P_Settings.wavecolor,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(6.0),
                child: Center(
                    child: Text(
                  " ",
                  style: TextStyle(color: Colors.white, fontSize: 19),
                )),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Company Details",
                  style: TextStyle(
                      fontSize: 20,
                      color: P_Settings.headingColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<Controller>(
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return Container(
                        height: size.height * 0.9,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (value.companyList.length > 0) {
                        return FittedBox(
                          child: Container(
                            height: size.height * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.04,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.business),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("company name "),
                                    ),
                                    Text(
                                        ": ${(value.companyList[0]["cnme"] == null) && (value.companyList[0]["cnme"].isEmpty) ? "" : value.companyList[0]["cnme"]}"),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.business),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("company id"),
                                    ),
                                    Text(
                                        ": ${(value.companyList[0]["cid"] == null) && (value.companyList[0]["cid"].isEmpty) ? "" : value.companyList[0]["cid"]}"),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.numbers_rounded),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("Order Series"),
                                    ),
                                    Text(
                                        ": ${(value.companyList[0]["os"] == null) && (value.companyList[0]["os"].isEmpty) ? "" : value.companyList[0]["os"]}"),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.fingerprint),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("fingerprint"),
                                    ),
                                    Text(
                                        ": ${(value.companyList[0]["fp"] == null) && (value.companyList[0]["fp"].isEmpty) ? "" : value.companyList[0]["fp"]}"),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.book),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("Address1"),
                                    ),
                                    Text(
                                      ": ${value.companyList[0]['ad1']}",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.book),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("Address2"),
                                    ),
                                    Text(
                                      ": ${value.companyList[0]['ad2']}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.pin),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("PinCode"),
                                    ),
                                    Text(
                                      ": ",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.business),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("CompanyPrefix"),
                                    ),
                                    Text(
                                      ": ${value.companyList[0]["cpre"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.landscape),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("Land"),
                                    ),
                                    Text(
                                      ": ${value.companyList[0]["land"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("Mobile"),
                                    ),
                                    Text(
                                      ": ${value.companyList[0]["mob"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.design_services),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("GST"),
                                    ),
                                    Text(
                                      ": ${value.companyList[0]["gst"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.copy_rounded),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.3,
                                      child: Text("Country Code     "),
                                    ),
                                    Text(
                                      ": ${value.companyList[0]["ccode"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.04,
                                ),
                                widget.type == "drawer call"
                                    ? Container()
                                    : Text(
                                        widget.msg != ""
                                            ? widget.msg.toString()
                                            : "Company Registration Successfull",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 17),
                                      ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                widget.type == "drawer call" || widget.msg != ""
                                    ? Container()
                                    : ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setBool(
                                              "continueClicked", true);
                                          String? userType =
                                              prefs.getString("userType");
                                          print(
                                              "compny deatils userType----$userType");

                                          firstMenu =
                                              prefs.getString("firstMenu");
                                          print("first---------$firstMenu");

                                          if (firstMenu != null) {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .menu_index = firstMenu;

                                            print(Provider.of<Controller>(
                                                    context,
                                                    listen: false)
                                                .menu_index);
                                          }

                                          String? cid = prefs.getString("cid");

                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .getAreaDetails(cid!, 0,"company details");


                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .cid = cid;

                                          print("cid-----${cid}");
                                          if (userType == "staff") {
                                            print("stffjknkdf");

                                            await OrderAppDB.instance
                                                .deleteFromTableCommonQuery(
                                                    "staffDetailsTable", "");

                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getStaffDetails(cid, 0,"company details");
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getSettings(context, cid,"company details");

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffLogin()),
                                            );
                                          } else if (userType == "admin") {
                                            print("adminjknkdf");
                                            await OrderAppDB.instance
                                                .deleteFromTableCommonQuery(
                                                    "userTable", "");
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getUserType();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffLogin()),
                                            );
                                          }
                                        },
                                        child: Text("Continue"),
                                      ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: Column(children: [Text("")]),
                        );
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
