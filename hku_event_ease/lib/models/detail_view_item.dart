class DetailViewItem {  
  final String eventId;
  final String coverPhotoLink;
  final String eventName;
  final String organizerName;
  final String venue;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String tagName;
  final String registerLink;
  final String description;

  DetailViewItem({
    required this.eventId,
    required this.coverPhotoLink,
    required this.eventName,
    required this.organizerName,
    required this.venue,
    required this.startDateTime,
    required this.endDateTime,
    required this.tagName,
    required this.registerLink,
    required this.description,
  });

  factory DetailViewItem.fromJson(Map<String, dynamic> json) {
    return DetailViewItem(
      eventId: json['eventId'],
      coverPhotoLink: json['coverPhotoLink'],
      eventName: json['eventName'],
      organizerName: json['organizerName'],
      venue: json['venue'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      tagName: json['tagName'],
      registerLink: json['registerLink'],
      description: json['description'],
    );
  }
}