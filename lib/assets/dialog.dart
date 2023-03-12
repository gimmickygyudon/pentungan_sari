import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pentungan_sari/assets/object.dart';
import 'package:pentungan_sari/function/string.dart';

import '../function/builder.dart';

void showDialogImage(BuildContext context, String image, String tag, [Function? animating]) {
  if (animating != null) animating(false);
  Navigator.of(context).push(
    PageRouteBuilder(
      barrierColor: Colors.black87,
      opaque: false,
      barrierDismissible: true,
      fullscreenDialog: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ShowDialogImage(tag: tag, image: image, animating: animating);
      }
    )
  );
}

class ShowDialogImage extends StatelessWidget {
  const ShowDialogImage({
    super.key, 
    required this.tag, 
    required this.image, 
    required this.animating
  });

  final String tag, image;
  final Function? animating;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) { 
          if (animating != null) animating!(true);
        });
        return true;
      },
      child: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: GestureDetector(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) { 
                if (animating != null) animating!(true);
              });
              Navigator.pop(context);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Hero(
                      tag: tag,
                      child: Image.asset(
                        image, 
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: IconButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) { 
                          if (animating != null) animating!(true);
                        });
                        Navigator.pop(context);
                      }, 
                      style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(EdgeInsets.all(6)),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        elevation: const MaterialStatePropertyAll(8),
                        shadowColor: const MaterialStatePropertyAll(Colors.black45),
                        backgroundColor: const MaterialStatePropertyAll(Colors.white),
                        iconSize: const MaterialStatePropertyAll(28)
                      ),
                      icon: const Icon(Icons.close)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showDialogEvent(BuildContext context, String tag, DateTime now) {
  Navigator.push(context, PageRouteBuilder(
    fullscreenDialog: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black87,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ShowDialogEvent(tag: tag, now: now);
    })
  );
}

class ShowDialogEvent extends StatefulWidget {
  const ShowDialogEvent({
    super.key, 
    required this.tag, 
    required this.now
  });

  final String tag;
  final DateTime now;

  @override
  State<ShowDialogEvent> createState() => _ShowDialogEventState();
}

class _ShowDialogEventState extends State<ShowDialogEvent> {

  late String fromDate, toDate;
  String date = DateFormat('EEEE, dd MMMM yyyy', 'id').format(DateTime.now());
  DateTime rawDate = DateTime.now();

  late TextEditingController _textTitleController, _textGuestController;
  late FocusNode _textTitleFocusNode, _textDescriptionFocusNode;
  final GlobalKey<State<StatefulWidget>> _countButtonKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<TooltipState> _validateTooltipKey = GlobalKey<TooltipState>();

  List<Map<String, dynamic>> items = [];

  String selectedLocation = 'Pendopo';

  bool expandDescription = false, oneday = false;
  int page = 0, validate = 0;

  late PageController _pageController;

  @override
  void initState() {
    fromDate = '${DateFormat('hh').format(DateTime.now())}:00';
    String toDate_ = (int.parse(DateFormat('hh').format(DateTime.now())) + 3).toString();
    if (toDate_.length == 1) toDate_ = '0$toDate_';
    toDate = '$toDate_:00';

    _textGuestController = TextEditingController(text: '10');
    _textTitleController = TextEditingController();
    _textDescriptionFocusNode = FocusNode();
    _textTitleFocusNode = FocusNode()..addListener(() {
      if (_textTitleFocusNode.hasFocus == false) _textTitleController.text = _textTitleController.text.trim().toTitle();
    });
    _pageController = PageController(initialPage: page);

    updateValidate();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textGuestController.dispose();
    _textTitleController.dispose();
    _textTitleFocusNode.dispose();
    super.dispose();
  }

  void updateValidate() {
    int count = 0;
    if (_textTitleController.text.trim().isNotEmpty) {
      count++; 
    }

    if (_textGuestController.text == '0') { 
      _textGuestController.value = _textGuestController.value.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }
    if (_textGuestController.text.trim().isNotEmpty || _textGuestController.text != '0') {
      count++; 
      for (int i = 0; i < _textGuestController.text.length; i++) {
        if (_textGuestController.text.substring(0, i) == '0') { 
          _textGuestController.text = _textGuestController.text.substring(1, _textGuestController.text.length);
          _textGuestController.selection = TextSelection.fromPosition(const TextPosition(offset: 1));
        }
      }
    }
    
    validate = count;
    _countButtonKey.currentState?.setState(() {});
  }

  void selectLocation(String location) => setState(() => selectedLocation = location);
  void selectItems(String name, bool select) {
    items.clear();
    int i = 0;

    for (var element in addons) {
      if (element['selected'] == true) {
        items.add(addons[i]);
      }
      i++;
    }
  }

  void changeLocation(String index, int price, String item) => locations[locations.indexWhere((element) => element['name'] == index)][item] = price;
  void changeItems(int index, String item, dynamic value) => addons[index][item] = value;
  void changeGuest(int value) => _textGuestController.text = value.toString();
  
  void setTimerFrom(String time) => setState(() => fromDate = time);
  void setTimerTo(String time) => setState(() => toDate = time);

  void setDate(DateTime now) {
    setState(() {
      rawDate = now;
      date = DateFormat('EEEE, dd MMMM yyyy', 'id').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: ThemeData(
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
            labelStyle: GoogleFonts.varelaRound(
              letterSpacing: -0.25,
              color: Colors.grey,
              fontSize: 24,
            ),
            counterStyle: GoogleFonts.nunito(
              color: Colors.grey,
              fontWeight: FontWeight.w700
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 2
              )
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.lightGreen,
                width: 2
              )
            ),
            alignLabelWithHint: true
          ),
        ),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          padding: EdgeInsets.symmetric(
            vertical : MediaQuery.of(context).viewInsets.bottom == 0 
            ? expandDescription ? 24 : 36 : 0
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Hero(
                tag: widget.tag,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(
                        MediaQuery.of(context).viewInsets.bottom == 0 ? 16 : 0
                      ),
                      bottomRight: Radius.circular(
                        MediaQuery.of(context).viewInsets.bottom == 0 ? 16 : 0
                      )
                    ),
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Material(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          elevation: 2,
                          shadowColor: Colors.black45,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PhysicalModel(
                                elevation: 4,
                                color: Colors.transparent,
                                shadowColor: page == 1 ? Colors.lightGreen.withOpacity(0.5) : Colors.blue.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                child: AnimatedContainer(
                                  curve: Curves.easeInOutCubic,
                                  duration: const Duration(milliseconds: 400),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: page == 1 
                                        ? [ Colors.lightGreen.shade200, Colors.lightGreen.shade700 ] 
                                        : [ Colors.blue.shade200, Colors.blue.shade700 ],
                                      stops: const [ 0.2, 1.0 ]
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16), topLeft: Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      opacity: 0.05,
                                      fit: BoxFit.cover,
                                      image: AssetImage('images/${locations[locations.indexWhere((element) => element['name'] == selectedLocation)]['image']}')
                                    )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(32, 18, 32, 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () => page == 0 ? Navigator.of(context).pop() : null,
                                              child: Row(
                                                children: [
                                                  Icon(page == 1 
                                                    ? Icons.receipt_long : Icons.control_point_duplicate_outlined, color: Colors.grey.shade50, 
                                                    shadows: const [
                                                      Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 1))
                                                    ]
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(page == 1 ? 'Harga Acara' : 'Tambah Acara', 
                                                    style: GoogleFonts.rubik(
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: -0.5,
                                                      wordSpacing: 4,
                                                      color: Colors.grey.shade50,
                                                      shadows: [ 
                                                        const Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 1))
                                                      ]
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(color: page == 0 ? Colors.blue.shade200 : Colors.lightGreen.shade200, width: 3)
                                                  ),
                                                  child: Transform.scale(
                                                    scale: 0.75,
                                                    child: Image.asset('images/bumdes.png', filterQuality: FilterQuality.none, scale: 0.05, height: 46)
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(color: page == 0 ? Colors.blue.shade200 : Colors.lightGreen.shade200, width: 3)
                                                  ),
                                                  child: Transform.scale(
                                                    scale: 0.75,
                                                    child: Image.asset('images/toyomarto.png', filterQuality: FilterQuality.none, scale: 0.05, height: 54))),
                                              ]
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 400),
                                              child: page == 0 ? TextButton.icon(
                                                onPressed: () {
                                                  setState(() {
                                                    expandDescription 
                                                      ? expandDescription = false 
                                                      : expandDescription = true;
                                                  });
                                                  WidgetsBinding.instance.addPostFrameCallback((_) => _textDescriptionFocusNode.requestFocus());
                                                },
                                                style: ButtonStyle(
                                                  padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  textStyle: MaterialStatePropertyAll(
                                                    GoogleFonts.rubik(letterSpacing: -0.25, fontSize: 16)
                                                  ),
                                                  iconSize: const MaterialStatePropertyAll(16),
                                                  foregroundColor: MaterialStatePropertyAll(expandDescription ? Colors.grey.shade50 : Colors.grey.shade200)
                                                ),
                                                icon: Icon(expandDescription ? Icons.event_note : Icons.event_note_outlined),
                                                label: const Text('Notes')
                                              ) : Icon(Icons.more_horiz, color: expandDescription ? Colors.grey.shade50 : Colors.grey.shade200),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  child: ExpandablePageView(
                                    controller: _pageController,
                                    onPageChanged: (value) => setState(() => page = value),
                                    itemCount: 2,
                                    itemBuilder: (context, index) {
                                      final Widget addEvent = Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              focusNode: _textTitleFocusNode,
                                              controller: _textTitleController,
                                              onChanged: (value) {
                                                updateValidate();
                                              },
                                              maxLength: 40,
                                              style: GoogleFonts.rubik(
                                                letterSpacing: -0.25,
                                                fontSize: 24,
                                                height: 1.75
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                                                label: Transform.translate(
                                                  offset: const Offset(-4, 0),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.text_fields, color: Colors.lightGreen, size: 26),
                                                      SizedBox(width: 6),
                                                      Text('Judul'),
                                                    ],
                                                  ),
                                                ),
                                                labelStyle: GoogleFonts.varelaRound(
                                                  letterSpacing: -0.25,
                                                  color: Colors.lightGreen,
                                                  fontSize: 24,
                                                ),
                                                hintText: 'Nama Acara',
                                                hintStyle: GoogleFonts.rubik(
                                                  color: Colors.grey.shade300,
                                                  letterSpacing: -0.25,
                                                  fontSize: 24,
                                                  height: 1.75
                                                ),
                                                floatingLabelBehavior: FloatingLabelBehavior.always
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: DropdownButtonFormField(
                                                    value: selectedLocation,
                                                    onChanged: (value) {
                                                      setState(() => selectedLocation = value!);
                                                      showLocationItem(context, 'location', selectedLocation,
                                                        int.tryParse(_textGuestController.text), locations[locations.indexWhere((element) => element['name'] == selectedLocation)]['image'], 
                                                        locations[locations.indexWhere((element) => element['name'] == selectedLocation)]['price'], changeLocation, changeGuest
                                                      );
                                                    },
                                                    borderRadius: BorderRadius.circular(18),
                                                    elevation: 2,
                                                    dropdownColor: Colors.grey.shade100,
                                                    decoration: InputDecoration(
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      contentPadding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
                                                      label: Transform.translate(
                                                        offset: const Offset(-4, -14),
                                                        child: const Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(Icons.location_on, color: Colors.lightBlue),
                                                            SizedBox(width: 6),
                                                            Text('Lokasi'),
                                                          ],
                                                        ),
                                                      ),
                                                      labelStyle: GoogleFonts.varelaRound(
                                                        letterSpacing: -0.25,
                                                        color: Colors.lightBlue,
                                                        fontSize: 24,
                                                      ),
                                                      focusedBorder: const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.lightBlue,
                                                          width: 2
                                                        )
                                                      ),
                                                    ),
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.black,
                                                      letterSpacing: -0.25,
                                                      fontSize: 24,
                                                    ),
                                                    items: locations.map((value) {
                                                      final widget = DropdownMenuItem<String>(
                                                        value: value['name'],
                                                        child: Text(value['name'])
                                                      );
                                                      return widget;
                                                    }).toList(),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: IntrinsicWidth(
                                                    child: TextFormField(
                                                      controller: _textGuestController,
                                                      onChanged: (value) {
                                                        updateValidate();
                                                      },
                                                      style: GoogleFonts.rubik(
                                                        letterSpacing: -0.25,
                                                        fontSize: 24,
                                                      ),
                                                      maxLength: 3,
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter.digitsOnly
                                                      ],
                                                      enableInteractiveSelection: false,
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                                        counterText: '',
                                                        labelText: 'Tamu',
                                                        suffixText: ' Orang',
                                                        suffixStyle: GoogleFonts.rubik(
                                                          color: Colors.grey.shade800,
                                                          letterSpacing: -0.25,
                                                          fontSize: 24,
                                                          height: 1.75
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                                          borderRadius: BorderRadius.circular(12)
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(color: Colors.lightGreen, width: 2),
                                                          borderRadius: BorderRadius.circular(12)
                                                        ),
                                                        floatingLabelBehavior: FloatingLabelBehavior.always
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Wrap(
                                                spacing: 8,
                                                children: List.generate(addons.length, (index) {
                                                  return FilterChip(
                                                    backgroundColor: addons[index]['selected'] ? addons[index]['color'].withOpacity(0.075) : Colors.grey.withOpacity(0.025),
                                                    padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
                                                    labelPadding: const EdgeInsets.only(left: 2),
                                                    labelStyle: GoogleFonts.rubik(
                                                      color: addons[index]['selected'] ? addons[index]['color'] : Colors.grey.shade400, 
                                                      fontSize: 16,
                                                      fontWeight: addons[index]['selected'] ? FontWeight.w500 : FontWeight.w400,
                                                      height: 1, 
                                                      letterSpacing: addons[index]['selected'] ? -0.5 : -0.25
                                                    ),
                                                    label: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(addons[index]['selected'] 
                                                          ? addons[index]['withicon'] 
                                                          : addons[index]['icon'], color: addons[index]['selected'] ? addons[index]['color'] : Colors.grey.shade400),
                                                        const SizedBox(width: 4),
                                                        Text(addons[index]['name']),
                                                      ],
                                                    ),
                                                    side: BorderSide(color: addons[index]['selected'] ? addons[index]['color'] : Colors.grey.shade300),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    onSelected: (value) { 
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                      void selectItem(bool e) {
                                                        setState(() {
                                                          addons[index]['selected'] = e;
                                                          selectItems(addons[index]['name'], e);
                                                        });
                                                      }

                                                      void changeItem(String item, dynamic value) {
                                                        changeItems(index, item, value);
                                                      }

                                                      int duration = int.parse(toDate.substring(0, 2)) - int.parse(fromDate.substring(0, 2));
                                                      if (addons[index]['duration'] != null) duration = addons[index]['duration'];

                                                      showChangeItem(context, 
                                                        addons[index]['name'], addons[index]['name'], duration,
                                                        addons[index]['withicon'], addons[index]['color'], addons[index]['price'],
                                                      selectItem, changeItem);
                                                    },
                                                  );
                                                }),
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Transform.translate(
                                                  offset: const Offset(-2, 0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Icon(Icons.schedule, color: Colors.orange, size: 20, fill: 1.0),
                                                      const SizedBox(width: 6),
                                                      Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            const TextSpan(text: 'Tanggal'),
                                                            TextSpan(text: ' & ', 
                                                              style: GoogleFonts.rubik(
                                                                letterSpacing: -0.25,
                                                                color: Colors.orange,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            const TextSpan(text: 'Waktu'),
                                                          ]
                                                        ),
                                                        style: GoogleFonts.varelaRound(
                                                          letterSpacing: -0.25,
                                                          color: Colors.orange,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      oneday 
                                                      ? oneday = false
                                                      : oneday = true;
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text('Seharian', 
                                                        style: GoogleFonts.rubik(
                                                          color: oneday ? Colors.orange.shade600 : Colors.grey.shade600, 
                                                          fontSize: 18, 
                                                          fontWeight: oneday ? FontWeight.w600 : FontWeight.w500,
                                                          height: 1, 
                                                          letterSpacing: -0.5
                                                        )
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Transform.scale(
                                                        scale: 0.85,
                                                        child: Switch(
                                                          activeTrackColor: Colors.orange,
                                                          inactiveTrackColor: Colors.grey.shade200,
                                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                          value: oneday,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              oneday = value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            OutlinedButton(
                                              onPressed: () {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                showPickDate(context, rawDate, setDate); 
                                              },
                                              style: ButtonStyle(
                                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                side: MaterialStatePropertyAll(BorderSide(color: oneday ? Colors.orange : Colors.black38)),
                                                elevation: const MaterialStatePropertyAll(3),
                                                shadowColor: const MaterialStatePropertyAll(Colors.black54),
                                                textStyle: MaterialStatePropertyAll(
                                                  GoogleFonts.rubik(
                                                    fontSize: 18,
                                                    letterSpacing: -0.25,
                                                    wordSpacing: 4
                                                  )
                                                ),
                                                padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
                                                overlayColor: MaterialStatePropertyAll(Colors.orange.shade100),
                                                backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                                foregroundColor: const MaterialStatePropertyAll(Colors.black),
                                                alignment: Alignment.centerLeft
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(date),
                                                    Row(
                                                      children: [
                                                        const VerticalDivider(color: Colors.grey),
                                                        const SizedBox(width: 8),
                                                        Icon(Icons.edit_calendar, color: Colors.grey.shade700),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ),
                                            AnimatedSize(
                                              curve: Curves.ease,
                                              duration: const Duration(milliseconds: 600),
                                              child: SizedBox(height: oneday ? 4 : 16)
                                            ),
                                            AnimatedSize(
                                              curve: Curves.ease,
                                              duration: const Duration(milliseconds: 300),
                                              child: SizedBox(
                                                height: oneday ? 0 : null,
                                                width: null,
                                                child: Row(
                                                  children: [ 
                                                    Expanded(
                                                      flex: 4,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          showPickTime(context, setTimerFrom, TimeOfDay(hour:int.parse(fromDate.split(":")[0]),minute: int.parse(fromDate.split(":")[1])));
                                                        }, 
                                                        style: ButtonStyle(
                                                          alignment: Alignment.centerLeft,
                                                          elevation: const MaterialStatePropertyAll(0),
                                                          shadowColor: MaterialStatePropertyAll(Colors.grey.shade100),
                                                          side: MaterialStatePropertyAll(BorderSide(color: Colors.grey.shade400)),
                                                          shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                                          ),
                                                          padding: const MaterialStatePropertyAll(EdgeInsets.fromLTRB(18, 14, 12, 14)),
                                                          overlayColor: MaterialStatePropertyAll(Colors.orange.shade100),
                                                          foregroundColor: const MaterialStatePropertyAll(Colors.black),
                                                          backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                                          textStyle: MaterialStatePropertyAll(
                                                            GoogleFonts.rubik(
                                                              fontSize: 18,
                                                            )
                                                          )
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('Dari: ', style: GoogleFonts.rubik(color: Colors.grey)),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(fromDate),
                                                                const SizedBox(width: 2),
                                                                oneday ? const SizedBox() : const Icon(Icons.arrow_drop_down)
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      flex: 5,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          showPickTime(context, setTimerTo, TimeOfDay(hour:int.parse(toDate.split(":")[0]),minute: int.parse(toDate.split(":")[1])));
                                                        }, 
                                                        style: ButtonStyle(
                                                          alignment: Alignment.centerLeft,
                                                          elevation: const MaterialStatePropertyAll(0),
                                                          shadowColor: MaterialStatePropertyAll(Colors.grey.shade100),
                                                          side: MaterialStatePropertyAll(BorderSide(color: Colors.grey.shade400)),
                                                          shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                                          ),
                                                          padding: const MaterialStatePropertyAll(EdgeInsets.fromLTRB(18, 14, 12, 14)),
                                                          overlayColor: MaterialStatePropertyAll(Colors.orange.shade100),
                                                          foregroundColor: const MaterialStatePropertyAll(Colors.black),
                                                          backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                                          textStyle: MaterialStatePropertyAll(
                                                            GoogleFonts.rubik(
                                                              fontSize: 18,
                                                            )
                                                          )
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('Sampai: ', style: GoogleFonts.rubik(color: Colors.grey)),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(toDate),
                                                                const SizedBox(width: 2),
                                                                oneday ? const SizedBox() : const Icon(Icons.arrow_drop_down)
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ),
                                                    ),
                                                  ]
                                                ),
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.ease,
                                              height: expandDescription ? 32 : 8,
                                            ),
                                            AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 100),
                                              child: expandDescription ? TextField(
                                                focusNode: _textDescriptionFocusNode,
                                                style: GoogleFonts.rubik(
                                                  letterSpacing: -0.25,
                                                  fontSize: 24,
                                                  height: 1.75
                                                ),
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
                                                  label: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.event_note_outlined, color: Colors.blueGrey.shade500, size: 24),
                                                      const SizedBox(width: 8),
                                                      Text('Keterangan', 
                                                        style: GoogleFonts.rubik(
                                                          height: -0.1,
                                                          color: Colors.blueGrey,
                                                          fontSize: 24,
                                                        ),
                                                      )
                                                    ]
                                                  ),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: BorderSide(color: Colors.grey.shade400)
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(color: Colors.lightGreen, width: 2)
                                                  ),
                                                  alignLabelWithHint: false
                                                ),
                                              ) : null,
                                            ),
                                          ],
                                        ),
                                      );
                                      switch (index) {
                                        case 0:
                                          return addEvent;
                                        case 1:
                                          return ResultEvent(
                                            title: _textTitleController.text,
                                            locations: locations[locations.indexWhere((element) => element['name'] == selectedLocation)],
                                            people: int.parse(_textGuestController.text),
                                            date: date,
                                            items: items,
                                            duration: int.parse(toDate.substring(0, 2)) - int.parse(fromDate.substring(0, 2)),
                                          );
                                        default:
                                          return addEvent;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (page == 1) {
                                          _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(2),
                                        shadowColor: const MaterialStatePropertyAll(Colors.black45),
                                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
                                        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
                                        backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                        foregroundColor: const MaterialStatePropertyAll(Colors.grey),
                                        textStyle: MaterialStatePropertyAll(
                                          GoogleFonts.varelaRound(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)
                                          )
                                        )
                                      ),
                                      child: Text(page == 1 ? 'Kembali' : 'Batal')
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: StatefulBuilder(
                                      key: _countButtonKey,
                                      builder: (context, setState) {
                                        return TooltipVisibility(
                                          visible: validate == 2 ? false : true,
                                          child: Tooltip(
                                            key: _validateTooltipKey,
                                            richMessage: TextSpan(
                                              style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                                              text: ' ${
                                                validate == 1 ? 'Satu' 
                                                : validate == 0 ? 'Dua' : 'Satu'
                                              } dari persyaratan berikut perlu diisi \n',
                                              children: [
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 2),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(_textTitleController.text.isNotEmpty 
                                                              ? Icons.check_circle
                                                              : Icons.circle_outlined, size: 20, 
                                                              color: _textTitleController.text.isNotEmpty ? Colors.lightGreen : Colors.grey.shade200
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Text('Judul Acara / Kegiatan / Agenda', 
                                                              style: TextStyle(
                                                                fontSize: 16, 
                                                                color: _textTitleController.text.isNotEmpty ? Colors.lightGreen : Colors.grey.shade200
                                                              )
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(_textGuestController.text.isNotEmpty
                                                              ? Icons.check_circle
                                                              : Icons.circle_outlined, 
                                                              size: 20, 
                                                              color: _textGuestController.text.isNotEmpty ? Colors.lightGreen : Colors.grey.shade200
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Text('Jumlah Tamu / Pengunjung', 
                                                              style: TextStyle(
                                                                fontSize: 16, 
                                                                color: _textGuestController.text.isNotEmpty ? Colors.lightGreen : Colors.grey.shade200
                                                              )
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ),
                                              ]
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade800,
                                              borderRadius: BorderRadius.circular(12)
                                            ),
                                            child: ElevatedButton(
                                              onPressed: validate == 2 && page == 0 ? () {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                              } : () => _validateTooltipKey.currentState?.ensureTooltipVisible(),
                                              style: ButtonStyle(
                                                elevation: MaterialStatePropertyAll(validate != 2 ? 0 : 2),
                                                shadowColor: const MaterialStatePropertyAll(Colors.black45),
                                                padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
                                                backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                  return validate != 2 
                                                    ? Colors.grey.shade300 
                                                    : page == 0 ? Colors.lightBlue : Colors.lightGreen;
                                                }),
                                                overlayColor: MaterialStateProperty.resolveWith((states) {
                                                  return validate != 2 ? Colors.transparent : null;
                                                }),
                                                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                                textStyle: MaterialStatePropertyAll(
                                                  GoogleFonts.varelaRound(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600
                                                  )
                                                ),
                                                shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12)
                                                  )
                                                )
                                              ),
                                              child: Text(page == 1 ? 'Buat' : 'Biaya')
                                            ),
                                          ),
                                        );
                                      }
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultEvent extends StatefulWidget {
  const ResultEvent({
    super.key, 
    required this.title, 
    required this.date, 
    required this.people, 
    required this.items, 
    required this.duration,
    required this.locations
  });

  final String title, date;
  final int people, duration;

  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> locations;

  static const _locale = 'id';

  @override
  State<ResultEvent> createState() => _ResultEventState();
}

class _ResultEventState extends State<ResultEvent> {
  String _formatNumber(String s) => NumberFormat.decimalPattern(ResultEvent._locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: ResultEvent._locale).currencySymbol;

  int subtotal = 0, total = 0;

  bool isPaid = false;

  @override
  void initState() {
    for (int i = 0; i < widget.items.length; i++) {
      subtotal += countItemPrice(i);
    }
    super.initState();
  }

  int countItemPrice(int index) {
    int total, duration = widget.duration;
    
    if (widget.items[index]['duration'] != null) duration = widget.items[index]['duration'];

    widget.items[index]['name'] == 'Listrik' || widget.items[index]['name'] == 'Speaker'
      ? total = widget.items[index]['price'] * duration
      : total = widget.items[index]['price'] * widget.people;

    return total;
  }

  @override
  Widget build(BuildContext context) {
    total = subtotal + ((widget.people * widget.locations['price'] as int) * 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          minVerticalPadding: 14,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.title.trim()),
          ),
          titleTextStyle: GoogleFonts.rubik(
            color: Colors.grey.shade800,
            letterSpacing: -0.25,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          subtitle: Text(widget.date, 
            style: GoogleFonts.rubik(color: Colors.grey.shade600)
          ),
          subtitleTextStyle: GoogleFonts.rubik(
            fontSize: 16,
            letterSpacing: -0.25,
            wordSpacing: 4
          ),
          trailing: FilterChip(
            avatar: isPaid 
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.schedule, color: Colors.red),
            label: Text(isPaid ? 'Lunas' : 'Belum Dibayar'),
            labelStyle: GoogleFonts.rubik(),
            backgroundColor: isPaid ? Colors.green.withOpacity(0.05) : null,
            side: BorderSide(color: isPaid ? Colors.green.shade300 : Colors.grey.shade300),
            selected: false,
            onSelected: (value) {
              setState(() {
                isPaid ? isPaid = false : isPaid = true;
              });
            },
          ),
        ),
        Visibility(
          visible: widget.items.isNotEmpty ? true : false,
          child: Center(child: Divider(indent: 16, endIndent: 16, height: 28, color: Colors.grey.shade300))
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            int total = countItemPrice(index);
            int duration = widget.duration;
            if (widget.items[index]['duration'] != null) duration = widget.items[index]['duration'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Container(
                  height: 80,
                  width: 50,
                  decoration: BoxDecoration(
                    color: widget.items[index]['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Icon(widget.items[index]['withicon'], color: widget.items[index]['color'], size: 40)
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(widget.items[index]['name'].toString().toTitle()),
                ),
                titleTextStyle: GoogleFonts.rubik(
                  color: Colors.grey.shade800,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.25
                ),
                subtitle: IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(widget.items[index]['subname'], style: GoogleFonts.roboto(color: Colors.grey.shade600)),
                      const VerticalDivider(width: 18, indent: 4, endIndent: 4),
                      Text('$_currency. ${_formatNumber(widget.items[index]['price'].toString())}', style: GoogleFonts.roboto(color: Colors.grey.shade600))
                    ],
                  ),
                ),
                subtitleTextStyle: GoogleFonts.rubik(
                  fontSize: 16,
                  letterSpacing: -0.25,
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('$_currency. ${_formatNumber(total.toString())}', style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800)
                      ),
                    ),
                    Text(
                      widget.items[index]['name'] == 'Listrik' || widget.items[index]['name'] == 'Speaker'
                      ? 'Durasi: $duration Jam' 
                      : 'Jumlah: ${widget.people}'
                    )
                  ]
                ),
                leadingAndTrailingTextStyle: GoogleFonts.roboto(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  letterSpacing: -0.25,
                ),
              ),
            );
          },
        ),
        Visibility(
          visible: widget.items.isNotEmpty ? true : false,
          child: Center(child: Divider(indent: 16, endIndent: 16, height: 28, color: Colors.grey.shade300))
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Ringkasan', 
                style: GoogleFonts.rubik(
                  color: Colors.grey.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5
                )
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', 
                    style: GoogleFonts.rubik(
                      color: Colors.grey.shade800,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.25
                    )
                  ),
                  Text('$_currency. ${_formatNumber(subtotal.toString())}',
                    style: GoogleFonts.rubik(
                      color: Colors.grey.shade800,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(widget.locations['name'], 
                        style: GoogleFonts.rubik(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.25
                        )
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        backgroundColor: Colors.green.shade50,
                        side: BorderSide.none,
                        padding: const EdgeInsets.only(right: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.7)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people, color: Colors.green.shade700, size: 14),
                            const SizedBox(width: 6),
                            Text('${widget.people} Orang'),
                          ],
                        ),
                        labelStyle: GoogleFonts.rubik(
                          color: Colors.green.shade900,
                          fontSize: 14
                        ),
                      )
                    ],
                  ),
                  Text('${widget.locations['price'] == 0 ? '' : '+'} $_currency. ${_formatNumber((widget.people * widget.locations['price']).toString())}', 
                    style: GoogleFonts.rubik(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hari Besar', 
                    style: GoogleFonts.rubik(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.25
                    )
                  ),
                  Text('+ $_currency. ${_formatNumber((widget.people * widget.locations['price']).toString())}', 
                    style: GoogleFonts.rubik(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(40, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 1,
                        width: 1,
                        color: Colors.grey.shade400,
                      ),
                    );
                  }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', 
                    style: GoogleFonts.rubik(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.25
                    )
                  ),
                  Text('$_currency. ${_formatNumber(total.toString())}', 
                    style: GoogleFonts.rubik(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void showLocationItem(BuildContext context, String tag, String location, int? tamu, String image, int price, Function changeLocation, Function changeGuest) {
  Navigator.push(context, PageRouteBuilder(
    fullscreenDialog: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ShowLocationItem(tag: tag, image: image, location: location, tamu: tamu, price: price, changeLocation: changeLocation, changeGuest: changeGuest);
    })
  );
}

class ShowLocationItem extends StatefulWidget {
  const ShowLocationItem({
    super.key, 
    required this.location, 
    required this.image, 
    required this.tag, 
    required this.changeLocation, 
    required this.tamu,
    required this.price,
    required this.changeGuest
  });
  
  final String location, tag, image;
  final Function changeLocation, changeGuest;

  final int? tamu;
  final int price;

  @override
  State<ShowLocationItem> createState() => _ShowLocationItemState();
}

class _ShowLocationItemState extends State<ShowLocationItem> {

  bool _first = false;

  late TextEditingController _textEditingController, _textEditingCurrencyController;
  late int tamu, tamu_;

  List<bool> tiles = List.filled(9, false);
  
  String _formatNumber(String s) => NumberFormat.decimalPattern(ResultEvent._locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: ResultEvent._locale).currencySymbol;

  @override
  void initState() {
    if (widget.tamu != null) { 
      tamu = widget.tamu!;
      tamu_ = widget.tamu!;
    } else { tamu = 0; tamu_ = 0; }
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _first = true));

    _textEditingController = TextEditingController(text: tamu.toString());
    _textEditingCurrencyController = TextEditingController(text: _formatNumber(widget.price.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int total = int.parse(_textEditingController.text) * int.parse(_textEditingCurrencyController.text.replaceAll('.', ''));
    return WillPopScope(
      onWillPop: () async {
        setState(() => _first = false);
        return true;
      },
      child: Theme(
        data: ThemeData(useMaterial3: true),
        child: AnimatedScale(
          scale: _first ? 1 : 0.8,
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: _first ? 1 : 0,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 300),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: AnimatedScale(
                        scale: _first ? 1 : 0.8,
                        curve: Curves.easeInOutCubic,
                        duration: const Duration(milliseconds: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => showDialogImage(context, 'images/${widget.image}', widget.location),
                              child: Hero(
                                tag: widget.location,
                                child: Container(
                                  margin: const EdgeInsets.all(24),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: widget.location == 'Pendopo' ?DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('images/${widget.image}')
                                    ) : null
                                  ),
                                  child: widget.location == 'Pendopo' ? GridView(
                                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                    children: List.generate(tiles.length, (index) {
                                      return Card(
                                        color: tiles[index] ? Colors.white70 : Colors.white38,
                                        elevation: 4,
                                        shadowColor: Colors.black38,
                                        surfaceTintColor: Colors.transparent,
                                        child: Transform.scale(
                                          scale: 4,
                                          child: Checkbox(
                                            fillColor: MaterialStatePropertyAll(Colors.lightGreen.shade700),
                                            side: BorderSide.none,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            value: tiles[index], 
                                            onChanged: (value) => setState(() => tiles[index] = value!),
                                          ),
                                        ),
                                      );
                                    }),
                                  ) : Image.asset('images/${widget.image}', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 48),
                              child: Column(
                                children: [
                                  Text(widget.location, 
                                    style: GoogleFonts.varelaRound(
                                      color: Colors.grey.shade800,
                                      fontSize: 20,
                                      decoration: TextDecoration.none
                                    )
                                  ),
                                  Text('Pilih / Ubah harga sewa ${widget.location} yang akan ditempati oleh tamu.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      height: 1.5,
                                      decoration: TextDecoration.none
                                    )
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 26),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.grey.shade400,
                                    height: 5,
                                    width: 5
                                  ),
                                  Text(total != 0
                                    ? '${_textEditingController.text} x ${_textEditingCurrencyController.text} = $_currency. ${_formatNumber(total.toString())}'
                                    : 'Gratis',
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey,
                                      fontSize: 16
                                    )
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.grey.shade400,
                                    height: 5,
                                    width: 5
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _textEditingController,
                                    onChanged: (value) {
                                      setState(() {
                                        void setDuration(int value) => tamu = value;
                                        _textEditingController.value = nullableNum(value, _textEditingController, setDuration);
                                      });
                                    },
                                    enableInteractiveSelection: false,
                                    style: GoogleFonts.rubik(
                                      letterSpacing: -0.25,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500
                                    ),
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.end,
                                    textAlignVertical: TextAlignVertical.top,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                                      counterText: '',
                                      prefix: Transform.translate(
                                        offset: const Offset(0, -1),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(12, 4, 16 ,4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.person, color: Colors.green, size: 22),
                                                    const SizedBox(width: 8),
                                                    Text('Tamu',
                                                      style: GoogleFonts.rubik(
                                                        decoration: TextDecoration.none,
                                                        letterSpacing: -0.5,
                                                        fontSize: 20,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      suffix: IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(' Orang '),
                                            const SizedBox(width: 4),
                                            const VerticalDivider(indent: 6, endIndent: 6),
                                            IconButton(
                                              onPressed: () {
                                                if (tamu > 0) {
                                                  setState(() {
                                                    tamu -= 1;
                                                    _textEditingController.text = tamu.toString();
                                                    _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
                                                  });
                                                }
                                              }, 
                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                              style: const ButtonStyle(iconSize: MaterialStatePropertyAll(32)),
                                              icon: const Icon(Icons.remove)
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  tamu += 1;
                                                  _textEditingController.text = tamu.toString();
                                                  _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
                                                });
                                              }, 
                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                              style: const ButtonStyle(iconSize: MaterialStatePropertyAll(32)),
                                              icon: const Icon(Icons.add)
                                            ),
                                          ],
                                        ),
                                      ),
                                      suffixStyle: GoogleFonts.varelaRound(
                                        color: Colors.grey.shade800,
                                        letterSpacing: -0.5,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        height: 1.75
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.green.withOpacity(0.25), width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.green, width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _textEditingCurrencyController,
                                    onChanged: (value) {
                                      setState(() {
                                        _textEditingCurrencyController.value = nullableNum(value, _textEditingCurrencyController);
                                        _textEditingCurrencyController.value = currencyFormat(_textEditingCurrencyController.text, _textEditingCurrencyController);
                                      });
                                    },
                                    style: GoogleFonts.rubik(
                                      letterSpacing: -0.25,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500
                                    ),
                                    maxLength: 7,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.end,
                                    textAlignVertical: TextAlignVertical.top,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                                      counterText: '',
                                      prefixText: '$_currency. ',
                                      suffix: const Text(' / orang'),
                                      suffixStyle: GoogleFonts.varelaRound(
                                        color: Colors.grey.shade600,
                                        letterSpacing: -0.5,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        height: 1.75
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.green, width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() => _first = false);
                                        WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
                                      }, 
                                      style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(2),
                                        shadowColor: const MaterialStatePropertyAll(Colors.black26),
                                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
                                        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
                                        overlayColor: const MaterialStatePropertyAll(Colors.black12),
                                        backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                        foregroundColor: const MaterialStatePropertyAll(Colors.grey),
                                        side: MaterialStatePropertyAll(BorderSide(color: Colors.grey.shade400, width: 2)),
                                        textStyle: MaterialStatePropertyAll(
                                          GoogleFonts.varelaRound(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)
                                          )
                                        )
                                      ),
                                      child: const Text('Tutup')
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        widget.changeLocation(widget.location, int.parse(_textEditingCurrencyController.text.replaceAll('.', '')), 'price');
                                        widget.changeGuest(int.parse(_textEditingController.text));

                                        setState(() => _first = false);
                                        WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
                                      },
                                      style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(2),
                                        shadowColor: const MaterialStatePropertyAll(Colors.black45),
                                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
                                        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
                                        foregroundColor: const MaterialStatePropertyAll(Colors.green),
                                        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade50),
                                        overlayColor: MaterialStatePropertyAll(Colors.green.withOpacity(0.25)),
                                        side: const MaterialStatePropertyAll(BorderSide(color: Colors.green, width: 2)),
                                        textStyle: MaterialStatePropertyAll(
                                          GoogleFonts.varelaRound(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)
                                          )
                                        )
                                      ),
                                      child: const Text('Sewakan')
                                    ),
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showChangeItem(BuildContext context, String tag, String title, int duration, IconData icon, Color color, int price, Function selectItem, Function changeItem) {
  Navigator.push(context, PageRouteBuilder(
    fullscreenDialog: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ShowChangeItem(tag: tag, icon: icon, title: title, duration: duration, selectItem: selectItem, changeItem: changeItem, color: color, price: price);
    })
  );
}

class ShowChangeItem extends StatefulWidget {
  const ShowChangeItem({
    super.key, 
    required this.title, 
    required this.icon, 
    required this.tag, 
    required this.selectItem, 
    required this.color, 
    required this.duration,
    required this.price,
    required this.changeItem
  });
  
  final String title, tag;
  final IconData icon;
  final Function selectItem, changeItem;
  final Color color;

  final int duration, price;

  @override
  State<ShowChangeItem> createState() => _ShowChangeItemState();
}

class _ShowChangeItemState extends State<ShowChangeItem> {

  bool _first = false;

  late TextEditingController _textEditingController, _textEditingCurrencyController;
  late String quantity;
  late int duration, duration_;
  
  String _formatNumber(String s) => NumberFormat.decimalPattern(ResultEvent._locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: ResultEvent._locale).currencySymbol;

  @override
  void initState() {
    duration = widget.duration; 
    duration_ = widget.duration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {      
        _first = true;
      });
    });

    _textEditingController = TextEditingController(text: duration.toString());
    _textEditingCurrencyController = TextEditingController(text: _formatNumber(widget.price.toString()));
    widget.title == 'Speaker' || widget.title == 'Listrik'
      ? quantity = 'Durasi' : quantity = 'Kuantitas';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int total = int.parse(_textEditingController.text) * int.parse(_textEditingCurrencyController.text.replaceAll('.', ''));
    return WillPopScope(
      onWillPop: () async {
        setState(() => _first = false);
        return true;
      },
      child: Theme(
        data: ThemeData(useMaterial3: true),
        child: AnimatedScale(
          scale: _first ? 1 : 0.8,
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: _first ? 1 : 0,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 300),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: AnimatedScale(
                        scale: _first ? 1 : 0.8,
                        curve: Curves.easeInOutCubic,
                        duration: const Duration(milliseconds: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.075),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Center(
                                child: Icon(widget.icon, size: 102, color: widget.color)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 48),
                              child: Column(
                                children: [
                                  Text(widget.title, 
                                    style: GoogleFonts.varelaRound(
                                      color: Colors.grey.shade800,
                                      fontSize: 20,
                                      decoration: TextDecoration.none
                                    )
                                  ),
                                  Text('Pilih / Ubah harga dan ${quantity.toLowerCase()} ${widget.title} yang akan disediakan.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      height: 1.5,
                                      decoration: TextDecoration.none
                                    )
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 26),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.grey.shade400,
                                    height: 5,
                                    width: 5
                                  ),
                                  Text('${_textEditingController.text} x ${_textEditingCurrencyController.text} = ',
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey,
                                      fontSize: 16
                                    )
                                  ),
                                  Text('$_currency. ${_formatNumber(total.toString())}',
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey,
                                      fontSize: 16
                                    )
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.grey.shade400,
                                    height: 5,
                                    width: 5
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _textEditingController,
                                    onChanged: (value) {
                                      setState(() {
                                        void setDuration(int value) => duration = value;
                                        _textEditingController.value = nullableNum(value, _textEditingController, setDuration);
                                      });
                                    },
                                    enableInteractiveSelection: false,
                                    style: GoogleFonts.rubik(
                                      letterSpacing: -0.25,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500
                                    ),
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.end,
                                    textAlignVertical: TextAlignVertical.top,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                                      counterText: '',
                                      prefix: Transform.translate(
                                        offset: const Offset(0, -1),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(12, 4, 16 ,4),
                                                decoration: BoxDecoration(
                                                  color: widget.color.withOpacity(0.075),
                                                  borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(widget.icon, color: widget.color, size: 22),
                                                    const SizedBox(width: 8),
                                                    Text(quantity,
                                                      style: GoogleFonts.rubik(
                                                        decoration: TextDecoration.none,
                                                        letterSpacing: -0.5,
                                                        fontSize: 20,
                                                        color: widget.color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      suffix: IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              children: [
                                                const Text('data'),
                                                Image.asset('images')
                                              ],
                                            ),
                                            Text(widget.title == 'Speaker' || widget.title == 'Listrik'
                                              ? ' Jam ' : ' '
                                            ),
                                            const SizedBox(width: 4),
                                            const VerticalDivider(indent: 6, endIndent: 6),
                                            IconButton(
                                              onPressed: () {
                                                if (duration > 0) {
                                                  setState(() {
                                                    duration -= 1;
                                                    _textEditingController.text = duration.toString();
                                                    _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
                                                  });
                                                }
                                              }, 
                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                              style: const ButtonStyle(iconSize: MaterialStatePropertyAll(32)),
                                              icon: const Icon(Icons.remove)
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  duration += 1;
                                                  _textEditingController.text = duration.toString();
                                                  _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
                                                });
                                              }, 
                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                              style: const ButtonStyle(iconSize: MaterialStatePropertyAll(32)),
                                              icon: const Icon(Icons.add)
                                            ),
                                          ],
                                        ),
                                      ),
                                      suffixStyle: GoogleFonts.varelaRound(
                                        color: Colors.grey.shade800,
                                        letterSpacing: -0.5,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        height: 1.75
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: widget.color.withOpacity(0.25), width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: widget.color, width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _textEditingCurrencyController,
                                    onChanged: (value) {
                                      setState(() {
                                        _textEditingCurrencyController.value = nullableNum(value, _textEditingCurrencyController);
                                        _textEditingCurrencyController.value = currencyFormat(_textEditingCurrencyController.text, _textEditingCurrencyController);
                                      });
                                    },
                                    style: GoogleFonts.rubik(
                                      letterSpacing: -0.25,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500
                                    ),
                                    maxLength: 7,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.end,
                                    textAlignVertical: TextAlignVertical.top,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                                      counterText: '',
                                      prefixText: '$_currency. ',
                                      suffix: Text(quantity == 'Durasi' ? ' / perjam' : ' / ${widget.title}'),
                                      suffixStyle: GoogleFonts.varelaRound(
                                        color: Colors.grey.shade600,
                                        letterSpacing: -0.5,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        height: 1.75
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: widget.color, width: 2),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        widget.selectItem(false);
                                        setState(() => _first = false);
                                        WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
                                      }, 
                                      style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(2),
                                        shadowColor: const MaterialStatePropertyAll(Colors.black26),
                                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
                                        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
                                        backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                        foregroundColor: const MaterialStatePropertyAll(Colors.grey),
                                        overlayColor: const MaterialStatePropertyAll(Colors.black12),
                                        side: MaterialStatePropertyAll(BorderSide(color: Colors.grey.shade400, width: 2)),
                                        textStyle: MaterialStatePropertyAll(
                                          GoogleFonts.varelaRound(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)
                                          )
                                        )
                                      ),
                                      child: const Text('Batal')
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (duration > 0) { 
                                          widget.selectItem(true);
                                        } else { 
                                          widget.selectItem(false); 
                                        }

                                        widget.changeItem('price', int.parse(_textEditingCurrencyController.text.replaceAll('.', '')));
                                        if (duration != duration_) { widget.changeItem('duration', duration); }

                                        setState(() => _first = false);
                                        WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
                                      },
                                      style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(2),
                                        shadowColor: const MaterialStatePropertyAll(Colors.black45),
                                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
                                        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
                                        foregroundColor: MaterialStatePropertyAll(widget.color),
                                        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade50),
                                        overlayColor: MaterialStatePropertyAll(widget.color.withOpacity(0.25)),
                                        side: MaterialStatePropertyAll(BorderSide(color: widget.color, width: 2)),
                                        textStyle: MaterialStatePropertyAll(
                                          GoogleFonts.varelaRound(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)
                                          )
                                        )
                                      ),
                                      child: const Text('Sewakan')
                                    ),
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showPickDate(BuildContext context, DateTime now, Function callback) async {
  bool animate = false;
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime.now(),
    lastDate: DateTime(now.year + 1),
    locale: const Locale('id', 'ID'),
    helpText: 'Pilih Tanggal',
    cancelText: 'Batal',
    confirmText: 'OK',
    builder: (context, child) {
      return StatefulBuilder(
        builder: (context, setState) {
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => animate = true));
          return AnimatedScale(
            scale: animate ? 1 : 0.9,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: animate ? 1 : 0,
              curve: Curves.easeInOutCubic,
              duration: const Duration(milliseconds: 200),
              child: Theme(
                data: Theme.of(context).copyWith(
                  useMaterial3: true,
                  colorScheme: ColorScheme.light(
                    surface: Colors.white,
                    surfaceTint: Colors.white,
                    surfaceVariant: Colors.lightGreen.shade100,
                    primary: Colors.lightGreen,
                    primaryContainer: Colors.lightGreen.shade200,
                    onPrimary: Colors.white,
                    onPrimaryContainer: Colors.lightGreen.shade900,
                    onSurface: Colors.grey.shade600,
                  ),
                  dividerTheme: const DividerThemeData(color: Colors.transparent, thickness: 0),
                  textTheme: TextTheme(
                    titleSmall: GoogleFonts.rubik(
                      color: Colors.grey.shade700,
                      fontSize: 18,
                      letterSpacing: -0.5
                    ),
                    labelSmall: GoogleFonts.varelaRound(
                      fontSize: 16,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600
                    ),
                    headlineMedium: GoogleFonts.rubik(
                      color: Colors.grey.shade700,
                      fontSize: 28,
                    ),
                    bodyLarge: GoogleFonts.rubik(
                      color: Colors.grey.shade700, 
                      fontSize: 20,
                    ),
                    bodyMedium: GoogleFonts.varelaRound(
                      color: Colors.grey.shade700,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                    bodySmall: GoogleFonts.rubik(
                      color: Colors.grey.shade700,
                      fontSize: 18,
                      letterSpacing: -0.5
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0),
                      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 24, horizontal: 24)),
                      surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
                      backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                      foregroundColor: MaterialStatePropertyAll(Colors.grey.shade700),
                      textStyle: MaterialStatePropertyAll(
                        GoogleFonts.varelaRound(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      )
                    )
                  )
                ),
                child: child!,
              ),
            ),
          );
        }
      );
    }
  );

  callback(selectedDate);
}


Future<void> showPickTime(BuildContext context, Function callback, TimeOfDay time) async {
  bool animate = false;
  final TimeOfDay? result = await showTimePicker(
    context: context, 
    initialTime: time,
    helpText: 'Pilih Waktu',
    cancelText: 'Tutup',
    hourLabelText: 'Jam',
    minuteLabelText: 'Menit',
    errorInvalidText: 'Waktu tidak valid / benar',
    initialEntryMode: TimePickerEntryMode.input,
    builder: (context, child) {
      return StatefulBuilder(
        builder: (context, setState) {
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => animate = true));
          return AnimatedScale(
            scale: animate ? 1 : 0.9,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: animate ? 1 : 0,
              curve: Curves.easeInOutCubic,
              duration: const Duration(milliseconds: 200),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    surface: Colors.white,
                    surfaceTint: Colors.white,
                    surfaceVariant: Colors.lightGreen.shade50,
                    primary: Colors.lightGreen,
                    primaryContainer: Colors.lightGreen.shade50,
                    onPrimary: Colors.white,
                    onPrimaryContainer: Colors.lightGreen.shade900,
                    onSurface: Colors.grey.shade700,
                  ),
                  textTheme: TextTheme(
                    bodyLarge: GoogleFonts.rubik(
                      color: Colors.grey.shade700, 
                      fontSize: 18,
                    ),
                    bodyMedium: GoogleFonts.varelaRound(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600
                    ),
                    bodySmall: GoogleFonts.varelaRound(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      letterSpacing: -0.5
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(2),
                      shadowColor: const MaterialStatePropertyAll(Colors.black45),
                      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
                      surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
                      backgroundColor: MaterialStatePropertyAll(Colors.grey.shade50),
                      foregroundColor: MaterialStatePropertyAll(Colors.grey.shade700),
                      textStyle: MaterialStatePropertyAll(
                        GoogleFonts.varelaRound(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      )
                    )
                  )
                ),
                child: child!
              ),
            ),
          );
        }
      );
    },
  );

  if (result != null) {
    callback(result.format(context));
  }
}
