import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tradexpro_flutter/ui/features/home/system_function_item.dart';

class SystemFunction extends StatelessWidget {
  const SystemFunction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SystemFunctionItem(
                  icon: Icons.arrow_circle_left, title: "Deposit"),
              SystemFunctionItem(
                  icon: Icons.wallet_outlined, title: "Withdraw"),
              SystemFunctionItem(
                  icon: Icons.swap_horizontal_circle, title: "Swap"),
              SystemFunctionItem(icon: Icons.list_alt_sharp, title: "Orders"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ],
      ),
    );
  }
}
