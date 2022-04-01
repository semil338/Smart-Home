import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Widget onTap;

  const MenuItem(this.title, this.icon, this.onTap);
}
