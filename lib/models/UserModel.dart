class User {
  final String uid;
  final String? email;
  bool hasCompletedSetup;
  String? selectedInterest;

  User(this.uid, this.email,
      {this.hasCompletedSetup = false, this.selectedInterest});
}
