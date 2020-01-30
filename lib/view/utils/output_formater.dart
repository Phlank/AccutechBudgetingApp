class Format{
  static String dollarFormat(double value){
    return '\$'+value.toStringAsFixed(value.truncateToDouble() == value ? 0:2 );
  }

  static String titleFormat(String title){
    return title[0].toUpperCase() + title.substring(1);
  }
}