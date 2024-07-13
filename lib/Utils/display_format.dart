
import 'package:intl/intl.dart';

final ddMMMMYYYYhhmmaFormat = new DateFormat('dd MMMM yyyy | hh:mm a');
final ddMMMYYYYFormat = new DateFormat('dd MMM yyyy');
final ddMMYYYYFormat = new DateFormat('dd/MM/yyyy');
final hHMMAFormat = new DateFormat('hh:mm a');

String getDayFormat(DateTime? dateTime, DateFormat formatString) {
  if(dateTime==null) {
    return "-";
  }
  return formatString.format(dateTime);
}

int calculateDifference(DateTime date) {
/**
  Yesterday : calculateDifference(date) == -1.
  Today : calculateDifference(date) == 0.
  Tomorrow : calculateDifference(date) == 1.
 **/
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}