class Serializer {
  Map<String, String> pairs;

  Serializer() {
    pairs = new Map();
  }

  void addPair(String key, String value) {
    pairs[key] = value;
  }

  String serialize() {
    String output = '{';
    pairs.forEach((String key, String value) {
      key = _padIfNeeded(key);
      value = _padIfNeeded(value);
      output += '"$key":$value';
      if (key != pairs.keys.last) {
        output += ',';
      }
    });
    output += '}';
    return output;
  }

  static String _padIfNeeded(String value) {
    if (!value.contains('{') || !value.contains('"')) {
      return '"$value"';
    }
    return value;
  }
}
