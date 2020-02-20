

abstract class Unserializer {


  dynamic unserializeValue(Map value);
}

class InvalidSerializedValueError extends Error {}

class UnknownMapKeyError extends Error {}
