import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../assets/weather.dart';
import 'event.dart';
import 'tour.dart';

class RecreationPage extends StatefulWidget {
  const RecreationPage({
    super.key, 
    required this.title, 
    required this.pageController
  });

  final String title;
  final PageController pageController;

  @override
  State<RecreationPage> createState() => _RecreationPageState();
}

class _RecreationPageState extends State<RecreationPage> with SingleTickerProviderStateMixin {

  late ScrollController _weatherController;
  late TabController _tabController;

  final int today = int.parse(DateFormat('d').format(DateTime.now()));
  final DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;

  List<String> tabsName = ['Wisata', 'Acara', 'Permainan'];
  List<IconData> tabsIcon = [Icons.park_rounded, Icons.celebration_rounded, Icons.attractions];
  List<IconData> unselectedtabsIcon = [Icons.park_outlined, Icons.celebration_outlined, Icons.pool_outlined];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() { 
      setState(() {});
    });

    _weatherController = ScrollController(
      initialScrollOffset: today * 48
    );

    lastDayOfMonth = DateTime(now.year, now.month, 0);
    super.initState();
  }

  @override
  void dispose() {
    _weatherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int i = daysFormat.indexOf(DateFormat('EEEE').format(lastDayOfMonth)) + 1;
    return Container(
      color: Colors.lightGreen,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: _tabController.index == 0 ? Colors.lightGreen : null,
          body: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    leading: IconButton(
                      onPressed: () {}, 
                      icon: const Icon(Icons.menu, color: Colors.white)
                    ),
                    pinned: true,
                    expandedHeight: _tabController.index == 1 ? 280 : 220,
                    toolbarHeight: 60,
                    elevation: 8,
                    surfaceTintColor: Colors.lightGreen,
                    backgroundColor: Colors.lightGreen,
                    shadowColor: Colors.black54,
                    titleSpacing: 0.0,
                    title: Text(widget.title, 
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800
                      )
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24)
                      )
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1.35,
                      background: Padding(
                        padding: const EdgeInsets.only(left: 32, top: 56, right: 32, bottom: 52),
                        child: Column(
                          children: [
                            AnimatedSize(
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 300),
                              child: SizedBox(
                                height: _tabController.index == 1 ? null : 0,
                                width: null,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _tabController.index == 1 ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: DropdownButton(
                                      value: 'Februari',
                                      onChanged: (value) {},
                                      underline: const SizedBox(),
                                      icon: Transform.translate(
                                        offset: const Offset(5, 0),
                                        child: const Icon(Icons.expand_more, size: 30, color: Colors.white)
                                      ),
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Februari',
                                          child: Text('Februari')
                                        ) 
                                      ], 
                                    ),
                                  ) : null,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: _weatherController,
                                scrollDirection: Axis.horizontal,
                                itemCount: lastDayOfMonth.day,
                                itemBuilder: (context, index) {
                                  if (i > 6) i = 0;
                                  Widget widget = Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: index == (today - 1)
                                          ? Colors.green.shade700 
                                          : null,
                                        borderRadius: BorderRadius.circular(14)
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            (index + 1).toString(), 
                                            style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontSize: 16
                                            )
                                          ),
                                          const SizedBox(height: 8),
                                          Icon(weatherIcons[i], color: Colors.white),
                                          const SizedBox(height: 4),
                                          Text(
                                            days[i].substring(0, 3).toUpperCase(),
                                            style: GoogleFonts.rubik(
                                              color: Colors.grey.shade300,
                                              fontSize: 14
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                  i++;
                                  return widget;
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ElevatedButton(
                          onPressed: () {
                            widget.pageController.animateToPage(2, 
                              duration: const Duration(milliseconds: 400), 
                              curve: Curves.ease
                            );
                          }, 
                          style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor: MaterialStatePropertyAll(Colors.white),
                            foregroundColor: MaterialStatePropertyAll(Colors.lightGreen),
                            overlayColor: MaterialStatePropertyAll(Colors.lightGreen),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(0),
                                  topLeft: Radius.circular(25.7),
                                  bottomRight: Radius.circular(25.7),
                                  bottomLeft: Radius.circular(25.7)
                                )
                              )
                            )
                          ),
                          child: Text(
                            'Pesan Tempat', 
                            style: GoogleFonts.signikaNegative(
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                            )
                          ),
                        ),
                      ) 
                    ],
                    bottom: TabBar(
                      controller: _tabController,
                      splashBorderRadius: BorderRadius.circular(12),
                      dividerColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.white,
                      indicator: UnderlineTabIndicator(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(width: 4, color: Colors.white),
                        insets: const EdgeInsets.only(left: 4)
                      ),
                      labelColor: Colors.white,
                      labelStyle: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                      unselectedLabelColor: Colors.white70,
                      tabs: List.generate(tabsName.length, (index) {
                        return Tab(icon: 
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(tabsIcon[index]),
                              const SizedBox(width: 8),
                              Text(tabsName[index])
                            ],
                          )
                        );
                      })
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  Tour(),
                  Event(now: now),
                  const Placeholder(),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}


