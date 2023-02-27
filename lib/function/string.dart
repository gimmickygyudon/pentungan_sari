import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _locale = 'id';
String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));
String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

extension StringExtension on String {
  String toTitle() {
    final List<String> splitStr = split(' ');
    for (int i = 0; i < splitStr.length; i++) {
      splitStr[i] = '${splitStr[i][0].toUpperCase()}${splitStr[i].substring(1)}';
    }
    final output = splitStr.join(' ');
    return output;
  }
}

TextEditingValue currencyFormat(String value, TextEditingController textEditingController) {
  int dots = 0;
  value = _formatNumber(value.replaceAll('.', ''));
  int diff = value.length - textEditingController.text.length;

  int position = textEditingController.text.length - textEditingController.selection.base.offset;
  if (position < 6 && diff > 1) dots = 1;
  if (position < 3 && diff < 2 && diff != 0) dots = 1;
  if (position < 3 && diff > 1) dots = 2;

  TextEditingValue result = textEditingController.value.copyWith(
    text: value, selection: TextSelection.collapsed(
      offset: textEditingController.selection.base.offset + dots,
    ),
  );

  return result;
}

TextEditingValue nullableNum(String value, TextEditingController textEditingController, [Function? action]) {
  String string = textEditingController.text;
  TextEditingValue result = textEditingController.value;

  if (value.isEmpty) {
    result = textEditingController.value.copyWith(
      text: '0', selection: TextSelection.collapsed(
        offset: textEditingController.selection.base.offset + 1,
      ),
    );
    if (action != null) action(0);
  } else if (value.isNotEmpty && action != null) {
    action(int.parse(value));
  }

  for (int i = 0; i < value.length; i++) {
    if (string.substring(0, i) == '0') { 
      string = string.substring(1, string.length);
      result = textEditingController.value.copyWith(
        text: string, selection: const TextSelection.collapsed(
          offset: 1,
        ),
      );
      if (action != null) action(int.parse(string));
    }
  }

  return result;
}
