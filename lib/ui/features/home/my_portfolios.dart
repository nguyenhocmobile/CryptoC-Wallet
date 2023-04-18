import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradexpro_flutter/data/models/coin.dart';
import 'package:tradexpro_flutter/ui/features/home/my_portfolios_item.dart';

import '../../../data/models/coin_data.dart';

class MyPortfolios extends StatelessWidget {
  final bool isLoading;
  final List<Coin> coinData;
  const MyPortfolios(
      {super.key, required this.isLoading, required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "My Portfolios",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Text(
                "Sell all",
                style: TextStyle(
                  color: Color.fromRGBO(21, 115, 254, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: MediaQuery.of(context).size.height - 450,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: ((context, index) => MyPortfolioItem(
                          coin: coinData[index],
                        )),
                    itemCount: coinData.length),
          ),
        ],
      ),
    );
  }
}
