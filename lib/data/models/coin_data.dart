import 'dart:convert';

import 'package:flutter/material.dart';
import './coin.dart';
import 'package:http/http.dart' as http;

class Coins with ChangeNotifier {
  List<Coin> _coins = [];

  List<Coin> get coins {
    return _coins;
  }

  Coin findById(String id) {
    return _coins.where((element) => element.id == id).first;
  }

  Future<void> fetchAndSetCoins() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&ids=bitcoin,ethereum,aave-amm-usdt,avalanche-2,solana,tether,binancecoin,gmx,1inch,liquity&order=market_cap_desc&per_page=10&page=1&sparkline=false&price_change_percentage=1h,24h,7d,14d,30d,200d,1y'));
      final List value = json.decode(response.body);
      print(value);
      if (value == null) {
        return;
      }
      final List<Coin> loadedCoin = [];
      value.forEach((element) {
        Map<String, dynamic> coin = element;
        loadedCoin.add(Coin.fromJson(coin));
      });
      _coins = loadedCoin;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
