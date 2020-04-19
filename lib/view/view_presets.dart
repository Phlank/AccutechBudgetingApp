import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TextStyle presets
TextStyle listItemTextStyle = TextStyle(fontSize: 16);
TextStyle transactionTopRowTextStyle = TextStyle(
  fontSize: 20,
  fontStyle: FontStyle.normal,
);
TextStyle transactionBottomRowTextStyle = TextStyle(
  fontSize: 16,
  fontStyle: FontStyle.normal,
);

// EdgeInsets presets
EdgeInsets smallEdgeInsets = EdgeInsets.all(8);
EdgeInsets mediumEdgeInsets = EdgeInsets.all(16);
EdgeInsets largeEdgeInsets = EdgeInsets.all(24);

// DateFormat presets
final dateFormatString = 'MMM d, yyyy'; // Jan 23, 1987
final timeFormatString = 'jm'; // 12-hour hh:mm am/pm
final dateTimeFormatString = 'MMM d, yyyy jm';
final defaultDateFormat = DateFormat(dateFormatString);
final defaultTimeFormat = DateFormat(timeFormatString);
final defaultDateTimeFormat = DateFormat(dateTimeFormatString);
