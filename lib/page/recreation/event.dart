import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pentungan_sari/assets/card.dart';
import 'package:pentungan_sari/assets/dialog.dart';
import 'package:pentungan_sari/assets/icon.dart';

import '../../assets/object.dart';
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

class _EventState extends State<Event> with SingleTickerProviderStateMixin {
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

  late String view, location;
  late List<bool> animates;
  late bool animate;

  late Animation<Color?> locationAnimation;
  late AnimationController locationController;

  Map<String, IconData> weekdays = {
    'Hari': Icons.sunny, 
    'Minggu': Icons.filter_list, 
    'Bulan': Icons.calendar_view_month
  };

  @override
  void initState() {
    if (widget.viewHistory.isNotEmpty && widget.viewHistory.last != '') {
      widget.changeView(widget.viewHistory.last);
      view = widget.viewHistory.last;
      widget.viewHistory.removeLast();
    } else {
      view = widget.view;
    }

    startOfWeek = getDate(widget.now.subtract(Duration(days: widget.now.weekday - 1)));
    endOfWeek = getDate(widget.now.add(Duration(days: DateTime.daysPerWeek - widget.now.weekday)));

    final daysInLastMonth = DateUtils.getDaysInMonth(widget.now.year, widget.now.month - 1);
    final daysInMonth = DateUtils.getDaysInMonth(widget.now.year, widget.now.month);
    int date = startOfWeek.day;

    location = 'Pendopo';

    dummyevents = [
      {
        'start': 8.30,
        'end': 12.30,
        'date': (widget.now.day + 1).toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.day + 1)),
        'name': 'Rapat Posyandu',
        'time': '08.30 - 11.30',
        'location': 'Pendopo',
        'addons': [ 
          {
            'name': 'Listrik',
            'price': 30000,
            'duration': 3,
          }, {
            'name': 'Speaker',
            'price': 15000,
            'duration': 3,
          }
        ]
      },
      {
        'start': 6.30,
        'end': 9.30,
        'date': (widget.now.day + 1).toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.day + 1)),
        'name': 'Senam Pagi',
        'time': '06.30 - 09.30',
        'location': 'Halaman Depan',
        'addons': [ 
          {
            'name': 'Listrik',
            'price': 30000,
            'duration': 3,
          }, {
            'name': 'Speaker',
            'price': 15000,
            'duration': 3,
          } 
        ]
      },
      {
        'start': 13.00,
        'end': 15.30,
        'date': (widget.now.day + 1).toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.day + 1)),
        'name': 'Lomba Renang Al-Akbar',
        'time': '13.30 - 15.30',
        'location': 'Kolam',
        'addons': []
      }
    ];

    events = List.generate(7, (index) {
      int days;
      date > widget.now.day ? days = daysInLastMonth : days = daysInMonth;
      
      if (date > days) date = 1;
      final list = { 
        'date': date.toString(),
        'day': DateFormat('EEEE', 'id').format(DateTime(widget.now.year, widget.now.month, date)),
        'events': []
      };

      date++;
      return list;
    });

    for (var event in events) {
      int i = 0;
      for (var dummyevent in dummyevents) { 
       if (event['date'] == dummyevent['date']) {
          event['events'].insert(i, dummyevent);
        }
        i++;
      }
    }

    animates = [ false, false, false ];
    animate = false;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      animate = true;
      animates[viewIndex(view)] = true;
    }));

    locationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 600),
      vsync: this
    );
    locationAnimation = ColorTween(begin: Colors.grey.shade600, end: Colors.blue).animate(locationController);
  }

  @override
  void dispose() {
    animates.setAll(0, List.filled(3, false));
    locationController.dispose();
    super.dispose();
  }

  void viewAnimate(String value, [bool popScope = false]) {
    if (value != view) {
      if (popScope == false) widget.viewHistory.add(view);
      widget.changeView(value);
      view = value;

      setState(() {
        animates.setAll(0, List.filled(3, false));
        view = value;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => animates[viewIndex(value)] = true ));
    }
  }

  void changeLocation(String value) => setState(() {
    location = value;
    if (locationController.isAnimating) {
      locationController.stop(canceled: true);
      locationController.forward().whenComplete(() => locationController.reverse());
    } 
    else {
      locationController.forward().whenComplete(() => locationController.reverse());
    }
  });

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
                        toolbarHeight: 28,
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
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: DropdownButton(
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
                                        padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
                                        items: weekdays.entries.map<DropdownMenuItem<String>>((element) {
                                          return DropdownMenuItem<String>(
                                            value: element.key,
                                            child: Text(element.key)
                                          );
                                        }).toList()
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 600),
                                      switchInCurve: Curves.easeInOutCubic,
                                      switchOutCurve: Curves.easeInOutCubic,
                                      transitionBuilder: (child, animation) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, -1),
                                            end: const Offset(0, 0),
                                          ).animate(animation), 
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: child
                                          )
                                        );
                                      },
                                      child: view == 'Hari' ? AnimatedBuilder(
                                        animation: locationAnimation,
                                        builder: (context, child) => Container(
                                          decoration: BoxDecoration(
                                            color: locationAnimation.value?.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12)
                                          ),
                                          child: DropdownButton(
                                            value: location,
                                            onChanged: (value) => changeLocation(value as String),
                                            underline: const SizedBox(),
                                            isDense: true,
                                            style: GoogleFonts.varelaRound(
                                              color: locationAnimation.value,
                                              fontSize: 20,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w600
                                            ),
                                            icon: Padding(
                                              padding: const EdgeInsets.only(left: 12),
                                              child: Icon(Icons.location_on, color: locationAnimation.value),
                                            ),
                                            iconSize: 24,
                                            borderRadius: BorderRadius.circular(12),
                                            padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                                            items: locations.map<DropdownMenuItem<String>>((element) {
                                              return DropdownMenuItem<String>(
                                                value: element['name'],
                                                child: Text(element['name'])
                                              );
                                            }).toList()
                                          ),
                                        ),
                                      ) : null,
                                    )
                                  ],
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
                              return EventThisDay(events: dummyevents, animate: animates[0], location: location, changeLocation: changeLocation);
                            case 'Bulan':
                              return EventThisWeek(events: events, now: widget.now, animate: animates[1], viewAnimate: viewAnimate);
                            default:
                              return EventThisWeek(events: events, now: widget.now, animate: animates[1], viewAnimate: viewAnimate);
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
  const EventThisDay({
    super.key, 
    required this.events, 
    required this.animate, 
    required this.location, 
    required this.changeLocation
  });

  final List<Map<String, dynamic>> events;
  final bool animate;
  final String location;
  final Function changeLocation;

  @override
  State<EventThisDay> createState() => _EventThisDayState();
}

class _EventThisDayState extends State<EventThisDay> {
  final currentTimeKey = GlobalKey();

  List<Map<String, dynamic>?> events = List.filled(24, null);
  
  @override
  void initState() {
    for (var element in widget.events) {
      int start = int.parse(element['start'].toString().substring(0, element['start'].toString().indexOf('.')));
      events[start] = element;
    }
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
    int skip = 0, miniskip = 0;
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Column(
            children: List.generate(25, (index) {
              bool currentTime = minute != '00' && hour == '${((index).toString().length == 1 ? '0' : '')}$index';
              duration += 50;
              return AnimatedSlide(
                offset: Offset(0, widget.animate ? 0 : 2),
                curve: Curves.easeOutCubic,
                duration: Duration(milliseconds: duration),
                child: AnimatedOpacity(
                  opacity: widget.animate ? 1 : 0,
                  curve: Curves.easeInOutCubic,
                  duration: Duration(milliseconds: duration - 50),
                  child: SizedBox(
                    height: 64,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (currentTime) ...[
                          Transform.scale(
                            key: currentTimeKey,
                            scaleX: 1.05,
                            scaleY: 1.4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                margin: const EdgeInsets.only(left: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  border: const Border(left: BorderSide(color: Colors.green, width: 3))
                                ),
                                child: Transform.scale(
                                  scaleX: 0.95,
                                  scaleY: 0.75,
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
                      ]
                    ),
                  ),
                ),
              );
            }
          )), 
          Positioned.fill(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(events.length, (index) {
                late Widget element;
                if (index == 0) duration = 400;
                duration += 50;
                
                if (events[index] != null && events[index]!['location'] == widget.location) {
                  skip = countEventDuration(events[index]!['start'], events[index]!['end']);
                }

                element = AnimatedSlide(
                  offset: Offset(0, widget.animate ? 0 : 1),
                  curve: Curves.easeOutCubic,
                  duration: Duration(milliseconds: duration),
                  child: AnimatedOpacity(
                    opacity: widget.animate ? 1 : 0,
                    curve: Curves.easeInOutCubic,
                    duration: Duration(milliseconds: duration - 50),
                    child: AnimatedSwitcher(
                      switchInCurve: Curves.easeInOutCubic,
                      switchOutCurve: Curves.easeInOutCubic,
                      duration: const Duration(milliseconds: 600),
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.5, 0),
                            end: const Offset(0, 0),
                          ).animate(animation), 
                          child: FadeTransition(
                            opacity: animation,
                            child: child
                          )
                        );
                      },
                      child: (() { 
                        if (events[index] != null && events[index]!['location'] == widget.location) {
                          miniskip++;
                          return Padding(
                          key: UniqueKey(),
                          padding: const EdgeInsets.only(left: 70, bottom: 12),
                            child: CardEventDay(event: events[index]!, duration: skip.toDouble(), showEventSheet: showEventSheet, showDialogImage: showDialogImage),
                          );
                        } else if (events[index] != null) {
                          return Padding(
                            key: UniqueKey(),
                            padding: const EdgeInsets.only(top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CardEventDayNext(event: events[index]!, next: true, changeLocation: widget.changeLocation),
                              ],
                            ),
                          );
                        }
                        else { 
                          Widget widget = SizedBox(height: skip != 0 ? miniskip != 0 ? 28 : 0 : 64);
                          if (skip != 0) skip--;
                          if (miniskip != 0) miniskip--;
                          return widget;
                        }
                      }())
                    ),
                  ),
                );
                return element;
              }),
            ),
          ) 
        ],
      )
    );
  }
}

class EventThisWeek extends StatelessWidget {
  const EventThisWeek({
    super.key, 
    required this.events, 
    required this.now, 
    required this.animate, 
    required this.viewAnimate
  });

  final List<Map<String, dynamic>> events;
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
        bool today, noevent = true;
        Map<String, Color> colors;


        if (events[index]['date'] == now.day.toString()) { 
          today = true; open = true; 
        } else { 
          today = false; 
        }

        if (events[index]['events'].isEmpty) {
          noevent = true;
        } else {
          noevent = false;
        }

        if (noevent) {
          colors = {
            'color': Colors.green,
            'subcolor': Colors.green.shade50,
            'splashcolor': Colors.green.shade100,
            'daycolor': Colors.green.shade400,
            'datecolor': Colors.green.shade600,
          };
        } else {
          colors = {
            'color': Colors.blue,
            'subcolor': Colors.blue.shade50,
            'splashcolor': Colors.blue.shade100,
            'daycolor': Colors.blue.shade400,
            'datecolor': Colors.blue.shade600,
          };
        }

        duration += 100;
        return AnimatedSlide(
          offset: Offset(0, animate ? 0 : noevent ? 2 : 1),
          curve: Curves.easeOutCubic,
          duration: Duration(milliseconds: duration),
          child: AnimatedOpacity(
            opacity: animate ? 1 : 0,
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: duration - 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                              color: colors['daycolor'],
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
                                ? colors['datecolor']
                                : open ? Colors.grey.shade600 : Colors.grey,
                              fontSize: 24,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          if (today) Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Chip(
                              backgroundColor: colors['daycolor'],
                              elevation: 4,
                              shadowColor: Colors.black38,
                              label: const Text('Hari Ini'),
                              labelStyle: GoogleFonts.varelaRound(fontWeight: FontWeight.w600, color: colors['subcolor']),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                              side: BorderSide.none,
                            ),
                          ),
                          if (!noevent) Container(
                            margin: EdgeInsets.only(top: today ? 0 : 4, bottom: 10),
                            width: 1, height: events[index]['events'].length.toDouble() * 132,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          if (noevent) CardEventWeekNormal(title: 'Hari Biasa', 
                            animate: animate, today: today, open: open, viewAnimate: viewAnimate, event: events[index], colors: colors
                          ), 
                          if (noevent == false) CardEventWeek(animate: animate, 
                            today: today, open: open, showEventSheet: showEventSheet, event: events[index], colors: colors
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
                if (noevent && index != 6) Container(
                  margin: EdgeInsets.only(left: 42, top: today ? 0 : 4, bottom: 10),
                  width: 1, height: 34,
                  color: Colors.grey.shade300,
                ),
                if (index == 6) SizedBox(height: noevent ? 42 : 21),
              ],
            ),
          ),
        );
      }
    );
  }
}

void showEventSheet(BuildContext context, Map<String, dynamic> event, DateTime now) {
  showModalBottomSheet<void>(
    barrierColor: Colors.black38,
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16), topRight: Radius.circular(16)
      )
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return EventSheet(
        event: event,
      );
    },
  );
}

class EventSheet extends StatefulWidget {
  const EventSheet({
    super.key,
    required this.event, 
  });

  final Map<String, dynamic> event;

  @override
  State<EventSheet> createState() => _EventSheetState();
}

class _EventSheetState extends State<EventSheet> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => animate = true));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String image = findLocationImage(widget.event);
    int duration = countEventDuration(widget.event['start'], widget.event['end']);

    return AnimatedSize(
      alignment: Alignment.topCenter,
      curve: Curves.easeOutCubic,
      duration: const Duration(milliseconds: 600),
      child: SizedBox(
        height: animate ? null : 0,
        child: Container(
          color: Colors.white,
          child: Wrap(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.blue,
                    height: 7,
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
                  AnimatedSlide(
                    offset: Offset(0, animate ? 0 : 0.5),
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 600),
                    child: AnimatedOpacity(
                      opacity: animate ? 1 : 0,
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 1600),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: false,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.blue.shade50,
                                        foregroundColor: Colors.blue,
                                        radius: 30,
                                        child: const Icon(Icons.foundation, size: 34)
                                      ),
                                    ),
                                    // const SizedBox(width: 24),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(widget.event['name'],
                                          style: GoogleFonts.signikaNegative(
                                            color: Colors.grey.shade800,
                                            height: 0,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                        const SizedBox(height: 4),
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.schedule, color: Colors.grey, size: 20),
                                              const SizedBox(width: 8),
                                              Text(widget.event['time'],
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                              const VerticalDivider(width: 20, indent: 4, endIndent: 4),
                                              Text('$duration Jam',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconAddons(event: widget.event, size: 28, radius: 24)
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
                                    Text(DateFormat('EEEE, dd MMMM yyyy', 'id').format(DateTime.now()),
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
                                    thickness: 1, indent: 6, endIndent: 6
                                  )
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.schedule, size: 28, color: Colors.grey.shade700),
                                    const SizedBox(width: 16),
                                    Text(widget.event['time'],
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
                                    thickness: 1, indent: 6, endIndent: 6
                                  )
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 28, color: Colors.grey.shade700),
                                    const SizedBox(width: 16),
                                    Text('${widget.event['location']}, Pentungan Sari',
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
                                      height: 220,
                                      child: VerticalDivider(
                                        color: Colors.grey.shade300,
                                        thickness: 1, indent: 6, endIndent: 6
                                      )
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                                        child: AnimatedScale(
                                          scale: animate ? 1 : 0,
                                          duration: const Duration(milliseconds: 600),
                                          curve: Curves.easeOutCubic,
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(image)
                                              )
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                        icon: Icon(Icons.explore, color: Colors.grey.shade100),
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
        ),
      ),
    );
  }
}
