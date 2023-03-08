import 'package:flutter/material.dart';

List<Map<String, dynamic>> addons = [
  {
    'selected': false,
    'name': 'Speaker',
    'icon': Icons.speaker_outlined,
    'withicon': Icons.speaker,
    'color': Colors.orange.shade600,
    'subname': '1 Jam',
    'price': 15000,
    'duration': null
  }, {
    'selected': false,
    'name': 'Listrik',
    'icon': Icons.bolt_outlined,
    'withicon': Icons.bolt,
    'color': Colors.blue.shade600,
    'subname': '1 Jam',
    'price': 30000,
    'duration': null
  }, {
    'selected': false,
    'name': 'Kursi Merah',
    'icon': Icons.chair_outlined,
    'withicon': Icons.chair,
    'color': Colors.red.shade400,
    'subname': '1 Kursi',
    'price': 5000,
    'duration': null
  }, {
    'selected': false,
    'name': 'Kursi',
    'icon': Icons.chair_alt_outlined,
    'withicon': Icons.chair_alt_rounded,
    'color': Colors.brown.shade600,
    'subname': '1 Kursi',
    'price': 2000,
    'duration': null
  }, {
    'selected': false,
    'name': 'Meja',
    'icon': Icons.table_bar_outlined,
    'withicon': Icons.table_bar,
    'color': Colors.brown.shade600,
    'subname': '1 Meja',
    'price': 5000,
    'duration': null
  }
];

List<Map<String, dynamic>> locations = [
  {
    'name': 'Pendopo',
    'image': 'pendopo_1.jpg',
    'icon': Icons.foundation,
    'price': 5000
  }, {
    'name': 'Kolam',
    'image': 'pool_1.jpg',
    'icon': Icons.pool,
    'price': 0
  }, {
    'name': 'Halaman Depan',
    'image': 'frontyard_1.jpg',
    'icon': Icons.grass,
    'price': 0
  }, {
    'name': 'Gazebo',
    'image': 'gazebo_2.jpg',
    'icon': Icons.cottage,
    'price': 0
  }, 
];

String findLocationImage(Map<String, dynamic> event) {
  String string = 'images/pendopo_1.jpg';
  for (var location in locations) { 
    if (location['name'] == event['location']) {
      string = 'images/${location['image']}';
    }
  }

  return string;
}

int countEventDuration(dynamic start, dynamic end) {
  int first = int.parse(start.toString().substring(0, start.toString().indexOf('.')));
  int last = int.parse(end.toString().substring(0, end.toString().indexOf('.')));
  int duration = last - first;
  return duration;
}
