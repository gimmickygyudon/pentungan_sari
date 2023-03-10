import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'object.dart';

class IconAddons extends StatelessWidget {
  const IconAddons({
    super.key, required this.event, 
    this.spacing = 8, this.radius = 16, this.size = 20
  });

  final Map<String, dynamic> event;
  final double spacing, radius, size;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      children: List.generate(event['addons'].length, (i) {
        Map<String, dynamic> addon = getAddonsElement(event['addons'][i]['name']);
        return Tooltip(
          message: addon['name'],
          triggerMode: TooltipTriggerMode.tap,
          preferBelow: false,
          textStyle: GoogleFonts.rubik(
            fontSize: radius,
            color: addon['color']
          ),
          decoration: BoxDecoration(
            color: addon['subcolor'],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: addon['color'])
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: addon['subcolor'],
            child: Icon(addon['withicon'], size: size, color: addon['color'])
          ),
        );
      }),
    );
  }
}
