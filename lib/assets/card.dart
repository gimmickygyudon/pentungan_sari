import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'object.dart';

class CardEventDay extends StatelessWidget {
  const CardEventDay({
    super.key, 
    required this.event,
    required this.showEventSheet, 
    required this.showDialogImage, 
    required this.duration
  });

  final Function showEventSheet, showDialogImage;
  final Map<String, dynamic> event;
  final double duration;

  @override
  Widget build(BuildContext context) {
    String image = findLocationImage(event);

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Colors.blue.shade100,
        onTap: () {
          Timer(const Duration(milliseconds: 150), () => showEventSheet(context, event, DateTime.now()));
        },
        child: SizedBox(
          height: 70 * duration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, duration > 2 ? 24 : 12),
                  child: Column(
                    crossAxisAlignment: duration > 2 ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              Text(event['name'], 
                                style: GoogleFonts.signikaNegative(
                                  color: Colors.grey.shade700,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                              const SizedBox(height: 2),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Icon(Icons.schedule, color: Colors.grey, size: 18),
                                    ),
                                    const SizedBox(width: 6),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(event['time'],
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(width: 20, indent: 4, endIndent: 4),
                                    Text('${duration.toInt()} Jam',
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 8,
                            children: List.generate(event['addons'].length, (i) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundColor: event['addons_subcolor'][i],
                                child: Icon(event['addons'][i], size: 24, color: event['addons_color'][i])
                              );
                            }),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (duration <= 2) Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.location_on, color: Colors.blue, size: 20),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${event['location']}, Pentungan Sari',
                                style: GoogleFonts.roboto(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (duration > 2) Flexible(
                        child: GestureDetector(
                          onTap: () => showDialogImage(context, image, event['name']),
                          child: Hero(
                            tag: event['name'],
                            child: Container(
                              height: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(image), 
                                  fit: BoxFit.cover,
                                  opacity: 0.75
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Icon(Icons.location_on, color: Colors.blue.shade50, size: 20),
                                          ),
                                          const SizedBox(width: 4),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${event['location']}',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.blue.shade50,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  decoration: TextDecoration.none
                                                )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class CardEventDayNext extends StatelessWidget {
  const CardEventDayNext({
    super.key, 
    required this.event,
    required this.next, 
    required this.changeLocation
  });

  final Map<String, dynamic> event;
  final bool next;
  final Function changeLocation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => changeLocation(event['location']),
        splashColor: Colors.blue.shade50,
        overlayColor: MaterialStatePropertyAll(Colors.blue.shade100),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, next ? 12 : 16, 14),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(event['name'], 
                      style: GoogleFonts.rubik(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500, 
                        letterSpacing: -0.25
                      )
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event['time'],
                              style: GoogleFonts.roboto(
                                color: Colors.grey.shade400,
                                height: 0,
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                              )
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                if (next) const VerticalDivider(width: 24, indent: 4, endIndent: 4),
                if (next) const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.location_on, color: Colors.blue, size: 20),
                ),
                if (next) Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(event['location'],
                    style: GoogleFonts.roboto(
                      color: Colors.blue,
                      height: 0,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
