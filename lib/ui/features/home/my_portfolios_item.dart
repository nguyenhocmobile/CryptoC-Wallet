import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tradexpro_flutter/data/models/coin.dart';

class MyPortfolioItem extends StatelessWidget {
  final Coin coin;
  const MyPortfolioItem({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.network(
          coin.thumbnail.toString(),
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        coin.symbol!.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(33, 33, 33, 1),
        ),
      ),
      subtitle: Text(
        coin.name!,
        style: TextStyle(
          color: Color.fromRGBO(117, 117, 117, 1),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Column(
        children: [
          Text(
            '\$${coin.currentPrice!.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color.fromRGBO(33, 33, 33, 1),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            coin.priceChangePercentage24h! > 0
                ? '+${coin.priceChangePercentage24h!.toStringAsFixed(2)}%'
                : '${coin.priceChangePercentage24h!.toStringAsFixed(2)}%',
            style: TextStyle(
              color: coin.priceChangePercentage24h! > 0
                  ? Color.fromRGBO(4, 156, 107, 1)
                  : Color.fromRGBO(223, 21, 37, 1),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }
}
