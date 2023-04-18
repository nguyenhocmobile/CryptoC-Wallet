import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/paypal_util/paypal_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function? onFinish;
  final double totalAmount;

  const PaypalPayment({super.key, this.onFinish, required this.totalAmount});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {"symbol": "USD ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "USD"};
  bool isEnableShipping = false;
  bool isEnableAddress = false;
  String returnURL = '';
  String cancelURL = '';

  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {
    services.initClass();
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    Future.delayed(Duration.zero, () async {
      try {
        var appId = await getAppId();
        appId = appId.replaceAll("_", ".");
        returnURL = "return.$appId";
        cancelURL = "cancel.$appId";
        accessToken = await services.getAccessToken();
        final transactions = getOrderParams();
        final res = await services.createPaypalPayment(transactions, accessToken);
        if (res != null && mounted) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        showToast(e.toString());
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.totalAmount,
            "currency": defaultCurrency["currency"],
          },
        }
      ],
      "note_to_payer": "Contact us for any questions on your payment".tr,
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(child: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor), onTap: () => Navigator.pop(context)),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            printFunction("request.url", request.url);
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services.executePayment(executeUrl, payerID, accessToken).then((id) {
                  if (widget.onFinish != null) widget.onFinish!(accessToken);
                  Navigator.of(context).pop();
                  return NavigationDecision.prevent;
                });
              }
            }
            else if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            // else if(request.url.contains("error.css")) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor), onPressed: () => Navigator.of(context).pop()),
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0.0),
        body: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)),
      );
    }
  }
}

// Map<String, dynamic> getOrderParams() {
//   //List items = [{"name": itemName, "quantity": quantity, "price": itemPrice, "currency": defaultCurrency["currency"]}];
//
//   Map<String, dynamic> temp = {
//     "intent": "sale",
//     "payer": {"payment_method": "paypal"},
//     "transactions": [
//       {
//         "amount": {
//           "total": widget.totalAmount,
//           "currency": defaultCurrency["currency"],
//           //"details": {"subtotal": subTotalAmount, "shipping": shippingCost, "shipping_discount": ((-1.0) * shippingDiscountCost).toString()}
//         },
//         // "description": "The payment transaction description.",
//         // "payment_options": {"allowed_payment_method": "INSTANT_FUNDING_SOURCE"},
//         // "item_list": {
//         //   "items": items,
//         //   if (isEnableShipping && isEnableAddress)
//         //     "shipping_address": {
//         //       "recipient_name": userFirstName + " " + userLastName,
//         //       "line1": addressStreet,
//         //       "line2": "",
//         //       "city": addressCity,
//         //       "country_code": addressCountry,
//         //       "postal_code": addressZipCode,
//         //       "phone": addressPhoneNumber,
//         //       "state": addressState
//         //     },
//         // }
//       }
//     ],
//     "note_to_payer": "Contact us for any questions on your payment".tr,
//     "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
//   };
//   return temp;
// }