import 'package:flutter/material.dart';

class Note {
  final String title;
  String description;
  String content;
  final Color color;

  Note({
    required this.title,
    required this.description,
    required this.content,
    required this.color,
  });
}
