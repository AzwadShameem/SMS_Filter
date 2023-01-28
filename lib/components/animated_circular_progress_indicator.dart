import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../provider/statusProvider.dart';

class AnimatedCircularProgressInicator extends StatelessWidget {
  final double ratio;
  const AnimatedCircularProgressInicator(
      {Key? key, required this.ratio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: true);
    return SizedBox(
      height: 120,
      width: 120,
      child: AspectRatio(
        aspectRatio: 1,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          builder: (context, double value, child) => Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                //value: value * (statusProvider.blackList / statusProvider.totalList),
                value: value * ratio,
                color: kSecondaryColor,
                strokeWidth: 10,
                backgroundColor: kPrimaryColor,
              ),
              Center( child: Text("${(value * ratio * 100).toStringAsFixed(1)}%", style: ksmallHeading))
            ],
          ),
        ),
      ),
    );
  }
}
