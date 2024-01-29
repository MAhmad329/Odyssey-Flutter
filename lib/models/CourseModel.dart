class Course {
  final String name;
  final String description;
  bool isInterested;

  Course({
    required this.name,
    required this.description,
    this.isInterested = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'isInterested': isInterested,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      name: map['name'],
      description: map['description'],
      isInterested: map['isInterested'] ?? false,
    );
  }
}
