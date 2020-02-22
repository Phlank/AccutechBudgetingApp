import 'package:budgetflow/model/budget/category/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Format {

  static String dynamicFormating(dynamic d){
    switch(d.runtimeType){
      case num:
        return dollarFormat(d);
      case DateTime:
        return dateFormat(d);
      case String:
        return titleFormat(d);
      case Category:
        return titleFormat(d.value());
      default:
        return 'Error';
    }
  }

  static String dollarFormat(double value) {
    if(value < 0){
      return '-\$'+(value.abs()).toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    }
    return '\$' + value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  static String titleFormat(String title) {
    return title[0].toUpperCase() + title.substring(1);
  }

  static String dateFormat(DateTime dateTime) {
    DateFormat dMy = new DateFormat('LLLL d, y');
    DateFormat jm = new DateFormat('jm');
    return dMy.format(dateTime) + ' ' + jm.format(dateTime);
  }

  static Color deltaColor(double delta) {
    if (delta < 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
