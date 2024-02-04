class Topic {
  final String title;
  final String content;
  final String? codeExample;

  Topic({
    required this.title,
    required this.content,
    this.codeExample,
  });
}

class Course {
  final String courseID;
  final String name;
  final String description;
  bool isInterested;
  final List<Topic> topics;
  int lastTopicIndex;

  Course({
    required this.courseID,
    required this.name,
    required this.description,
    this.isInterested = false,
    required this.topics,
    this.lastTopicIndex = 0, // Default to the first topic
  });

  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'name': name,
      'description': description,
      'isInterested': isInterested,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map, [List<Topic>? topics]) {
    return Course(
      courseID: map['courseID'],
      name: map['name'],
      description: map['description'],
      isInterested: map['isInterested'] ?? false,
      topics: topics ?? [],
      lastTopicIndex: map['lastTopicIndex'] ?? 0,
    );
  }
}
