import 'package:flutter/material.dart';

class Note {
  String text;
  Color color;
  String? pin; // PIN property
  bool locked;

  Note({
    required this.text,
    required this.color,
    this.pin,
    this.locked = false,
  });
}
