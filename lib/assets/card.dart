import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pentungan_sari/assets/icon.dart';

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
        onTap: () => Timer(const Duration(milliseconds: 50), () => showEventSheet(context, event, DateTime.now())),
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
                          IconAddons(event: event, size: 28, radius: 20)
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (duration <= 2) Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 1),
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
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
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
        onTap: () => Future.delayed(const Duration(milliseconds: 100)).whenComplete(() => changeLocation(event['location'])),
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

class CardEventWeekNormal extends StatelessWidget {
  const CardEventWeekNormal({super.key, required this.title,
    required this.animate, required this.today, required this.open,
    required this.viewAnimate,
    required this.event, 
    required this.colors
  });

  final String title;
  final bool animate, today, open;
  final Function viewAnimate;

  final Map<String, dynamic> event;
  final Map<String, Color> colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: today ? 4 : 2,
      color: open ? null : Colors.white60,
      shadowColor: today ? Colors.black26 : Colors.black12,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            decoration: today ? BoxDecoration(
              color: colors['color']?.withOpacity(0.000005),
              borderRadius: BorderRadius.circular(today ? 12 : 8),
              border: Border.all(width: 0, color: Colors.transparent)
            ) : null,
            child: ListTileTheme(
              tileColor: today ? colors['subcolor'] : null,
              dense: true,
              minVerticalPadding: 14,
              child: ListTile(
                onTap: () => Future.delayed(const Duration(milliseconds: 100)).whenComplete(() => viewAnimate('Hari')),
                splashColor: colors['splashcolor'],
                trailing: open
                  ? TextButton.icon(
                      onPressed: () {},
                      style: ButtonStyle(
                        iconSize: const MaterialStatePropertyAll(18),
                        foregroundColor: MaterialStatePropertyAll(today ? colors['daycolor'] : Colors.green),
                        overlayColor: MaterialStatePropertyAll(Colors.green.shade100)
                      ),
                      label: const Text('Pesan Tempat'),
                      icon: const Icon(Icons.add_home_outlined)
                    )
                  : null,
                contentPadding: EdgeInsets.fromLTRB(today ? 24 : 18, 0, 2, 0),
                isThreeLine: false,
                title: Text(title,
                  style: GoogleFonts.signikaNegative(
                    color: today 
                      ? colors['daycolor']
                      : open 
                        ? Colors.grey
                        : Colors.grey.shade400,
                    letterSpacing: -0.25,
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  )
                ),
                subtitle: null,
              ),
            ),
          ),
          if (today) Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 5, 
                height: double.infinity,
                decoration: BoxDecoration(
                  color: open ? colors['color']?.withOpacity(0.75) : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardEventWeek extends StatelessWidget {
  const CardEventWeek({super.key, 
    required this.animate, required this.today, required this.open, 
    required this.showEventSheet, 
    required this.event, required this.colors
  });

  final bool animate, today, open;
  final Function showEventSheet;

  final Map<String, dynamic> event;
  final Map<String, Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(event['events'].length, (index) { 
        List<dynamic> events = event['events'];
        int duration = countEventDuration(events[index]['start'], events[index]['end']);
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Material(
            elevation: 4,
            color: open ? null : Colors.white60,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                    ),
                  ),
                ),
                Container(
                  decoration: today ? BoxDecoration(
                    color: colors['color']?.withOpacity(0.000005),
                    borderRadius: BorderRadius.circular(today ? 12 : 8),
                    border: Border.all(width: 0, color: Colors.transparent)
                  ) : null,
                  child: ListTileTheme(
                    tileColor: today ? colors['subcolor'] : null,
                    dense: true,
                    minVerticalPadding: 14,
                    child: ListTile(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
                          return showEventSheet(context, events[index], DateTime.now());
                        });
                      },
                      splashColor: colors['splashcolor'],
                      trailing: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: IconAddons(event: events[index]),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(today ? 24 : 20, 0, 18, 0),
                      isThreeLine: true,
                      title: Text(events[index]['name'],
                        style: GoogleFonts.signikaNegative(
                          color: today 
                            ? colors['daycolor']
                            : open 
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                          letterSpacing: -0.25,
                          fontSize: 22,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                      Text(events[index]['time'],
                                        style: GoogleFonts.roboto(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500
                                        )
                                      ),
                                    ],
                                  ),
                                  const VerticalDivider(indent: 2, endIndent: 2),
                                  Text('$duration Jam',
                                    style: GoogleFonts.roboto(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Icon(Icons.location_on, color: Colors.blue, size: 20),
                                ),
                                const SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${events[index]['location']}',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (today) Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 5, 
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: open ? colors['color']?.withOpacity(0.75) : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
