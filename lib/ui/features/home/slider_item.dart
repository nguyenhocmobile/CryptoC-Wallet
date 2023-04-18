import 'package:flutter/material.dart';

class SliderItem extends StatelessWidget {
  const SliderItem({super.key});

  @override
  Widget build(BuildContext context) {
    final double widthSliderItem = MediaQuery.of(context).size.width - 100;
    const double heightSliderItem = 140;
    return Container(
      width: widthSliderItem,
      height: heightSliderItem,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
