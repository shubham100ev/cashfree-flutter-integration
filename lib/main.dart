import 'dart:convert';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashfreeFlutterIntegrtion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cashfree Flutter Intigration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _amount = 100; //This is the amount you want to pay
  String _orderID="Order001";//orderId will be different for every transaction but should se same for both to generate token an used for gateway
  String cfToken; //to store the cfToken generated in backend
  String _phone; // valid phone of the user
  String _email; // valid email of user

  void _submit(int amount) {
    addPayment();



    //Request body of Cashfree SDK
    Map<String, String> input = {
      "appId":constants.APP_ID,
      "tokenData": cfToken,
      "orderId":_orderID,
      "orderAmount": _amount.toString(),
      "orderCurrency": "INR",
      "customerPhone": _phone,
      "customerEmail": _email
    };

    //Starts the cashfree wevview
    CashfreePGSDK()
        .doPaymentWithTheme(context, input, Theme.of(context).primaryColor,
        Colors.white, "TEST")
        .then((val) {
      if (val != null) {
        print("SDK Result : ${(val)}");
        //get the response of the payment val contain the response of the payment gateway
      }
    });
  }

  //Function to get the cfToken which you have generated at backend
  Future<void> addPayment() async {
    final url = Uri.http(constants.BASE_URL, constants.ADD_PAYMENT);
    Map<String, dynamic> body = {"amount": _amount,"orderId":_orderID};
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body)
    );
    final responseData = json.decode(response.body);
    cfToken=responseData["response"]["cfToken"];//depend on the schema of the backend value of your cfToken generated in backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            _submit(_amount);
          },
          //create whole payment screen as per the requirement
          child: Text("Add Cash"),
        ),
      ),
    );
  }
}
