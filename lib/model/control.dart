abstract class Control {
  bool isNewUser();

  bool passwordIsValid(String secret);

  void initialize();

  void setPassword(String newSecret);

  void save();
}
