/// Interface for objects that can be serialized into a JSON string.
abstract class Serializable {
  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize;
}
