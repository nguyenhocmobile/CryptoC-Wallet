import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Coin with ChangeNotifier {
  final String? id;
  final String? symbol;
  final String? name;
  final num? currentPrice;
  String? thumbnail;
  final double? priceChangePercentage24h;
  final double? percentChange_1h;
  final double? percentChange_24h;
  final double? percentChange_7d;
  final double? percentChange_14d;
  final double? percentChange_30d;
  final double? percentChange_200d;
  final double? percentChange_1y;

  Coin({
    this.percentChange_1h,
    this.percentChange_24h,
    this.percentChange_7d,
    this.percentChange_30d,
    this.percentChange_200d,
    this.percentChange_1y,
    this.percentChange_14d,
    this.currentPrice,
    this.id,
    this.name,
    this.symbol,
    this.thumbnail,
    this.priceChangePercentage24h,
  });
  Map<String, String> coins = {};
  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      thumbnail: json['image'],
      priceChangePercentage24h: json['price_change_percentage_24h'],
      percentChange_1h: json['price_change_percentage_1h_in_currency'],
      percentChange_7d: json['price_change_percentage_7d_in_currency'],
      percentChange_24h: json['price_change_percentage_24h_in_currency'],
      percentChange_30d: json['price_change_percentage_30d_in_currency'],
      percentChange_200d: json['price_change_percentage_200d_in_currency'],
      percentChange_1y: json['price_change_percentage_1y_in_currency'],
      percentChange_14d: json['price_change_percentage_14d_in_currency'],
      currentPrice: json['current_price'],
    );
  }

  double? get totalPercent {
    double? result = 0;
    List<double?> numberPercent = [
      percentChange_1y,
      percentChange_14d,
      percentChange_1h,
      percentChange_200d,
      percentChange_24h,
      percentChange_30d,
      percentChange_7d
    ];
    double? max = numberPercent.reduce((a, b) => a! > b! ? a : b)!.abs();
    double? min = numberPercent.reduce((a, b) => a! < b! ? a : b)!.abs();
    result = max + min;
    print(result);
    return result;
  }

  double? get percentMax {
    List<double?> numberPercent = [
      percentChange_1y,
      percentChange_14d,
      percentChange_1h,
      percentChange_200d,
      percentChange_24h,
      percentChange_30d,
      percentChange_7d
    ];
    double? max = numberPercent.reduce((a, b) => a! > (b ?? 0) ? a : b)!.abs();
    return max;
  }

  double? get percentMin {
    List<double?> numberPercent = [
      percentChange_1y,
      percentChange_14d,
      percentChange_1h,
      percentChange_200d,
      percentChange_24h,
      percentChange_30d,
      percentChange_7d
    ];
    double? min = numberPercent.reduce((a, b) => a! < (b ?? 0) ? a : b)!;
    return min;
  }

  Future<void> fetchCoin(String id) async {
    var response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&ids=bitcoin,ethereum,aave-amm-usdt,avalanche-2,solana,tether,binancecoin,gmx,1inch,liquity&order=market_cap_desc&per_page=10&page=1&sparkline=false&price_change_percentage=1h,24h,7d,14d,30d,200d,1y'));
    List value = json.decode(response.body);
    value.forEach((element) {
      if (!coins.containsKey(element['id'])) {
        coins.putIfAbsent(element['id'], () => element['image']);
      }
    });
    notifyListeners();
  }
}
