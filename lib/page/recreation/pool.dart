import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pentungan_sari/assets/dialog.dart';

class PoolPage extends StatefulWidget {
  const PoolPage({super.key});

  @override
  State<PoolPage> createState() => _PoolPageState();
}

class _PoolPageState extends State<PoolPage> {

  late PageController _pageController;
  late ScrollController _scrollController;
  int page = 0;
  bool pageScrolled = false, bottomPage = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: page);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 320 && pageScrolled == false) {
        setState(() {
          pageScrolled = true;
        });
      } else if (_scrollController.offset < 320 && pageScrolled == true) { 
        setState(() {
          pageScrolled = false;
        });      
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: pageScrolled ? true : false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  leadingWidth: 120,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 30),
                      Container(
                        margin: const EdgeInsets.all(2),
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: InkWell(
                          onTap: () { Navigator.of(context).pop(); },
                          child: Icon(
                            color: Colors.grey.shade600,
                            Icons.arrow_back,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  toolbarHeight: 100,
                  expandedHeight: 450,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'pool_1.jpg',
                          child: GestureDetector(
                            onTap: () { 
                              showDialogImage(context, 'images/pool_${page + 1}.jpg', 'pool_1.jpg'); 
                            },
                            child: PageView.builder(
                              onPageChanged: (value) {
                                setState(() {
                                  page = value;
                                });
                              },
                              controller: _pageController,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  'images/pool_${index + 1}.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16)
                              )
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(FontAwesomeIcons.waterLadder, color: Colors.blue, size: 18),
                                const SizedBox(width: 12),
                                Text('KOLAM', 
                                  style: GoogleFonts.rubik(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    wordSpacing: -0.25,
                                    color: Colors.grey.shade600
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade100,
                                      border: page == index ? Border.all(
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                        color: Colors.lightBlue, 
                                        width: 3
                                      ) : Border.all(color: Colors.grey.shade100, width: 2)
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Theme(
              data: ThemeData(
                useMaterial3: true,
                listTileTheme: ListTileThemeData(
                  dense: true,
                  tileColor: Colors.blue.shade50.withOpacity(0.25),
                  iconColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  titleTextStyle: GoogleFonts.signikaNegative(
                    color: Colors.blue.shade600,
                    height: 1.5,
                  ),
                  leadingAndTrailingTextStyle: GoogleFonts.signikaNegative(
                    color: Colors.blue.shade600,
                    height: 1.5,
                    fontSize: 18
                  )
                )
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400), 
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: pageScrolled 
                    ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [ 
                                  Colors.grey.shade50,
                                  Colors.transparent
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [ 0.2, 1.0 ]
                              ),
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'images/pool_${page + 1}.jpg',
                                )
                              )
                            ),
                          ),
                        ),
                      ),
                    )
                    : null,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(28, pageScrolled ? 24 : 14, 28, 28),
                          shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedSize(
                                  alignment: Alignment.centerLeft,
                                  duration: const Duration(milliseconds: 300),
                                  child: SizedBox(
                                    width: null,
                                    height: pageScrolled ? null : 0,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 400), 
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                      child: pageScrolled
                                      ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }, 
                                            style: ButtonStyle(
                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                                              backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                              foregroundColor: MaterialStatePropertyAll(Colors.grey.shade600)
                                            ),
                                            icon: const Icon(Icons.arrow_back)
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(FontAwesomeIcons.waterLadder, color: Colors.blue, size: 18),
                                          const SizedBox(width: 12),
                                          Text('KOLAM', 
                                            style: GoogleFonts.rubik(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              wordSpacing: -0.25,
                                              color: Colors.grey.shade600
                                            )
                                          ),
                                        ],
                                      )
                                      : null,
                                    ),
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 400),
                                  child: SizedBox(height: pageScrolled ? 16 : 0)
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.height, color: Colors.grey.shade600),
                                        const SizedBox(width: 8),
                                        Text('Kedalaman: 1 m - 1.5 m', 
                                          style: GoogleFonts.rubik(
                                            fontSize: 18,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ]
                                    ),
                                    IconButton(
                                      onPressed: () {}, 
                                      icon: Icon(Icons.favorite_outline, color: Colors.grey.shade600)
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text('Kolam pentungan sari merupakan lahan yang dibuat untuk menampung air dalam jumlah tertentu sehingga dapat digunakan untuk wisata berenang.', 
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    height: 1.5
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text('Sejarah munculnya Pentungan Sari, adalah ketika para warga mengurutkan jumlah dari sumber air tersebut, ditemukan sumber dengan air yang sangat bersih. Warga sekitar menganggap sumber dengan air yang jernih tersebut sebagai sari atau inti dari air yang mengalir ke Pentungan Berek.', 
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    height: 1.5
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text('Peraturan',
                                  style: GoogleFonts.rubik(
                                    color: Colors.grey.shade600,
                                    wordSpacing: -0.25,
                                    fontSize: 16,
                                    height: 1.5
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(14, 12, 22, 12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.face,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 16),
                                              Text('Usia / Umur', 
                                                style: GoogleFonts.varelaRound(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue.shade600,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]
                                          ),
                                          Text('8 Tahun', 
                                            style: GoogleFonts.nunito(
                                              color: Colors.blue.shade600,
                                              fontSize: 16,
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(14, 12, 22, 12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.accessibility,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 16),
                                              Text('Tinggi Badan', 
                                                style: GoogleFonts.varelaRound(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue.shade600,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]
                                          ),
                                          Text('120cm', 
                                            style: GoogleFonts.nunito(
                                              color: Colors.blue.shade600,
                                              fontSize: 16,
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Dibawah Pengawasan Orang Tua / Wali',
                                          style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.info, color: Colors.grey, size: 16),
                                        const SizedBox(width: 4),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text('Fasilitas',
                                  style: GoogleFonts.rubik(
                                    color: Colors.grey.shade600,
                                    wordSpacing: -0.25,
                                    fontSize: 16,
                                    height: 1.5
                                  ),
                                ),
                                const SizedBox(height: 8),
                                PhysicalShape(
                                  color: Colors.transparent,
                                  elevation: 4,
                                  shadowColor: Colors.black38,
                                  clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                      onTap: () {},
                                      tileColor: Colors.white,
                                      splashColor: Colors.blue.shade100,
                                      dense: false,
                                      contentPadding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset('images/ban_pelampung.jpg',
                                          fit: BoxFit.cover,
                                          width: 72,
                                          height: 144,
                                        ),
                                      ),
                                      title: Text('Ban Pelampung',
                                        style: GoogleFonts.varelaRound(
                                          color: Colors.grey.shade600,
                                          height: 1.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                        ),
                                      ),
                                      subtitle: Text('Alat Renang',
                                        style: GoogleFonts.roboto(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade400,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Text('Rp. 5.000',
                                          style: GoogleFonts.signikaNegative(
                                            color: Colors.white,
                                            height: 0,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                PhysicalShape(
                                  color: Colors.transparent,
                                  elevation: 4,
                                  shadowColor: Colors.black38,
                                  clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                      onTap: () {},
                                      tileColor: Colors.white,
                                      splashColor: Colors.blue.shade100,
                                      dense: false,
                                      contentPadding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset('images/papan_pelampung.jpg',
                                          fit: BoxFit.cover,
                                          width: 72,
                                          height: 144,
                                        ),
                                      ),
                                      title: Text('Papan Pelampung',
                                        style: GoogleFonts.varelaRound(
                                          color: Colors.grey.shade600,
                                          height: 1.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                        ),
                                      ),
                                      subtitle: Text('Alat Renang',
                                        style: GoogleFonts.roboto(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade400,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Text('Rp. 5.000',
                                          style: GoogleFonts.signikaNegative(
                                            color: Colors.white,
                                            height: 0,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        color:  Colors.white,
                        surfaceTintColor: Colors.white,
                        elevation: 20,
                        shadowColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  onPressed: () {}, 
                                  style: ButtonStyle(
                                    elevation: const MaterialStatePropertyAll(0),
                                    backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
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
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
