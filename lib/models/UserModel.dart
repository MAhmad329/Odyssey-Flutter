class User {
  final String uid;
  final String? email;
  String? name;
  bool hasCompletedSetup;
  String? selectedInterest;
  String? assessmentLevel;

  User(this.uid, this.email,
      {this.name,
      this.hasCompletedSetup = false,
      this.selectedInterest,
      this.assessmentLevel});
}
