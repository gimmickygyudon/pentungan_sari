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
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        // padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        color: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                        Text('Minggu ini', 
                          style: GoogleFonts.varelaRound(
                            color: Colors.grey.shade600,
                            fontSize: 22,
                            fontWeight: FontWeight.w600
                          )
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_downward, size: 24, color: Colors.grey.shade600)
                      ],
                    ),
                    Expanded(child: Divider(indent: 18, endIndent: 18, thickness: 2, color: Colors.grey.shade300)),
                    Row(
                      children: [
                        Icon(Icons.date_range, size: 24, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text('$startWeek - $endWeek',
                          style: GoogleFonts.roboto(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text('KAMIS',
                          style: GoogleFonts.roboto(
                            color: Colors.green.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        Text(now.day.toString(),
                          style: GoogleFonts.nunito(
                            color: Colors.green.shade700,
                            fontSize: 28,
                            fontWeight: FontWeight.w700
                          )
                        )
                      ],
                    )
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Material(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                border: Border.all(width: 2, color: Colors.green),
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
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
                                ),
                              ),
                              child: ListTileTheme(
                                dense: true,
                                minVerticalPadding: 14,
                                child: ExpansionTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  leading: Icon(Icons.wb_sunny, color: Colors.green.shade700),
                                  tilePadding: const EdgeInsets.fromLTRB(24, 0, 16, 0),
                                  title: Text('Hari Biasa',
                                    style: GoogleFonts.rubik(
                                      color: Colors.green.shade700,
                                      letterSpacing: -0.25,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                ]
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text('JUMAT',
                          style: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        Text((now.day + 1).toString(),
                          style: GoogleFonts.nunito(
                            color: Colors.grey.shade700,
                            fontSize: 28,
                            fontWeight: FontWeight.w700
                          )
                        )
                      ],
                    )
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Material(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Expanded(
                            child: ListTileTheme(
                              dense: true,
                              minVerticalPadding: 14,
                              child: ListTile(
                                onTap: () {
                                  Future.delayed(const Duration(milliseconds: 150)).whenComplete(() {
                                    return showModalBottomSheet<void>(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      clipBehavior: Clip.antiAlias,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return EventSheet(
                                          title: 'Rapat Posyandu',
                                          subtitle: 'Jam: 07.30 - 11.30',
                                          time: (now.day + 1).toString(),
                                          place: 'Pendopo',
                                          speaker: true,
                                        );
                                      },
                                    );
                                  });
                                },
                                splashColor: Colors.blue.shade100,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.campaign, size: 32, color: Colors.grey.shade700),
                                    const SizedBox(width: 8),
                                    Icon(Icons.foundation, size: 32, color: Colors.grey.shade700),
                                  ],
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(24, 0, 18, 0),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text('Rapat Posyandu', 
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey.shade700,
                                      letterSpacing: -0.5,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    const Icon(Icons.schedule, color: Colors.grey, size: 22),
                                    const SizedBox(width: 6),
                                    Text('07.30 - 11.30', 
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 5, height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                ]
              ),
            )
          ]
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
                            Text('Rapat Posyandu', 
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
                                Text('07.30 - 11.30', 
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
                        Text(DateFormat('EEEE, dd MMMM').format(DateTime.now()),
                          style: GoogleFonts.varelaRound(
                            color: Colors.grey.shade700,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 4),
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
                      padding: const EdgeInsets.only(left: 4),
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
                          padding: const EdgeInsets.only(left: 4),
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
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        )
                      )
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
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0),
                      backgroundColor: const MaterialStatePropertyAll(Colors.lightGreen),
                      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        )
                      )
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
