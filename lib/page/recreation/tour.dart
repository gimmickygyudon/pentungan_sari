import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tour extends StatelessWidget {
  Tour({super.key, required this.animate});
  
  final List<String> parks = ['pool_1.jpg', 'gapura_1.jpg', 'gazebo_1.jpg', 'cafe_1.jpg'];
  final List<String> parksNames = ['Kolam', 'Gapura', 'Gazebo', 'Cafe'];

  final List<String> facilities = ['Pendopo', 'Terapi Ikan', 'Mushola', 'Kamar Mandi'];
  final List<String> facilitiesNames = ['pendopo_1.jpg', 'therapy_1.jpg', 'mosque_1.jpg', 'toilet_1.jpg'];

  final bool animate;

  @override
  Widget build(BuildContext context) {
    int duration = 400;
    return Container(
      color: Colors.grey.shade50,
      child: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
              ),
              SliverFillRemaining(
                child: Stack(
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: AnimatedContainer(
                        curve: Curves.easeOutCubic,
                        duration: const Duration(milliseconds: 2000),
                        height: animate ? 120 : 0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50), 
                            bottomLeft: Radius.circular(50)
                          ),
                          color: Colors.lightGreen
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 380,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                            scrollDirection: Axis.horizontal,
                              children: List.generate(4, (index) {
                                duration += 50;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                  child: Hero(
                                    tag: parks[index],
                                    transitionOnUserGestures: true,
                                    child: AnimatedScale(
                                      scale: animate ? 1 : 0.7,
                                      curve: Curves.easeInOutCubic,
                                      duration: Duration(milliseconds: duration),
                                      child: AnimatedOpacity(
                                        opacity: animate ? 1 : 0,
                                        curve: Curves.easeInCubic,
                                        duration: Duration(milliseconds: duration - 100),
                                        child: AnimatedSlide(
                                          offset: Offset(animate ? 0 : 2, 0),
                                          curve: Curves.easeOutCubic,
                                          duration: Duration(milliseconds: duration),
                                          child: Card(
                                            elevation: 4,
                                            shadowColor: Colors.lightBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25.7)
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: InkWell(
                                              splashColor: Colors.lightBlue.withOpacity(0.5),
                                              highlightColor: Colors.lightBlue.withOpacity(0.25),
                                              onTap: () {
                                                Future.delayed(const Duration(milliseconds: 150)).then((value) {
                                                  Navigator.of(context).pushNamed('/recreation/pool');
                                                });
                                              },
                                              child: Ink.image(
                                                height: 400,
                                                width: 230,
                                                image: AssetImage('images/${parks[index]}'),
                                                fit: BoxFit.cover,
                                                child: Container(
                                                  foregroundDecoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      stops: const [0.65, 1.0, 1.2],
                                                      colors: [ 
                                                        Colors.transparent,
                                                        Colors.lightBlue.withOpacity(0.2),
                                                        Colors.lightBlue
                                                      ]
                                                    )
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Text(parksNames[index],
                                                        style: GoogleFonts.varelaRound(
                                                          color: Colors.white,
                                                          fontSize: 34,
                                                          fontWeight: FontWeight.w600,
                                                          shadows: [ 
                                                            const Shadow(
                                                              color: Colors.black38,
                                                              offset: Offset(1, 1),
                                                              blurRadius: 2
                                                            )
                                                          ]
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: AnimatedOpacity(
                            opacity: animate ? 1 : 0,
                            curve: Curves.easeInCubic,
                            duration: Duration(milliseconds: duration - 100),
                            child: AnimatedSlide(
                              offset: Offset(animate ? 0 : 2, 0),
                              curve: Curves.easeOutCubic,
                              duration: Duration(milliseconds: duration),
                              child: Row(
                                children: [
                                  Icon(
                                    size: 28,
                                    color: Colors.grey.shade700,
                                    Icons.storefront
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Fasilitas  /  Tempat',
                                    style: GoogleFonts.rubik(
                                      letterSpacing: -0.5,
                                      fontSize: 22,
                                      color: Colors.grey.shade700
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 300,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(18, 0, 12, 0),
                            scrollDirection: Axis.horizontal,
                            children: List.generate(facilities.length, (index) {
                              duration += 50;
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: AnimatedOpacity(
                                  opacity: animate ? 1 : 0,
                                  curve: Curves.easeInCubic,
                                  duration: Duration(milliseconds: duration - 100),
                                  child: AnimatedSlide(
                                    offset: Offset(animate ? 0 : 2, 0),
                                    curve: Curves.easeOutCubic,
                                    duration: Duration(milliseconds: duration),
                                    child: Card(
                                      elevation: 4,
                                      shadowColor: Colors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.7)
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () {},
                                        onHover: (value) {},
                                        splashColor: Colors.lightGreen.withOpacity(0.5),
                                        highlightColor: Colors.lightGreen.withOpacity(0.25),
                                        child: Stack(
                                          children: [ 
                                            Ink.image(
                                              height: 300,
                                              width: 300,
                                              image: AssetImage('images/${facilitiesNames[index]}'),
                                              fit: BoxFit.cover
                                            ),
                                            Container(
                                              width: 300,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  stops: const [0.65, 1.0, 1.2],
                                                  colors: [ 
                                                    Colors.transparent,
                                                    Colors.lightGreen.withOpacity(0.2),
                                                    Colors.lightGreen
                                                  ]
                                                )
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade800,
                                                  borderRadius: BorderRadius.circular(12)
                                                ),
                                                child: Text(facilities[index], 
                                                  style: GoogleFonts.varelaRound(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600
                                                  )
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(16, 16, 16 ,8),
                                                child: ElevatedButton.icon(
                                                  style: ButtonStyle(
                                                    shape: MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.7))
                                                    ),
                                                    backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                                    foregroundColor: MaterialStatePropertyAll(Colors.grey.shade800)
                                                  ),
                                                  onPressed: () {}, 
                                                  icon: const Icon(Icons.location_on), 
                                                  label: Text('Cari Lokasi', 
                                                    style: GoogleFonts.varelaRound(
                                                      height: 0,
                                                      color: Colors.grey.shade800,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600
                                                    )
                                                  ),
                                                )
                                              ),
                                            ),
                                          ]
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
                            child: Text('Apabila ada hal yang ingin dipertanyakan silakan hubungi langsung melalui kontak Whatsapp Pentungan Sari.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.varelaRound(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
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
          );
        }
      ),
    );
  }
}
