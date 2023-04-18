import 'package:flutter/material.dart';

class SystemFunctionItem extends StatelessWidget {
  final String? title;
  final IconData icon;
  const SystemFunctionItem({super.key, this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {print("hello")},
      child: Container(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                color: Color.fromRGBO(223, 241, 255, 1),
              ),
              child: Transform.rotate(
                  angle: title == "Deposit" ? -1.6 : 0,
                  child: Icon(icon, size: 30)),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
