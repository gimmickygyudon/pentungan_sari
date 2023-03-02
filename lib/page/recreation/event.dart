import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Event extends StatefulWidget {
  const Event({
    super.key, required this.now
  });

  final DateTime now;

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  final LinearGradient govGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: const Alignment(-0.8, -0.4),
    stops: const [0.0, 0.5, 0.5, 1],
    colors: [
        Colors.green.shade50,
        Colors.green.shade50,
        Colors.green.shade100,
        Colors.green.shade100,
    ],
    tileMode: TileMode.repeated,
  );

  late List<Map<String, dynamic>> events, dummyevents;
  late DateTime startOfWeek, endOfWeek;

  String view = 'Minggu';
  late bool animate;

  @override
  void initState() {
    dummyevents = [
      {
        'date': (widget.now.day + 1).toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.day)),
        'name': 'Rapat Posyandu',
        'time': '07.30 - 11.30',
        'addons': [ Icons.speaker, Icons.foundation ],
        'addons_color': [ Colors.orange.shade600, Colors.blue.shade600 ],
        'addons_subcolor': [ Colors.orange.shade50, Colors.blue.shade50 ]
      }
    ];

    startOfWeek = getDate(widget.now.subtract(Duration(days: widget.now.weekday - 1)));
    endOfWeek = getDate(widget.now.add(Duration(days: DateTime.daysPerWeek - widget.now.weekday)));

    final daysInLastMonth = DateUtils.getDaysInMonth(widget.now.year, widget.now.month - 1);
    final daysInMonth = DateUtils.getDaysInMonth(widget.now.year, widget.now.month);
    int date = startOfWeek.day;

    events = List.generate(7, (index) {
      int days;
      date > widget.now.day ? days = daysInLastMonth : days = daysInMonth;
      
      if (date > days) date = 1;
      final list = { 
        'date': date.toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.year, widget.now.month, date)),
        'name': 'Hari Biasa',
        'time': null,
        'addons': null
      };

      date++;
      return list;
    });

    int i = 0;
    for (var element in events) {
      if (element['date'] == dummyevents[0]['date']) {
        events.replaceRange(i, i + 1, dummyevents);
      }
      i++;
    }

    animate = false;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => animate = true));
  }

  @override
  void dispose() {
    animate = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade200,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedSlide(
              offset: Offset(0, animate ? 0 : -2),
              curve: Curves.easeOutCubic,
              duration: const Duration(milliseconds: 400),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black38,
                surfaceTintColor: Colors.transparent,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          DropdownButton(
                            value: view,
                            onChanged: (value) {
                              setState(() {
                                view = value as String;
                              });
                            },
                            underline: const SizedBox(),
                            isDense: true,
                            style: GoogleFonts.varelaRound(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w600
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                            ),
                            iconSize: 32,
                            borderRadius: BorderRadius.circular(12),
                            items: [
                              DropdownMenuItem(
                                value: 'Hari',
                                child: Row(
                                  children: [
                                    Icon(Icons.browse_gallery_outlined, size: 22, color: Colors.grey.shade700),
                                    const SizedBox(width: 12),
                                    const Text('Hari'),
                                  ],
                                )
                              ),
                              DropdownMenuItem(
                                value: 'Minggu',
                                child: Row(
                                  children: [
                                    Icon(Icons.filter_list, size: 22, color: Colors.grey.shade700),
                                    const SizedBox(width: 12),
                                    const Text('Minggu'),
                                  ],
                                )
                              ),
                              DropdownMenuItem(
                                value: 'Bulan',
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_view_month, size: 22, color: Colors.grey.shade700),
                                    const SizedBox(width: 12),
                                    const Text('Bulan'),
                                  ],
                                )
                              )
                            ]
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          PopupMenuButton(
                            itemBuilder: (context) => const [],
                            child: Icon(Icons.more_vert, color: Colors.grey.shade700)
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Flexible(
              child: AnimatedSwitcher(
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                duration: const Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child)
                  );
                },
                child: (() {
                  switch (view) {
                    case 'Hari':
                    return EventThisDay(
                      events: events
                    );
                    case 'Minggu':
                    return EventThisWeek(
                      events: events, 
                      dummyevents: dummyevents, 
                      now: widget.now, 
                      animate: animate
                    );
                    default:
                    return EventThisWeek(
                      events: events, 
                      dummyevents: dummyevents, 
                      now: widget.now, 
                      animate: animate
                    );
                  }
                }()) 
              )
            ),
          ]
        ),
      ),
    );
  }
}

class EventThisDay extends StatelessWidget {
  const EventThisDay({super.key, required this.events});

  final List<Map<String, dynamic>> events;

  @override
  Widget build(BuildContext context) {
    String minute = DateFormat("mm").format(DateTime.now());
    String hour = DateFormat("HH").format(DateTime.now());
    return ListView.builder(
      itemCount: 25,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 28, right: 28),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            if (index + 1 <= 7 || index + 1 >= 12) Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('${(index + 1).toString().length == 1 ? '0${index + 1}' : index + 1}:00', 
                        style: GoogleFonts.rubik(
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Divider(color: Colors.grey.shade300)
                    )
                  ],
                ),
                const SizedBox(height: 38)
              ] + List.generate(index + 1 == 7 ? 4 : 0, (i) {
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if ((index + i + 2 >= 7) || (index + i + 2 <= 12)) ...[
                          if (minute != '00' && hour == '${((index + i + 2).toString().length == 1 ? '0' : '')}${index + i + 2}') ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          border: const Border(left: BorderSide(color: Colors.green, width: 2))
                                        ),
                                        child: Transform.scale(
                                          scale: 0.75,
                                          child: Text('$hour:$minute',
                                            style: GoogleFonts.rubik(
                                              color: Colors.green,
                                              letterSpacing: 0.5,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(flex: 5, child: SizedBox())
                              ],
                            )
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text('${(index + i + 2).toString().length == 1 ? '0${index + i + 2}' : index + i + 2}:00', 
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  flex: 5,
                                  child: Divider()
                                )
                              ],
                            ), 
                          ],
                        ],
                        const SizedBox(height: 38)
                      ]
                    ),
                  ],
                );
              }),
            ),
            if ((index + 1 <= 7) || (index + 1 >= 12)) ...[
              if (minute != '00' && hour == '${((index + 1).toString().length == 1 ? '0' : '')} ${index + 1}') ...[
                Transform.scale(
                  scale: 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      margin: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: const Border(left: BorderSide(color: Colors.green, width: 2))
                      ),
                      child: Transform.scale(
                        scale: 0.75,
                        child: Text('$hour:$minute',
                          style: GoogleFonts.rubik(
                            color: Colors.green,
                            letterSpacing: 0.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
            if (index + 1 == 7) ...[ 
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 30, 0 ,0),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  surfaceTintColor: Colors.transparent,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: SizedBox(
                    height: 94 * 3,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Rapat Posyandu', 
                            style: GoogleFonts.signikaNegative(
                              color: Colors.grey.shade800,
                              fontSize: 22,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          const SizedBox(height: 4),
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
                                    Text('07.30 - 11.30',
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                  ],
                                ),
                                const VerticalDivider(width: 20, indent: 4, endIndent: 4),
                                Text('4 Jam',
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                              ],
                            ),
                          )
                        ]
                      ),
                    ),
                  )
                ),
              ) 
            ]
          ],
        );
      }
    );
  }
}

class EventThisWeek extends StatelessWidget {
  const EventThisWeek({
    super.key, 
    required this.events, 
    required this.dummyevents, 
    required this.now, 
    required this.animate
  });

  final List<Map<String, dynamic>> events, dummyevents;
  final DateTime now;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    bool open = false;
    int duration = 400;
    return ListView.builder(
      itemCount: 7,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 18, right: 28),
      itemBuilder: (context, index) {
        bool today, noevent;
        Color color, subcolor, splashcolor, daycolor, datecolor;

        if (events[index]['name'] == 'Hari Biasa') {
          color = Colors.green;
          subcolor = Colors.green.shade50;
          splashcolor = Colors.green.shade100;
          daycolor = Colors.green.shade400;
          datecolor = Colors.green.shade600;
        } else {
          color = Colors.blue;
          subcolor = Colors.blue.shade50;
          splashcolor = Colors.blue.shade100;
          daycolor = Colors.blue.shade400;
          datecolor = Colors.blue.shade600;
        }

        if (events[index]['date'] == now.day.toString()) { 
          today = true; open = true; 
        } else { 
          today = false; 
        }
        events[index]['name'] == 'Hari Biasa' ? noevent = true : noevent = false;

        duration += 100;
        return AnimatedSlide(
          offset: Offset(0, animate ? 0 : 2),
          curve: Curves.easeOutCubic,
          duration: Duration(milliseconds: duration),
          child: AnimatedOpacity(
            opacity: animate ? 1 : 0,
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: duration + 50),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(today ? events[index]['day'].toUpperCase() : events[index]['day'],
                            style: today 
                            ? GoogleFonts.rubik(
                              color: daycolor,
                              letterSpacing: 0.25,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                            )
                            : GoogleFonts.rubik(
                              color: open ? Colors.grey : Colors.grey.shade400,
                              letterSpacing: -0.25,
                              fontSize: 18,
                              fontWeight: FontWeight.w400
                            )
                          ),
                          Text(events[index]['date'].length == 1 ? '0${events[index]['date']}' : events[index]['date'],
                            style: GoogleFonts.rubik(
                              color: today 
                                ? datecolor 
                                : open ? Colors.grey.shade600 : Colors.grey,
                              fontSize: 24,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          if (today) Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Chip(
                              backgroundColor: daycolor,
                              elevation: 4,
                              shadowColor: Colors.black38,
                              label: const Text('Hari Ini'),
                              labelStyle: GoogleFonts.varelaRound(fontWeight: FontWeight.w600, color: subcolor),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                              side: BorderSide.none,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: Material(
                        elevation: noevent ? 2 : 4,
                        shadowColor: noevent && !today ? Colors.black12 : Colors.black26,
                        borderRadius: BorderRadius.circular(today ? 12 : 8),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              decoration: today ? BoxDecoration(
                                color: color.withOpacity(0.025),
                                borderRadius: BorderRadius.circular(today ? 12 : 8),
                                border: Border.all(width: 0, color: Colors.transparent)
                              ) : open ? null : BoxDecoration(color: Colors.grey.shade100),
                              child: ListTileTheme(
                                tileColor: today ? subcolor : null,
                                dense: true,
                                minVerticalPadding: 14,
                                child: ListTile(
                                  onTap: () {
                                    if (events[index]['time'] != null) {
                                      Future.delayed(const Duration(milliseconds: 150)).whenComplete(() {
                                        return showModalBottomSheet<void>(
                                          barrierColor: Colors.black26,
                                          context: context,
                                          clipBehavior: Clip.antiAlias,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return EventSheet(
                                              title: events[index]['name'],
                                              subtitle: events[index]['time'],
                                              time: (now.day + 1).toString(),
                                              place: 'Pendopo',
                                              speaker: true,
                                            );
                                          },
                                        );
                                      });
                                    }
                                  },
                                  splashColor: splashcolor,
                                  trailing: events[index]['addons'] != null 
                                  ? Wrap(
                                    spacing: 8,
                                    children: List.generate(events[index]['addons'].length, (i) {
                                      return CircleAvatar(
                                        radius: 16,
                                        backgroundColor: events[index]['addons_subcolor'][i],
                                        child: Icon(events[index]['addons'][i], size: 20, color: events[index]['addons_color'][i])
                                      );
                                    }),
                                  ) : open
                                    ? TextButton.icon(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          iconSize: const MaterialStatePropertyAll(18),
                                          foregroundColor: MaterialStatePropertyAll(today ? daycolor : Colors.green),
                                          overlayColor: MaterialStatePropertyAll(Colors.green.shade100)
                                        ),
                                        label: const Text('Pesan Tempat'),
                                        icon: const Icon(Icons.add_home_outlined)
                                      )
                                    : null,
                                  contentPadding: EdgeInsets.fromLTRB(today ? 24 : noevent ? 18 : 20, 0, noevent ? 2 : 18, 0),
                                  isThreeLine: events[index]['time'] != null ? true : false,
                                  title: Text(events[index]['name'],
                                    style: GoogleFonts.signikaNegative(
                                      color: today 
                                        ? daycolor
                                        : open 
                                          ? noevent
                                            ? Colors.grey
                                            : Colors.grey.shade700
                                          : Colors.grey.shade400,
                                      letterSpacing: -0.25,
                                      fontSize: noevent ? 20 : 22,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                  subtitle: events[index]['time'] != null ? Padding(
                                    padding: const EdgeInsets.only(bottom: 4, top: 4),
                                    child: IntrinsicHeight(
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
                                          Text('4 Jam',
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ) : null,
                                ),
                              ),
                            ),
                            if (today) ...[ 
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 4, 
                                height: events[index]['time'] != null ? 55 : 25,
                                decoration: BoxDecoration(
                                  color: open ? color.withOpacity(0.75) : Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(12)
                                ),
                              ),
                            ]
                          ],
                        ),
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 42),
              ],
            ),
          ),
        );
      }
    );
  }
}

class EventSheet extends StatelessWidget {
  const EventSheet({
    super.key, 
    required this.title, 
    required this.subtitle, 
    required this.time, 
    required this.place, 
    required this.speaker
  });

  final String title, subtitle, time, place;
  final bool speaker;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Wrap(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.blue.shade50,
                          radius: 30,
                          child: const Icon(Icons.foundation, size: 34)
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(title,
                              style: GoogleFonts.rubik(
                                color: Colors.grey.shade700,
                                height: 0,
                                letterSpacing: -0.5,
                                fontSize: 24,
                                fontWeight: FontWeight.w500
                              )
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.schedule, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(subtitle,
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Tooltip(
                      triggerMode: TooltipTriggerMode.tap,
                      preferBelow: false,
                      message: 'Speaker',
                      textStyle: GoogleFonts.rubik(fontSize: 18, color: Colors.white),
                      child: Icon(Icons.speaker, size: 32, color: Colors.grey.shade700)
                    )
                  ],
                ),
              ),
              Divider(indent: 32, endIndent: 32, thickness: 2, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event, size: 28, color: Colors.grey.shade700),
                        const SizedBox(width: 16),
                        Text(DateFormat('EEEE, dd MMMM', 'id').format(DateTime.now()),
                          style: GoogleFonts.varelaRound(
                            color: Colors.grey.shade700,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 6),
                      height: 42,
                      child: VerticalDivider(
                        color: Colors.grey.shade200,
                        thickness: 2, indent: 6, endIndent: 6
                      )
                    ),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 28, color: Colors.grey.shade700),
                        const SizedBox(width: 16),
                        Text('07.30 - 11.30',
                          style: GoogleFonts.varelaRound(
                            color: Colors.grey.shade700,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 6),
                      height: 42,
                      child: VerticalDivider(
                        color: Colors.grey.shade200,
                        thickness: 2, indent: 6, endIndent: 6
                      )
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 28, color: Colors.grey.shade700),
                        const SizedBox(width: 16),
                        Text('Pendopo, Pentungan Sari',
                          style: GoogleFonts.varelaRound(
                            color: Colors.grey.shade700,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 6),
                          height: 180,
                          child: VerticalDivider(
                            color: Colors.grey.shade200,
                            thickness: 2, indent: 6, endIndent: 6
                          )
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: const Image(
                                fit: BoxFit.cover,
                                image: AssetImage('images/pendopo_1.jpg'),
                                height: 160,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {}, 
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0),
                      backgroundColor: MaterialStatePropertyAll(Colors.grey.shade100),
                      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    ),
                    icon: Icon(Icons.call, color: Colors.grey.shade600),
                    label: Text('Kontak',
                      style: GoogleFonts.rubik(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 4,
                  child: ElevatedButton.icon(
                    onPressed: () {}, 
                    style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    ),
                    icon: Icon(Icons.location_on, color: Colors.grey.shade100),
                    label: Text('Cari Lokasi',
                      style: GoogleFonts.rubik(
                        color: Colors.grey.shade100,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
