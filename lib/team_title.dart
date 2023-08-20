import 'package:flutter/material.dart';

class FakeFootballTitle extends StatelessWidget {
  String title;
  Color color;
  double? width;

  FakeFootballTitle({super.key, required this.title, required this.color, this.width});

  @override
  Widget build(BuildContext context) {
    width = width ?? MediaQuery.of(context).size.width / 3;
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              width: width! / 2,
              height: 5,
              color: color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                  ),
            ),
          ),
          Flexible(
            child: Container(
              width: width! / 2,
              height: 5,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
