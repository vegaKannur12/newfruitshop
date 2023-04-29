import 'package:flutter/material.dart';
import 'package:orderapp/components/commoncolor.dart';

class CustomSnackbar {
  showSnackbar(BuildContext context, String content,String type) {
    ScaffoldMessenger. of(context).showSnackBar(
      SnackBar(
        backgroundColor:type=="sale order"? P_Settings.wavecolor:type=="sales"?P_Settings.salewaveColor:P_Settings.extracolor,
        duration: const Duration(seconds: 1),
        content: Text("${content}"),
        action: SnackBarAction(
          label: '',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
