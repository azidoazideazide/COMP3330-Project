class GridViewItem {
  final String eventId;
  final String eventName;
  final String tagName;
  final DateTime startDateTime;
  final String coverPhotoLink;

  const GridViewItem({
    required this.eventId,
    required this.eventName,
    required this.tagName,
    required this.startDateTime,
    required this.coverPhotoLink,
  });

  factory GridViewItem.fromJson(Map<String, dynamic> json) {
    return GridViewItem(
      eventId: json['eventId'],
      eventName: json['eventName'],
      tagName: json['tagName'],
      startDateTime: DateTime.parse(json['startDateTime']),
      coverPhotoLink: json['coverPhotoLink'],
    );
  }
}
