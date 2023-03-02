import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pentungan_sari/assets/dialog.dart';

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

  List<String> tabsName = ['Wisata', 'Acara', 'Kegiatan'];
  List<IconData> tabsIcon = [Icons.park, Icons.celebration, Icons.stadium];
  List<IconData> unselectedtabsIcon = [Icons.park_outlined, Icons.celebration_outlined, Icons.stadium_outlined];

  double headerHeight = 206;
  List<double> headerHeights = [206, 288];

  bool animate = false;
  List<bool> animates = List.filled(3, false, growable: false);
  void animating(bool value) => setState(() => animate = value);

  void setDate(DateTime value) {

  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, animationDuration: const Duration(milliseconds: 200));
    _weatherController = ScrollController(
      initialScrollOffset: today * 48
    );

    lastDayOfMonth = DateTime(now.year, now.month, 0);
    initializeDateFormatting();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => animates[0] = true));
  }

  @override
  void dispose() {
    _weatherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int i = daysFormat.indexOf(DateFormat('EEEE').format(lastDayOfMonth)) + 1;
    return Scaffold(
      backgroundColor: _tabController.index == 0 ? Colors.lightGreen : null,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 86),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.7)),
            heroTag: 'event_dialog',
            backgroundColor: Colors.lightGreen.shade50,
            foregroundColor: Colors.lightGreen.shade900,
            splashColor: Colors.lightGreen.shade300,
            elevation: 2,
            highlightElevation: 0,
            onPressed: () => showDialogEvent(context, 'event_dialog', now), 
            icon: const Icon(Icons.control_point_duplicate_outlined),
            label: Text('Tambah Acara', 
              style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
                leadingWidth: 76,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Transform.scale(
                    scale: 0.75,
                    child: const Image(
                      image: AssetImage('images/bumdes.png'),
                    ),
                  ),
                ),
                pinned: true,
                expandedHeight: headerHeight,
                toolbarHeight: 68,
                elevation: 8,
                surfaceTintColor: Colors.lightGreen,
                backgroundColor: Colors.lightGreen,
                shadowColor: Colors.black54,
                titleSpacing: 0.0,
                title: Text(widget.title, 
                  style: GoogleFonts.lora(
                    shadows: [ 
                      Shadow(
                        color: Colors.lightBlue.shade400,
                        blurRadius: 4,
                        offset: const Offset(0, 0)
                      )
                    ],
                    color: Colors.grey.shade100,
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
                  background: AnimatedContainer(
                    curve: Curves.easeInOutCubic,
                    duration: const Duration(milliseconds: 400),
                    decoration: _tabController.index == 1 ? const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ Colors.lightBlue, Colors.transparent ],
                        stops: [ 0.1, 1.0 ]
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24)
                      ),
                      image: DecorationImage(
                        opacity: 0.2,
                        fit: BoxFit.cover,
                        image: AssetImage('images/pool_2.jpg')
                      ),
                    ) : null,
                    child: Padding(
                      padding: EdgeInsets.only(left: 32, top: _tabController.index == 1 ? 110 : 104, right: 32, bottom: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedSize(
                            curve: Curves.fastOutSlowIn,
                            duration: const Duration(milliseconds: 300),
                            child: SizedBox(
                              height: _tabController.index == 1 ? null : 0,
                              width: null,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _tabController.index == 1 ? TextButton(
                                  onPressed: () {
                                    showPickDate(context, now, setDate);
                                  },
                                  style: ButtonStyle(
                                    visualDensity: VisualDensity.compact,
                                    padding: const MaterialStatePropertyAll(EdgeInsets.only(left: 12)),
                                    foregroundColor: MaterialStatePropertyAll(Colors.grey.shade100),
                                    textStyle: MaterialStatePropertyAll(
                                      GoogleFonts.roboto(
                                        wordSpacing: 6,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.wb_sunny, color: Colors.yellow),
                                      const SizedBox(width: 10),
                                      Text('${DateFormat('EEEE', 'id').format(now)}, ${now.day} ${DateFormat('MMMM', 'id').format(now)} ${now.year}'),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 6, bottom: 2),
                                        child: Icon(Icons.arrow_drop_down, size: 28, color: Colors.white),
                                      ),
                                    ],
                                  )
                                ) : null,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: _tabController.index == 1 ? ListView.builder(
                                shrinkWrap: true,
                                controller: _weatherController,
                                scrollDirection: Axis.horizontal,
                                itemCount: DateUtils.getDaysInMonth(now.year, now.month),
                                itemBuilder: (context, index) {
                                  if (i > 6) i = 0;
                                  Widget widget = Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                      decoration: BoxDecoration(
                                        color: index == (today - 1)
                                          ? Colors.lightGreen.withOpacity(0.7)
                                          : null,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            days[i].substring(0, 3),
                                            style: GoogleFonts.varelaRound(
                                              color: index == (today - 1) ? Colors.white : Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Icon(weatherIcons[i], color: index == (today - 1) ? Colors.white : Colors.white70),
                                          const SizedBox(height: 8),
                                          Text(
                                            (index + 1).toString(), 
                                            style: GoogleFonts.rubik(
                                              color: index == (today - 1) ? Colors.white : Colors.white70,
                                              fontSize: 16,
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  i++;
                                  return widget;
                                }
                              ) : ListTile(
                                onTap: () => _tabController.animateTo(1,
                                  duration: const Duration(milliseconds: 400), 
                                  curve: Curves.ease
                                ),
                                contentPadding: const EdgeInsets.only(top: 0),
                                title: const Padding(
                                  padding: EdgeInsets.only(bottom: 4, top: 2),
                                  child: Text('Toyomarto - Singosari'),
                                ),
                                subtitle: const Text('Kabupaten Malang'),
                                textColor: Colors.grey.shade100,
                                leading: const Icon(Icons.wb_sunny, size: 36, color: Colors.yellow),
                                trailing: const Icon(Icons.navigate_next),
                                iconColor: Colors.white,
                                visualDensity: const VisualDensity(vertical: 4),
                                titleTextStyle: GoogleFonts.varelaRound(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600
                                ),
                                subtitleTextStyle: GoogleFonts.rubik(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      ),
                      child: Text(
                        'Pesan Tempat', 
                        style: GoogleFonts.rubik(
                          letterSpacing: -0.25,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        )
                      ),
                    ),
                  ) 
                ],
                bottom: TabBar(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  onTap: (value) {
                    setState(() {
                      switch (value) {
                        case 0:
                          headerHeight = headerHeights[0];
                          animates.setAll(0, List.filled(3, false));
                          animates[0] = true;              
                          break;
                        case 1:
                          headerHeight = headerHeights[1];
                          animates.setAll(0, List.filled(3, false));
                          animates[1] = true;
                          break;
                        default: 
                          headerHeight = headerHeights[0];
                      }
                    });
                  },
                  splashBorderRadius: BorderRadius.circular(12),
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  indicator: UnderlineTabIndicator(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(width: 3, color: Colors.white),
                    insets: const EdgeInsets.only(left: 4)
                  ),
                  labelColor: Colors.white,
                  labelStyle: GoogleFonts.rubik(
                    letterSpacing: -0.25,
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                  unselectedLabelColor: Colors.white70,
                  tabs: List.generate(tabsName.length, (index) {
                    return Tab(icon: 
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_tabController.index == index 
                            ? tabsIcon[index] : unselectedtabsIcon[index],
                            size: 28,
                          ),
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
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Tour(animate: animates[0]),
              Event(now: now),
              const Placeholder(),
            ]
          ),
        ),
      ),
    );
  }
}


