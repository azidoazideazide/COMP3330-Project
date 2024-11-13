class DetailViewItem {  
  final String eventId;
  final String eventName;
  final String organizerName;
  final String venue;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String tagName;
  final String registerLink;

  DetailViewItem({
    required this.eventId,
    required this.eventName,
    required this.organizerName,
    required this.venue,
    required this.startDateTime,
    required this.endDateTime,
    required this.tagName,
    required this.registerLink,
  });

  factory DetailViewItem.fromJson(Map<String, dynamic> json) {
    return DetailViewItem(
      eventId: json['eventId'],
      eventName: json['eventName'],
      organizerName: json['organizerName'],
      venue: json['venue'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      tagName: json['tagName'],
      registerLink: json['registerLink'],
    );
  }
}