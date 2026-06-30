import 'package:flutter/material.dart';

class LearnSection {
  final String title;
  final IconData icon;
  final String summary;
  final List<String> highlights;
  final String? linkRoute;
  final String? linkLabel;

  const LearnSection({
    required this.title,
    required this.icon,
    required this.summary,
    required this.highlights,
    this.linkRoute,
    this.linkLabel,
  });
}
