class Format{
  static String dollarFormat(double value){
    return '\$'+value.toStringAsFixed(value.truncateToDouble() == value ? 0:2 );
  }
}