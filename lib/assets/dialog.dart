import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

void showDialogImage(BuildContext context, String image, String tag) {
  Navigator.of(context).push(
    PageRouteBuilder(
      barrierColor: Colors.black87,
      opaque: false,
      barrierDismissible: true,
      fullscreenDialog: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ShowDialogImage(tag: tag, image: image);
      }
    )
  );
}

class ShowDialogImage extends StatelessWidget {
  const ShowDialogImage({
    super.key, 
    required this.tag, 
    required this.image
  });

  final String tag, image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
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
                  onPressed: () => Navigator.pop(context), 
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
    );
  }
}

void showDialogEvent(BuildContext context, String tag, DateTime now) {
  Navigator.push(context, PageRouteBuilder(
    fullscreenDialog: false,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black45,
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

  String fromDate = '${DateFormat('hh').format(DateTime.now())}:00';
  String toDate = '${DateFormat('hh').format(DateTime.now())}:00';

  List<bool> withAddons = List.filled(5, false);
  List<String> addonsName = [ 'Speaker', 'Listrik', 'Sofa', 'Kursi', 'Meja' ];
  List<IconData> addonsIcon = [ Icons.speaker_outlined, Icons.bolt_outlined, Icons.chair_outlined, Icons.chair_alt_outlined, Icons.table_bar_outlined];
  List<IconData> withAddonsIcon = [ Icons.speaker, Icons.bolt, Icons.chair, Icons.chair_alt, Icons.table_bar ];
  
  List<String> location = [ 'Pendopo', 'Kolam', 'Halaman Depan', 'Gazebo' ];
  List<IconData> locationIcon = [ Icons.foundation, FontAwesomeIcons.waterLadder, FontAwesomeIcons.tree, Icons.house_siding ];
  List<double?> locationIconSize = [ null, 20, 20, null ];
  String selectedLocation = 'Pendopo';

  void setTimerFrom(String time) {
    setState(() {
      fromDate = time;
    });
  }

  void setTimerTo(String time) {
    setState(() {
      toDate = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
          labelStyle: GoogleFonts.varelaRound(
            letterSpacing: -0.25,
            color: Colors.grey,
            fontSize: 24,
          ),
          counterStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Hero(
            tag: widget.tag,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 2,
                    shadowColor: Colors.black45,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: List.generate(3, (index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 4),
                                height: 10,
                                width: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.lightGreen,
                                  shape: BoxShape.circle
                                )
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tambah Acara', 
                                style: GoogleFonts.varelaRound(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                  color: Colors.grey.shade800
                                ),
                              ),
                              Icon(Icons.edit_calendar, color: Colors.grey.shade800)
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            // autofocus: true,
                            maxLength: 40,
                            style: GoogleFonts.rubik(
                              letterSpacing: -0.25,
                              fontSize: 24,
                              height: 1.75
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                              labelText: 'Judul',
                            ),
                          ),
                          DropdownButtonFormField(
                            value: selectedLocation,
                            onChanged: (value) {
                              setState(() {
                                selectedLocation = value!;
                              });
                            },
                            borderRadius: BorderRadius.circular(18),
                            elevation: 2,
                            icon: Icon(locationIcon[location.indexOf(selectedLocation)], size: locationIconSize[location.indexOf(selectedLocation)]),
                            dropdownColor: Colors.grey.shade100,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
                              label: Transform.translate(
                                offset: const Offset(0, -14),
                                child: const Text('Lokasi'),
                              )
                            ),
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              letterSpacing: -0.25,
                              fontSize: 24,
                            ),
                            items: location.map<DropdownMenuItem<String>>((String value) {
                              final widget = DropdownMenuItem<String>(
                                value: value,
                                child: Text(value)
                              );
                              return widget;
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8,
                              children: List.generate(withAddons.length, (index) {
                                return ChoiceChip(
                                  selected: withAddons[index],
                                  selectedColor: Colors.lightGreen.shade50,
                                  backgroundColor: Colors.grey.withOpacity(0.025),
                                  padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
                                  labelPadding: const EdgeInsets.only(left: 2),
                                  labelStyle: GoogleFonts.rubik(color: Colors.grey.shade700, fontSize: 16, height: 1, letterSpacing: -0.25),
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(withAddons[index] ? withAddonsIcon[index] : addonsIcon[index], color: Colors.grey.shade700),
                                      const SizedBox(width: 4),
                                      Text(addonsName[index]),
                                    ],
                                  ),
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onSelected: (value) { 
                                    setState(() { withAddons[index] = value; });
                                  },
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('Tanggal', 
                            style: GoogleFonts.varelaRound(
                              letterSpacing: -0.25,
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () {}, 
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              side: const MaterialStatePropertyAll(BorderSide(color: Colors.lightGreen)),
                              elevation: const MaterialStatePropertyAll(2),
                              shadowColor: MaterialStatePropertyAll(Colors.lightGreen.shade100),
                              textStyle: MaterialStatePropertyAll(
                                GoogleFonts.rubik(
                                  fontSize: 18,
                                  letterSpacing: -0.25,
                                )
                              ),
                              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
                              overlayColor: MaterialStatePropertyAll(Colors.lightGreen.shade100),
                              backgroundColor: const MaterialStatePropertyAll(Colors.white),
                              foregroundColor: const MaterialStatePropertyAll(Colors.black),
                              alignment: Alignment.centerLeft
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(DateFormat('EEEE, dd MMMM yyyy', 'id').format(DateTime.now())),
                                  Row(
                                    children: [
                                      const VerticalDivider(color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Icon(Icons.event, color: Colors.grey.shade700),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [ 
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showPickTime(context, setTimerFrom, TimeOfDay(hour:int.parse(fromDate.split(":")[0]),minute: int.parse(fromDate.split(":")[1])));
                                  }, 
                                  style: ButtonStyle(
                                    alignment: Alignment.centerLeft,
                                    elevation: const MaterialStatePropertyAll(0),
                                    shadowColor: MaterialStatePropertyAll(Colors.grey.shade100),
                                    side: const MaterialStatePropertyAll(BorderSide(color: Colors.grey)),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
                                    overlayColor: MaterialStatePropertyAll(Colors.lightGreen.shade100),
                                    foregroundColor: const MaterialStatePropertyAll(Colors.black),
                                    backgroundColor: MaterialStatePropertyAll(Colors.grey.shade50),
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
                                      Text(fromDate),
                                    ],
                                  )
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 5,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showPickTime(context, setTimerTo, TimeOfDay(hour:int.parse(toDate.split(":")[0]),minute: int.parse(toDate.split(":")[1])));
                                  }, 
                                  style: ButtonStyle(
                                    alignment: Alignment.centerLeft,
                                    elevation: const MaterialStatePropertyAll(0),
                                    shadowColor: MaterialStatePropertyAll(Colors.grey.shade100),
                                    side: const MaterialStatePropertyAll(BorderSide(color: Colors.grey)),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
                                    overlayColor: MaterialStatePropertyAll(Colors.lightGreen.shade100),
                                    foregroundColor: const MaterialStatePropertyAll(Colors.black),
                                    backgroundColor: MaterialStatePropertyAll(Colors.grey.shade50),
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
                                      Text(toDate),
                                    ],
                                  )
                                ),
                              ),
                            ]
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            shadowColor: const MaterialStatePropertyAll(Colors.black45),
                            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
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
                          child: const Text('Batal')
                        ),
                        const SizedBox(width: 2),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            shadowColor: const MaterialStatePropertyAll(Colors.black45),
                            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 28)),
                            backgroundColor: const MaterialStatePropertyAll(Colors.lightGreen),
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
                          child: const Text('Buat')
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
    );
  }
}

Future<void> showPickTime(BuildContext context, Function callback, TimeOfDay time) async {
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
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            surface: Colors.white,
            primary: Colors.lightGreen,
            primaryContainer: Colors.lightGreen.shade200,
            onPrimary: Colors.white,
            onPrimaryContainer: Colors.lightGreen.shade900,
            onSurface: Colors.grey.shade600,
          ),
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.rubik(
              color: Colors.grey.shade700, 
              fontSize: 18,
            ),
            bodyMedium: GoogleFonts.varelaRound(
              color: Colors.grey.shade700,
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
            bodySmall: GoogleFonts.varelaRound(
              color: Colors.grey.shade700,
              fontSize: 16,
              letterSpacing: -0.5
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: GoogleFonts.greatVibes(),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              elevation: const MaterialStatePropertyAll(1),
              shadowColor: const MaterialStatePropertyAll(Colors.black45),
              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
              surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
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
      );
    },
  );

  if (result != null) {
    callback(result.format(context));
  }
}
