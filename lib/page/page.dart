import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'recreation/recreation.dart';
import 'ticket/ticket.dart';

class ContextPage extends StatefulWidget {
  const ContextPage({super.key});

  @override
  State<ContextPage> createState() => _PageState();
}

class _PageState extends State<ContextPage> {
  late PageController _pageController;
  late int currentPage;

  final GlobalKey<State<StatefulWidget>> _bottomNavKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    _pageController = PageController(initialPage: 1, keepPage: true);
    currentPage = _pageController.initialPage;
    super.initState();
  }

  List<String> navigationItem = ['Jelajahi', 'Rekreasi', 'Tiket', 'Kontak'];
  List<IconData> navigationItemIcon = [
    Icons.explore, 
    Icons.nature_people, 
    Icons.pin, 
    Icons.call
  ];

  Color color = Colors.lightGreen;
  void changeNavColor(Color col) {
    _bottomNavKey.currentState?.setState(() {
      color = col;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            currentPage = value;           
          });
        },
        children: [
          const Placeholder(),
          RecreationPage(title: 'Pentungan Sari', pageController: _pageController),
          TicketPage(changeNavColor: changeNavColor),
          const Placeholder(),
        ]
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),                                            
            topRight: Radius.circular(30),                                           
          ),
          color: Colors.white,
          boxShadow: [ 
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2)
            ) 
          ]
        ),
        child: StatefulBuilder(
          key: _bottomNavKey,
          builder: (context, setState) => BottomNavigationBar(
            elevation: 0,
            currentIndex: currentPage,
            backgroundColor: Colors.transparent,
            iconSize: 26,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false, 
            showUnselectedLabels: false,
            onTap: (value) {
              currentPage = value;
              _pageController.animateToPage(value, 
                duration: const Duration(milliseconds: 400), 
                curve: Curves.ease
              );
              value != 2 ? changeNavColor(Colors.lightGreen) : changeNavColor(Colors.lightBlue);
            },
            items: List.generate(navigationItem.length, (index) {
              return BottomNavigationBarItem(
                label: navigationItem[index],
                icon: Column(
                  children: [
                    Icon(
                      color: currentPage == index 
                        ? color : Colors.grey.shade600,
                      navigationItemIcon[index],
                      grade: 200,
                      weight: 700,
                    ),
                    const SizedBox(height: 4),
                    Text(navigationItem[index],
                      style: GoogleFonts.varelaRound(
                        color: currentPage == index 
                          ? color : Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      )
                    )
                  ],
                )
              );
            })
          ),
        ),
      ),
    );
  }
}
