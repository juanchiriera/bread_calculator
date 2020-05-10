import 'package:flutter/services.dart';
import 'dart:math' as math;


class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter();



  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
      String value = newValue.text;
      if (value.contains(".") || value.contains(",")){
        truncated = oldValue.text;
        newSelection = oldValue.selection;
        
        return TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
      }
    return newValue;
  }
}