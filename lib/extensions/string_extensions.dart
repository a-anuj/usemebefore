import 'package:intl/intl.dart';

extension PrettyDate on String {
  String toPrettyDate() {
    List<String> parts = split('-');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    DateTime date = DateTime(year, month, day);
    String suffix = _getDaySuffix(day);
    String formattedMonth = DateFormat('MMM').format(date);

    return '$day$suffix $formattedMonth, $year';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}
