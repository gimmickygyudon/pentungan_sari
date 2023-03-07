import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pentungan_sari/assets/dialog.dart';

import '../../function/builder.dart';

class Event extends StatefulWidget {
  const Event({
    super.key, 
    required this.now, 
    required this.viewHistory, 
    required this.view, 
    required this.changeView
  });

  final DateTime now;
  final List<String> viewHistory;
  final String view;
  final Function changeView;

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

  late String view;
  late List<bool> animates;
  late bool animate;

  @override
  void initState() {
    if (widget.viewHistory.isNotEmpty && widget.viewHistory.last != '') {
      widget.changeView(widget.viewHistory.last);
      view = widget.viewHistory.last;
      widget.viewHistory.removeLast();
    } else {
      view = widget.view;
    }

    dummyevents = [
      {
        'date': (widget.now.day + 1).toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.day + 2)),
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

    animates = [ false, false, false ];
    animate = false;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      animate = true;
      animates[viewIndex(view)] = true;
    }));
  }

  @override
  void dispose() {
    animates.setAll(0, List.filled(3, false));
    super.dispose();
  }

  void viewAnimate(String value, [bool popScope = false]) {
    if (value != view) {
      if (popScope == false) widget.viewHistory.add(view);
      widget.changeView(value);
      view = value;

      setState(() => animates.setAll(0, List.filled(3, false)));
      WidgetsBinding.instance.addPostFrameCallback((_) =>
        Timer(const Duration(milliseconds: 200), () => setState(() => 
          view = value
        ))
      );
      WidgetsBinding.instance.addPostFrameCallback((_) => 
        Timer(const Duration(milliseconds: 300), () => 
        setState(() => 
          animates[viewIndex(value)] = true
        ))
      );
    }
  }

  int viewIndex(String view) {
    switch (view) {
      case 'Hari':
        return 0;
      case 'Minggu':
        return 1;
      case 'Bulan':
        return 2;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.viewHistory.isNotEmpty && widget.viewHistory.last != '') {
          viewAnimate(widget.viewHistory.last, true);
          if (widget.viewHistory.last != '') widget.viewHistory.removeLast();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Builder(
            builder: (BuildContext context) {
              return Container(
                color: Colors.grey.shade100,
                child: AnimatedSlide(
                offset: Offset(0, animate ? 0 : -1),
                curve: Curves.easeOutCubic,
                duration: const Duration(milliseconds: 500),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverPinnedOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
                      ),
                      SliverAppBar(
                        pinned: true,
                        forceElevated: true,
                        toolbarHeight: 20,
                        elevation: 4,
                        shadowColor: Colors.black38,
                        surfaceTintColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24)
                          )
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          expandedTitleScale: 1,
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 8, 16, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButton(
                                  value: view,
                                  onChanged: (value) {
                                    viewAnimate(value as String);
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
                                  padding: const EdgeInsets.only(left: 8),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Hari',
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 2),
                                            child: Icon(Icons.sunny, size: 24, color: Colors.yellow.shade700),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text('Hari'),
                                        ],
                                      )
                                    ),
                                    DropdownMenuItem(
                                      value: 'Minggu',
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 2),
                                            child: Icon(Icons.filter_list, size: 24, color: Colors.grey.shade700),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text('Minggu'),
                                        ],
                                      )
                                    ),
                                    DropdownMenuItem(
                                      value: 'Bulan',
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 2),
                                            child: Icon(Icons.calendar_view_month, size: 24, color: Colors.grey.shade700),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text('Bulan'),
                                        ],
                                      )
                                    )
                                  ]
                                ),
                                IconButton(
                                  onPressed: (){}, 
                                  icon: const Icon(Icons.search)
                                ),
                              ],
                            ),
                          ),
                          titlePadding: EdgeInsets.zero, 
                        ),
                      ),
                      SliverPadding(
                        padding: (() {
                          switch (view) {
                            case 'Hari':
                              return const EdgeInsets.symmetric(horizontal: 22, vertical: 24);
                            case 'Bulan':
                              return const EdgeInsets.only(left: 18, right: 28, top: 24, bottom: 82);
                            default:
                              return const EdgeInsets.only(left: 18, right: 28, top: 24, bottom: 82);
                          }
                        }()),
                        sliver: (() {
                          switch (view) {
                            case 'Hari':
                              return EventThisDay(events: dummyevents, animate: animates[0]);
                            case 'Bulan':
                              return EventThisWeek(events: events, dummyevents: dummyevents, now: widget.now, animate: animates[1], viewAnimate: viewAnimate);
                            default:
                              return EventThisWeek(events: events, dummyevents: dummyevents, now: widget.now, animate: animates[1], viewAnimate: viewAnimate);
                          }
                        }()) 
                      ),
                    ]
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}

class EventThisDay extends StatefulWidget {
  const EventThisDay({super.key, required this.events, required this.animate});

  final List<Map<String, dynamic>> events;
  final bool animate;

  @override
  State<EventThisDay> createState() => _EventThisDayState();
}

class _EventThisDayState extends State<EventThisDay> {
  final currentTimeKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void scrollToCurrent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400)).then((value) {
        if (currentTimeKey.currentContext != null) {
          Scrollable.ensureVisible(
            currentTimeKey.currentContext!,
            alignment: 0.65,
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
            curve: Curves.easeOutCubic, 
            duration: const Duration(milliseconds: 2000)
          );
        } else { debugPrint(currentTimeKey.currentContext.toString()); }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String minute = DateFormat("mm").format(DateTime.now());
    String hour = DateFormat("HH").format(DateTime.now());

    int duration = 400;
    return SliverToBoxAdapter(
      child: Column(
        children: List.generate(25, (index) {
          duration += 50;
          return AnimatedSlide(
            offset: Offset(0, widget.animate ? 0 : 2),
            curve: Curves.easeOutCubic,
            duration: Duration(milliseconds: duration),
            child: AnimatedOpacity(
              opacity: widget.animate ? 1 : 0,
              curve: Curves.easeInOutCubic,
              duration: Duration(milliseconds: duration - 50),
              child: Stack(
                children: [
                  if (index <= 6 || index >= 11) Column(
                    children: [
                      if (minute != '00' && hour == '${((index).toString().length == 1 ? '0' : '')}$index') ...[
                        Row(
                          key: currentTimeKey,
                          children: [
                            Expanded(
                              child: Transform.scale(
                                scale: 1.05,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    margin: const EdgeInsets.only(left: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      border: const Border(left: BorderSide(color: Colors.green, width: 3))
                                    ),
                                    child: Transform.scale(
                                      scale: 0.95,
                                      child: Text('$hour:$minute',
                                        style: GoogleFonts.rubik(
                                          color: Colors.green,
                                          letterSpacing: 0.5,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text('${(index).toString().length == 1 ? '0$index' : index}:00', 
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
                      ],
                    const SizedBox(height: 38) 
                    ] + List.generate(index + 1 == 7 ? 4 : 0, (i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if ((index + i + 1 >= 7) || (index + i + 1 <= 12)) ...[
                            if (minute != '00' && hour == '${((index + i + 1).toString().length == 1 ? '0' : '')}${index + i + 1}') ...[
                              Row(
                                key: currentTimeKey,
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
                                            border: const Border(left: BorderSide(color: Colors.green, width: 3))
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
                                    child: Text('${(index + i + 1).toString().length == 1 ? '0${index + i + 1}' : index + i + 1}:00', 
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
                      );
                    }),
                  ),
                  if (index + 1 == 7) ...[ 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(70, 30, 0 ,0),
                      child: Card(
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
                            Timer(const Duration(milliseconds: 150), () => showEventSheet(context, widget.events, 0, DateTime.now()));
                          },
                          child: SizedBox(
                            height: 94 * 3,
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
                                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
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
                                                ),
                                              ],
                                            ),
                                            Wrap(
                                              spacing: 8,
                                              children: List.generate(widget.events[0]['addons'].length, (i) {
                                                return CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: widget.events[0]['addons_subcolor'][i],
                                                  child: Icon(widget.events[0]['addons'][i], size: 24, color: widget.events[0]['addons_color'][i])
                                                );
                                              }),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () => showDialogImage(context, 'images/pendopo_1.jpg', 'Rapat Posyandu'),
                                            child: Hero(
                                              tag: 'Rapat Posyandu',
                                              child: Container(
                                                height: double.infinity,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  image: const DecorationImage(
                                                    image: AssetImage('images/pendopo_1.jpg'), 
                                                    fit: BoxFit.cover,
                                                    opacity: 0.75
                                                  )
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Container(
                                                          margin: const EdgeInsets.all(8),
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey.shade800,
                                                            borderRadius: BorderRadius.circular(12)
                                                          ),
                                                          child: Text('Pendopo',
                                                            style: GoogleFonts.varelaRound(
                                                              color: Colors.white,
                                                              decoration: TextDecoration.none,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w600
                                                            )
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(right: 2),
                                                          child: ElevatedButton.icon(
                                                            style: ButtonStyle(
                                                              backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                                              foregroundColor: MaterialStatePropertyAll(Colors.grey.shade800)
                                                            ),
                                                            onPressed: () {}, 
                                                            icon: const Icon(Icons.location_on), 
                                                            label: Text('Cari Lokasi', 
                                                              style: GoogleFonts.rubik(
                                                                height: 0,
                                                                letterSpacing: -0.25,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500
                                                              )
                                                            ),
                                                          ),
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
                      ),
                    ) 
                  ]
                ],
              ),
            ),
          );
        }
      ))
    );
  }
}

class EventThisWeek extends StatelessWidget {
  const EventThisWeek({
    super.key, 
    required this.events, 
    required this.dummyevents, 
    required this.now, 
    required this.animate, 
    required this.viewAnimate
  });

  final List<Map<String, dynamic>> events, dummyevents;
  final DateTime now;
  final bool animate;

  final Function viewAnimate;

  @override
  Widget build(BuildContext context) {
    bool open = false;
    int duration = 400;
    return SliverList.builder(
      itemCount: 7,
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
            duration: Duration(milliseconds: duration - 50),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(today ? events[index]['day'] : events[index]['day'],
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
                      child: Column(
                        children: [
                          Material(
                            elevation: noevent && !today ? 2 : 4,
                            color: open ? null : Colors.white60,
                            shadowColor: noevent && !today ? Colors.black12 : Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                if(!noevent) Align(
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
                                    color: color.withOpacity(0.000005),
                                    borderRadius: BorderRadius.circular(today ? 12 : 8),
                                    border: Border.all(width: 0, color: Colors.transparent)
                                  ) : null,
                                  child: ListTileTheme(
                                    tileColor: today ? subcolor : null,
                                    dense: true,
                                    minVerticalPadding: 14,
                                    child: ListTile(
                                      onTap: () {
                                        if (!noevent) {
                                          Future.delayed(const Duration(milliseconds: 150)).whenComplete(() {
                                            return showEventSheet(context, events, index, now);
                                          });
                                        }
                                        if (noevent) Future.delayed(const Duration(milliseconds: 150)).whenComplete(() => viewAnimate('Hari'));
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
                                if (today) Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 5, 
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: open ? color.withOpacity(0.75) : Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (today) Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 8, left: 6),
                                    height: 4, 
                                    width: 28,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade300,
                                      borderRadius: BorderRadius.circular(2)
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  RichText(
                                    text: TextSpan(text: 'Acara berikutnya dimulai\n',
                                      style: GoogleFonts.rubik(
                                        color: Colors.grey,
                                        fontSize: 16
                                      ),
                                      children: [
                                        TextSpan(text: '1 Hari', 
                                          style: GoogleFonts.rubik(
                                            color: Colors.blue.shade400,
                                            wordSpacing: 3,
                                            height: 1.5
                                          ),
                                        ),
                                        WidgetSpan(child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                          color: Colors.grey.shade300, height: 18, width: 1)
                                        ),
                                        TextSpan(text: 'Rapat Posyandu', 
                                          style: GoogleFonts.rubik(
                                            color: Colors.blue.shade300,
                                            height: 1.5
                                          ),
                                        ),
                                      ]
                                    )
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
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

void showEventSheet(BuildContext context, List<Map<String, dynamic>> events, int index, DateTime now) {
  showModalBottomSheet<void>(
    barrierColor: Colors.black38,
    context: context,
    clipBehavior: Clip.antiAliasWithSaveLayer,
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
              Container(
                color: Colors.blue,
                height: 6,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  height: 5,
                  width: 45,
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
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: Colors.blue,
                          radius: 30,
                          child: const Icon(Icons.foundation, size: 34)
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(title,
                              style: GoogleFonts.signikaNegative(
                                color: Colors.grey.shade700,
                                height: 0,
                                letterSpacing: -0.5,
                                fontSize: 26,
                                fontWeight: FontWeight.w500
                              )
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.schedule, color: Colors.grey, size: 20),
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
                      child: Icon(Icons.speaker, size: 28, color: Colors.grey.shade700)
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
                        color: Colors.grey.shade300,
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
                        color: Colors.grey.shade300,
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
                            color: Colors.grey.shade300,
                            thickness: 2, indent: 6, endIndent: 6
                          )
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('images/pendopo_1.jpg')
                                )
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
