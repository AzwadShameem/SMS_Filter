import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/black_white_list_screen.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: GNav(
            rippleColor: Colors.teal[300]!,
            hoverColor: Colors.teal[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.teal[100]!,
            color: Colors.teal,
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              const GButton(
                icon: FeatherIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: FeatherIcons.crosshair,
                text: 'Safe',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BlackWhiteListScreen()),
                  );
                },
              ),
              const GButton(
                icon: FeatherIcons.search,
                text: 'Search',
              ),
              const GButton(
                icon: FeatherIcons.settings,
                text: 'setting',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
