import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeFormField extends StatelessWidget {
  final DateTime initialTime;
  final format = DateFormat("HH:mm");

  TimeFormField(this.initialTime);

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      format: format,
      onShowPicker: (context, currentValue) async {
        final time = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
        if (time == null)
          return currentValue;
        else
          return DateTimeField.convert(time);
      },
    );
  }
}
