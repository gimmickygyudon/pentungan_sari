import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({
    super.key, required this.changeNavColor
  });

  final Function changeNavColor;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int total = 0, surplus = 0;
  int ticket = 1;
  int ticketPrice = 5000;
  int? discount;

  late TextEditingController _totalController;
  late TextEditingController _ticketController;

  final ScrollController _scrollController = ScrollController();

  static const _locale = 'id';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  List<Map<String, dynamic>> tickets = [];

  final List<Map<String, dynamic>> _tickets = [
    {
      'index': 0,
      'names': 'Tiket Masuk',
      'types': ['Perorangan'],
      'units': 'Orang',
      'icons': Icons.confirmation_number,
      'colors': Colors.blue.shade400,
      'bgcolors': Colors.blue.shade300,
      'subcolors': Colors.blue.shade100,
      'prices': 5000,
      'sub': 'Info',
      'notes': 'Pembelian tiket dapat dilakukan di pintu masuk'
    },
    {
      'index': 1,
      'names': 'Parkir Mobil',
      'types': ['Roda 4'],
      'units': 'Mobil',
      'icons': Icons.directions_car,
      'colors': Colors.red.shade400,
      'bgcolors': Colors.red.shade300,
      'subcolors': Colors.red.shade100,
      'prices': 5000,
      'sub': 'Info',
      'notes': 'Termasuk Bus dan kendaraan roda lainnya'
    },
    {
      'index': 2,
      'names': 'Parkir Sepeda Motor',
      'types': ['Roda 2'],
      'units': 'Sepeda',
      'icons': Icons.two_wheeler,
      'colors': Colors.lightBlue.shade400,
      'bgcolors': Colors.lightBlue.shade300,
      'subcolors': Colors.lightBlue.shade100,
      'prices': 2000,
      'sub': 'Info',
      'notes': 'Jenis sepeda dan kendaraan roda lainnya'
    },
    {
      'index': 3,
      'names': 'Paket Sekolah',
      'types': ['TK', 'SD', 'SMP', 'SMK', 'Mahasiswa'],
      'units': 'Murid',
      'icons': Icons.school,
      'colors': Colors.yellow.shade800,
      'bgcolors': Colors.yellow.shade700,
      'subcolors': Colors.yellow.shade100,
      'prices': 5000,
      'discount': [50, 25, 15, 15, 15],
      'sub': 'Info',
      'notes': 'Lebih hemat sampai 50% dengan paket sekolah'
    },
    {
      'index': 4,
      'names': 'Paket Rombongan',
      'types': ['Grup'],
      'units': 'Orang',
      'icons': Icons.diversity_3,
      'colors': Colors.green.shade400,
      'bgcolors': Colors.green.shade300,
      'subcolors': Colors.green.shade100,
      'prices': 5000,
      'discount': [15],
      'sub': 'Info',
      'notes': 'Paket wisata rombongan bersama di pentungan sari'
    },
  ];

  List<bool> selectedTicket = [true, false, false, false, false];
  int selectedTypes = 0;
  bool onExpand = false;
  bool minUnits = false;

  @override
  void initState() {
    _totalController = TextEditingController();
    _ticketController = TextEditingController(text: ticket.toString());
    countPrice(ticket);

    tickets.addAll(_tickets);
    selectTicket(0);
    discount = _tickets[selectedTicket.indexOf(true)].containsKey('discount') 
      ? _tickets[selectedTicket.indexOf(true)]['discount'][selectedTypes] 
      : null;
    ticketPrice = _tickets[selectedTicket.indexOf(true)]['prices'];

    // discount
    if (discount != null) {
      ticketPrice -= ((discount! / 100) * ticketPrice).toInt();
      _ticketController.text = '10';
    } else {
      _ticketController.text = '1';
    }
    
    _scrollController.addListener(() { 
      if (onExpand == true) {
        setState(() {
          onExpand = false;         
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _totalController.dispose();
    _ticketController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void countPrice(int ticket) {
    total = ticket * ticketPrice;
    _totalController.text = idrDecimal(total.toString());
  }

  void selectTicket(int index) {
    setState(() {      
      selectedTicket.setAll(0, [false, false, false, false, false]);
      selectedTicket[index] = true;
      selectedTypes = 0;

      tickets.clear();
      tickets.addAll(_tickets);
      tickets.removeAt(selectedTicket.indexOf(true));
      minUnits = false;

      discount = _tickets[selectedTicket.indexOf(true)].containsKey('discount')
        ? _tickets[selectedTicket.indexOf(true)]['discount'][selectedTypes] 
        : null;
      ticketPrice = _tickets[selectedTicket.indexOf(true)]['prices'];

      // discount
      if (discount != null) {
        ticketPrice -= ((discount! / 100) * ticketPrice).toInt();
        _ticketController.text = '10';
      } else {
        discount = null;
        minUnits = false;
        _ticketController.text = '1';
      }
      
      surplus = 0;
      _totalController.text = _formatNumber((ticketPrice * int.parse(_ticketController.text)).toString());
    });
  }

  String idrDecimal(String src) {
    String newStr = '';
    int step = 3;
    for (int i = src.length; i >= 0; i -= step) {
      String subString = '';
      if (i > 3) {
        subString += '.';
      }
      subString += src.substring(i < step ? 0 : i - step, i);
      newStr = subString + newStr;
    }
    return newStr;
  }

  String nonNullString(TextEditingController controller, String string, [int? min]) {
    String newString = string;
    
    if (string.length > 1) {
      for (int i = 0; i < string.length; i++) {
        if (newString.length > 1 && newString.substring(0, 1) == '0') {
          controller.text = newString.substring(1, newString.length);
          controller.selection = TextSelection.fromPosition(const TextPosition(offset: 1));

          newString = newString.substring(1, newString.length);
        } 
      }
    }

    newString.length < 2 && min != null 
      ? minUnits = true 
      : minUnits = false;

    if (string == '') { 
      controller.text = '0';
      controller.selection = TextSelection.fromPosition(const TextPosition(offset: 1));
    }

    return newString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _tickets[selectedTicket.indexOf(true)]['colors'].withOpacity(0.85),
      child: SafeArea(
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _tickets[selectedTicket.indexOf(true)]['colors'].withOpacity(0.85),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [ 0.4, 1.0 ],
                      colors: [
                        _tickets[selectedTicket.indexOf(true)]['colors'].withOpacity(0.85),
                        _tickets[selectedTicket.indexOf(true)]['colors']
                      ]
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)
                    )
                  ),
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)
                    ),
                    onTap: () {
                      setState(() {
                        onExpand 
                          ? onExpand = false
                          : onExpand = true;
                      });
                    },
                    splashColor: _tickets[selectedTicket.indexOf(true)]['colors'].withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return FadeTransition(opacity: animation, child: SizedBox(width: 200, child: child));
                                      },
                                      child: Text(_tickets[selectedTicket.indexOf(true)]['names'],
                                        key: ValueKey<String>(_tickets[selectedTicket.indexOf(true)]['names']),
                                        style: GoogleFonts.rubik(
                                          color: _tickets[selectedTicket.indexOf(true)]['subcolors'],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                    Text('Pentungan Sari', 
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800
                                      )
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: AnimatedRotation(
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 400),
                                    turns: onExpand ? 0.5 : 0,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        onExpand ? Icons.price_change_outlined : Icons.local_atm,
                                        size: 32,
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            color: Colors.white,
                            elevation: 4,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(36, 36, 36, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_tickets[selectedTicket.indexOf(true)]['names'], 
                                              style: GoogleFonts.rubik(
                                                fontSize: 16,
                                                color: Colors.grey.shade500
                                              )
                                            ),
                                            const SizedBox(height: 4),
                                            AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 400),
                                              transitionBuilder: (Widget child, Animation<double> animation) {
                                                return FadeTransition(opacity: animation, child: SizedBox(width: 250, child: child));
                                              },
                                              child: Row(
                                                children: [
                                                  Visibility(
                                                    visible: discount == null ? true : false,
                                                    child: Text(_tickets[selectedTicket.indexOf(true)]['types'][0],
                                                      key: ValueKey(_tickets[selectedTicket.indexOf(true)]['types'][0]),
                                                      style: GoogleFonts.varelaRound(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.grey.shade800
                                                      )
                                                    ),
                                                  ),
                                                  discount == null ? const SizedBox() : Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 2, bottom: 3),
                                                      child: DropdownButton(
                                                        isDense: true,
                                                        icon: Transform.translate(
                                                          offset: const Offset(0, -4),
                                                          child: const Icon(Icons.expand_more, size: 30)
                                                        ),
                                                        elevation: 2,
                                                        borderRadius: BorderRadius.circular(12),
                                                        value: _tickets[selectedTicket.indexOf(true)]['types'][selectedTypes],
                                                        underline: const SizedBox(),
                                                        style: GoogleFonts.varelaRound(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.grey.shade800
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            surplus = 0;
                                                            selectedTypes = _tickets[selectedTicket.indexOf(true)]['types'].indexOf(value);

                                                            // discount
                                                            discount = _tickets[selectedTicket.indexOf(true)]['discount'][selectedTypes];
                                                            ticketPrice = _tickets[selectedTicket.indexOf(true)]['prices'];
                                                            ticketPrice -= ((discount! / 100) * _tickets[selectedTicket.indexOf(true)]['prices']).toInt();

                                                            _totalController.text = _formatNumber((ticketPrice * int.parse(_ticketController.text)).toString());
                                                          });
                                                        },
                                                        items: _tickets[selectedTicket.indexOf(true)]['types'].map<DropdownMenuItem<String>>((String value) {
                                                          final widget = DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                          return widget;
                                                        }).toList()
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: AnimatedSize(
                                                curve: Curves.ease,
                                                duration: const Duration(milliseconds: 400),
                                                child: AnimatedSwitcher(
                                                  duration: const Duration(milliseconds: 400),
                                                  reverseDuration: const Duration(milliseconds: 200),
                                                  child: _tickets[selectedTicket.indexOf(true)]['discount'] != null ? SizedBox(
                                                    width: _tickets[selectedTicket.indexOf(true)]['discount'] != null ? null : 0,
                                                    child: Container(
                                                      padding: const EdgeInsets.all(6),
                                                      color: _tickets[selectedTicket.indexOf(true)]['bgcolors'],
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.arrow_downward, 
                                                            size: 24, color: Colors.white
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text('${_tickets[selectedTicket.indexOf(true)]['discount'][selectedTypes]}%',
                                                            style: GoogleFonts.nunito(
                                                              color: Colors.white,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w700
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    )
                                                  ) : null,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 400),
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: _tickets[selectedTicket.indexOf(true)]['bgcolors'],
                                              ),
                                              child: Icon(_tickets[selectedTicket.indexOf(true)]['icons'], 
                                                size: 28, color: Colors.white
                                              )
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: AnimatedSwitcher(
                                          transitionBuilder: (Widget child, Animation<double> animation) {
                                            return FadeTransition(opacity: animation, child: child);
                                          },
                                          duration: const Duration(milliseconds: 600),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              Text(_tickets[selectedTicket.indexOf(true)]['sub'], 
                                                style: GoogleFonts.rubik(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade500
                                                )
                                              ),
                                              const SizedBox(height: 2),
                                              Text(_tickets[selectedTicket.indexOf(true)]['notes'], 
                                                style: GoogleFonts.varelaRound(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey.shade600
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Harga (IDR)', 
                                              style: GoogleFonts.rubik(
                                                fontSize: 16,
                                                color: Colors.grey.shade500
                                              )
                                            ),
                                            const SizedBox(height: 2),
                                            Text('Rp. ${_formatNumber(ticketPrice.toString())}', 
                                              style: GoogleFonts.signikaNegative(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  AnimatedSize(
                                    curve: Curves.ease,
                                    duration: const Duration(milliseconds: 600),
                                    child: SizedBox(height: onExpand ? 22 : 18)
                                  ),
                                  Visibility(
                                    visible: onExpand,
                                    child: Column( // TEST
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: List.generate(25, (index) {
                                            return Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                                child: Divider(thickness: 3, color: Colors.grey.shade300),
                                              )
                                            );
                                          })
                                        ),
                                        const SizedBox(height: 18),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IntrinsicWidth(
                                                    child: TextFormField(
                                                      controller: _ticketController,
                                                      onChanged: (value) {
                                                        String string = value.trim();

                                                        nonNullString(_ticketController, string, discount == null ? null : 10);

                                                        setState(() {
                                                          countPrice(int.parse(_ticketController.text));
                                                          surplus = 0;
                                                        });
                                                      },
                                                      maxLength: 4,
                                                      keyboardType: TextInputType.number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter.digitsOnly
                                                        ],
                                                      style: GoogleFonts.signikaNegative(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey.shade600
                                                      ),
                                                      cursorColor: Colors.lightGreen,
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                                        counterText: '',
                                                        labelText: 'Jumlah',
                                                        labelStyle: GoogleFonts.rubik(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey.shade500,
                                                          height: 0.5
                                                        ),
                                                        suffixText: ' ${_tickets[selectedTicket.indexOf(true)]['units']}',
                                                        suffixStyle: GoogleFonts.varelaRound(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.grey.shade600
                                                        ),
                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: minUnits ? Colors.red : Colors.lightGreen, width: 3)
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: minUnits ? Colors.red : Colors.grey, width: 2)
                                                        ),
                                                        border: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: minUnits ? Colors.red : Colors.grey, width: 2)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  IntrinsicWidth(
                                                    child: TextFormField(
                                                      key: ValueKey(_tickets[selectedTicket.indexOf(true)]['index']),
                                                      controller: _totalController,
                                                      onChanged: (e) {
                                                        String value = e.replaceAll('.','');

                                                        value = nonNullString(_totalController, value, discount == null ? null : 10);

                                                        int total = int.parse(value);
                                                        int ticket = int.parse(_ticketController.text);

                                                        if (int.parse(value) >= ticketPrice) {
                                                          for (int i = 0; (total - ticketPrice) >= 0; i++) {
                                                            if (i != 0) total = total - ticketPrice;
                                                            ticket = i;
                                                          }
                                                        } else { 
                                                          ticket = 0;
                                                          total = 0;
                                                        }

                                                        int dots = 0;
                                                        value = _formatNumber(value.replaceAll(',', ''));
                                                        int diff = value.length - _totalController.text.length;

                                                        int position = _totalController.text.length - _totalController.selection.base.offset;
                                                        if (position < 6 && diff > 1) dots = 1;
                                                        if (position < 3 && diff < 2 && diff != 0) dots = 1;
                                                        if (position < 3 && diff > 1) dots = 2;

                                                        _totalController.value = _totalController.value.copyWith(
                                                          text: value, selection: TextSelection.collapsed(
                                                            offset: _totalController.selection.base.offset + dots,
                                                          ),
                                                        );
                                                        _ticketController.text = ticket.toString();

                                                        setState(() {
                                                          surplus = total;
                                                        });
                                                      },
                                                      maxLength: 8,
                                                      keyboardType: TextInputType.number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter.digitsOnly,
                                                        ],
                                                      style: GoogleFonts.signikaNegative(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey.shade600
                                                      ),
                                                      cursorColor: Colors.lightGreen,
                                                      decoration: InputDecoration(
                                                        counter: Visibility(
                                                          visible: surplus == 0 ? false : true,
                                                          maintainSize: true,
                                                          maintainAnimation: true,
                                                          maintainState: true,
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 1),
                                                                child: Text(surplus == 0 ? '' : '+$surplus', 
                                                                  style: GoogleFonts.varelaRound(
                                                                    height: 1.5,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.lightGreen.shade400
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 4),
                                                              Icon(Icons.arrow_outward, color: Colors.lightGreen.shade400, size: 20)
                                                            ],
                                                          ),
                                                        ),
                                                        labelText: 'Total',
                                                        labelStyle: GoogleFonts.rubik(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey.shade500,
                                                          height: 0.5
                                                        ),
                                                        prefixText: '$_currency. ',
                                                        focusedBorder: const UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.lightGreen, width: 3)
                                                        ),
                                                        enabledBorder: const UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey, width: 2)
                                                        ),
                                                        border: const UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey, width: 2)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        AnimatedSize(
                                          duration: const Duration(milliseconds: 400),
                                          child: SizedBox(
                                            height: minUnits ? null : 0,
                                            child: AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 400),
                                              child: minUnits ? RichText(
                                                text: WidgetSpan(
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.error_outline, color: Colors.red, size: 16),
                                                      const SizedBox(width: 6),
                                                      Text('Untuk ${_tickets[selectedTicket.indexOf(true)]['names'].toLowerCase()} minimal 10 ${_tickets[selectedTicket.indexOf(true)]['units'].toLowerCase()}.',
                                                        style: GoogleFonts.varelaRound(
                                                          color: Colors.red,
                                                          height: 0,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                )
                                              ) : null,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: kToolbarHeight + 10,
                      elevation: 4,
                      shadowColor: Colors.black54,
                      surfaceTintColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24)
                      )),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Icon(Icons.article_outlined, size: 26, color: Colors.grey.shade600),
                      ),
                      titleSpacing: 4,
                      title: Text('Tiket'.toUpperCase(), 
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          wordSpacing: 1,
                          color: Colors.grey.shade600
                        )
                      ),
                      actions: [
                        VerticalDivider(width: 6, thickness: 3, indent: 24, endIndent: 24, color: Colors.lightGreen.shade300),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TextButton.icon(
                            style: ButtonStyle(
                              elevation: const MaterialStatePropertyAll(0),
                              visualDensity: const VisualDensity(horizontal: 2, vertical: 2),
                              foregroundColor: const MaterialStatePropertyAll(Colors.lightGreen),
                              overlayColor: MaterialStatePropertyAll(Colors.lightGreen.shade100),
                              textStyle: MaterialStatePropertyAll(
                                GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500
                                )
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                double position = _scrollController.offset;
                                if (position > _scrollController.position.maxScrollExtent) {
                                  position = _scrollController.position.maxScrollExtent;
                                } else if (position < _scrollController.position.minScrollExtent) {
                                  position = _scrollController.position.minScrollExtent;
                                }

                                _scrollController.position.jumpTo(position);
                                onExpand ? onExpand = false : onExpand = true;
                              });
                            }, 
                            icon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 26,
                            ),
                            label: const Text('Hitung Biaya')
                          ),
                        )
                      ],
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor: MaterialStatePropertyAll(Colors.grey.shade300),
                              ),
                              child: Scrollbar(
                                radius: const Radius.circular(25.7),
                                child: ListView(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(right: 14, left: 28, top: 20),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: List.generate(tickets.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 18),
                                      child: PhysicalModel(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        shadowColor: tickets[index]['colors'].withOpacity(0.65),
                                        borderRadius: BorderRadius.circular(12),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: const [ 0.4, 1.0 ],
                                              colors: [
                                                tickets[index]['colors'].withOpacity(0.75),
                                                tickets[index]['colors'].withOpacity(0.85)
                                              ]
                                            ),
                                            borderRadius: BorderRadius.circular(12)
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(12),
                                            splashColor: tickets[index]['colors'].withOpacity(0.95),
                                            onTap: () {
                                              Future.delayed(const Duration(milliseconds: 150)).then((value) {
                                                selectTicket(tickets[index]['index']);
                                                widget.changeNavColor(_tickets[selectedTicket.indexOf(true)]['colors'].withOpacity(0.75));
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(tickets[index]['icons'], 
                                                              color: Colors.white,
                                                              size: 32,
                                                            ),
                                                            // SizedBox(width: 4),
                                                            // Icon(Icons.directions_bus, color: Colors.white),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(tickets[index]['names'], 
                                                          style: GoogleFonts.varelaRound(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.white
                                                          )
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Text(tickets[index]['notes'], 
                                                          style: GoogleFonts.signikaNegative(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                            color: tickets[index]['subcolors']
                                                          )
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: tickets[index].containsKey('discount')
                                                      ? Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.arrow_downward, 
                                                            size: 22, color: tickets[index]['colors'].withOpacity(0.65)
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text('${tickets[index]['discount'][0]}%',
                                                            style: GoogleFonts.nunito(
                                                              color: tickets[index]['colors'].withOpacity(0.65),
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w700
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                      : Text('Rp. ${_formatNumber(tickets[index]['prices'].toString())}', 
                                                        style: GoogleFonts.signikaNegative(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                          color: tickets[index]['colors'].withOpacity(0.65)
                                                        )
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }) + [ const Padding(padding: EdgeInsets.all(45)) ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
