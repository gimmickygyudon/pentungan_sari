import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Event extends StatefulWidget {
  const Event({super.key, required this.now});

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

  @override
  void initState() {
    dummyevents = [
      {
        'date': (widget.now.day + 1).toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.day)).toUpperCase(),
        'name': 'Rapat Posyandu',
        'time': '07.30 - 11.30',
        'addons': [ Icons.campaign, Icons.foundation ],
        'addons_color': [ Colors.orange.shade50, Colors.blue.shade50 ]
      }
    ];

    startOfWeek = getDate(widget.now.subtract(Duration(days: widget.now.weekday - 1)));
    endOfWeek = getDate(widget.now.add(Duration(days: DateTime.daysPerWeek - widget.now.weekday)));

    int date = startOfWeek.day;
    events = List.generate(7, (index) {
      final list = { 
        'date': date.toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.year, widget.now.month, date)).toUpperCase(),
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Scaffold(
        body: Container(
          color: Colors.grey.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
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
                              fontSize: 22,
                              fontWeight: FontWeight.w600
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                            ),
                            iconSize: 32,
                            borderRadius: BorderRadius.circular(12),
                            items: [
                              DropdownMenuItem(
                                value: 'Hari',
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_view_day_outlined, size: 26, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    const Text('Hari'),
                                  ],
                                )
                              ),
                              DropdownMenuItem(
                                value: 'Minggu',
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_view_week_outlined, size: 26, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    const Text('Minggu'),
                                  ],
                                )
                              ),
                              DropdownMenuItem(
                                value: 'Bulan',
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_view_month, size: 26, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
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
                          const Icon(Icons.lens, color: Colors.blue, size: 12),
                          const SizedBox(width: 6),
                          Text('${dummyevents.length}',
                            style: GoogleFonts.varelaRound(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              wordSpacing: 2
                            ),
                          ),
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
              const SizedBox(height: 32),
              Flexible(
                child: ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
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
                    events[index]['date'] == widget.now.day.toString() ? today = true : today = false;
                    events[index]['name'] == 'Hari Biasa' ? noevent = true : noevent = false;
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(events[index]['day'],
                                    style: GoogleFonts.rubik(
                                      color: events[index]['day'] == DateFormat('EEEE', 'id').format(widget.now).toUpperCase()
                                        ? daycolor : Colors.grey,
                                      fontSize: 16,
                                      fontWeight: today ? FontWeight.w600 : FontWeight.w400
                                    )
                                  ),
                                  Text(events[index]['date'],
                                    style: GoogleFonts.nunito(
                                      color: today ? datecolor : Colors.grey.shade600,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800
                                    )
                                  ),
                                  today ? Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Chip(
                                      backgroundColor: color,
                                      elevation: 2,
                                      shadowColor: Colors.black54,
                                      label: const Text('Hari Ini'),
                                      labelStyle: GoogleFonts.varelaRound(fontWeight: FontWeight.w600, color: Colors.white),
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                      side: BorderSide.none,
                                    ),
                                  ) : const SizedBox()
                                ],
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 4,
                              child: Material(
                                elevation: noevent ? 2 : 4,
                                shadowColor: Colors.black26,
                                borderRadius: BorderRadius.circular(today ? 12 : 8),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      decoration: today ? BoxDecoration(
                                        color: color.withOpacity(0.025),
                                        borderRadius: BorderRadius.circular(today ? 12 : 8),
                                        border: Border.all(width: 2, color: daycolor)
                                      ) : null,
                                      child: ListTileTheme(
                                        tileColor: today
                                          ? subcolor : null,
                                        dense: true,
                                        minVerticalPadding: today
                                          ? 12 : 14,
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
                                                      time: (widget.now.day + 1).toString(),
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
                                                backgroundColor: events[index]['addons_color'][i],
                                                child: Icon(events[index]['addons'][i], size: 24, color: Colors.grey.shade600)
                                              );
                                            }),
                                          ) : widget.now.day <= int.parse(events[index]['date'])
                                            ? TextButton.icon(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                  iconSize: const MaterialStatePropertyAll(16),
                                                  foregroundColor: const MaterialStatePropertyAll(Colors.green),
                                                  overlayColor: MaterialStatePropertyAll(Colors.green.shade100)
                                                ),
                                                label: const Text('Pesan Tempat'),
                                                icon: const Icon(Icons.add_business_outlined)
                                              )
                                            : null,
                                          contentPadding: EdgeInsets.fromLTRB(24, 0, noevent ? 2 : 18, 0),
                                          isThreeLine: events[index]['time'] != null ? true : false,
                                          title: Padding(
                                            padding: const EdgeInsets.only(bottom: 0),
                                            child: Text(events[index]['name'],
                                              style: GoogleFonts.rubik(
                                                color: today 
                                                  ? datecolor 
                                                  : noevent
                                                    ? Colors.grey
                                                    : Colors.grey.shade700,
                                                letterSpacing: -0.25,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500
                                              )
                                            ),
                                          ),
                                          subtitle: events[index]['time'] != null ? Padding(
                                            padding: const EdgeInsets.only(bottom: 4, top: 4),
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
                                                    Text('3 Jam',
                                                      style: GoogleFonts.roboto(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ) : null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: today ? 6 : 4, 
                                      height: events[index]['time'] != null ? 55 : 25,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  }
                ),
              ),
            ]
          ),
        ),
      ),
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
                                Text(time,
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
                      child: Icon(Icons.campaign, size: 32, color: Colors.grey.shade700)
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
