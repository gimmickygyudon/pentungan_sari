import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Event extends StatelessWidget {
  const Event({super.key, required this.now});

  final DateTime now;
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final String startWeek = DateFormat('d').format(getDate(now.subtract(Duration(days: now.weekday - 1))));
    final String endWeek = DateFormat('d').format(getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday))));
    
    debugPrint(DateFormat('MMMM').format(DateTime.now()));
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Minggu ini', 
                      style: GoogleFonts.varelaRound(
                        color: Colors.grey.shade700,
                        fontSize: 28,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_downward, size: 28, color: Colors.grey.shade600)
                  ],
                ),
                const Expanded(child: Divider(indent: 18, endIndent: 18, thickness: 2)),
                Text('$startWeek - $endWeek',
                  style: GoogleFonts.varelaRound(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}
