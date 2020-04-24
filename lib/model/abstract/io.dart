/// Interface for objects that are used to load and save data.
abstract class IO {

  /// Load the data of an object from disk.
  Future<Object> load();

  /// Save the data of an object to disk.
  Future save();
}
