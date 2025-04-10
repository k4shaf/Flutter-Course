import 'dart:convert';

import 'package:coin_cap/pages/DetailsPage.dart';
import 'package:coin_cap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? deviceWidth, deviceHeight;
  HttpService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HttpService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // Takes height of parent else children
          mainAxisSize: MainAxisSize.max,
          children: [
            _selectedCoinDropdown(),
            _dataWidgets(),
          ],
        ),
      )),
    );
  }

  Widget _selectedCoinDropdown() {
    _http.get("/")
    List<String> coins = ["bitcoin"];
    // The value will be of type String
    List<DropdownMenuItem<String>> items = coins
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ))
        .toList();

    return DropdownButton(
      value: coins.first,
      items: items,
      onChanged: (value) {},
      // Inner list color:
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get("/coins/bitcoin"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(snapshot.data.toString());

          // "market_data": {
          //     "current_price": {
          //       "aed": 256486,
          // num so app won't crash if number is int/double
          num pkrPrice = data["market_data"]["current_price"]["pkr"];
          num change24h = data["market_data"]["price_change_percentage_24h"];
          String imgURL = data["image"]["large"];
          String desc = data["description"]["en"];

          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailsPage()));
                },
                child: _coinImageWidget(imgURL),
              ),
              _currentPriceWidget(pkrPrice),
              _percentageChangeWidget(change24h),
              _descriptionCardWidget(desc),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} PKR",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 30,
      ),
    );
  }

  Widget _percentageChangeWidget(num change) {
    return Text(
      "${change.toString()} %",
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _coinImageWidget(String imgURL) {
    return Container(
      height: deviceHeight! * 0.15,
      width: deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgURL),
        ),
      ),
    );
  }

  Widget _descriptionCardWidget(String desc) {
    return Container(
      height: deviceHeight! * 0.45,
      width: deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight! * 0.1,
        horizontal: deviceHeight! * 0.1,
      ),
      color: Color.fromRGBO(83, 88, 206, 1),
      child: Text(
        desc,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
