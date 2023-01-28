import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spam_filter/components/spamfilter_logo.dart';
import 'package:spam_filter/constants.dart';

import '../provider/searchProvider.dart';

class FlashingScreen extends StatelessWidget {
  const FlashingScreen({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    
    return SafeArea(
        child: Shimmer.fromColors(
            baseColor: kSecondaryColor,
            highlightColor: kPrimaryColor,
            child: const Center(child: SpamFilterLogo())));
  }
}
