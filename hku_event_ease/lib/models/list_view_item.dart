class ListViewItem {
  final String eventId;
  final String eventName;
  final String organizerName;
  final String tagName;
  final DateTime startDateTime;

  const ListViewItem({
    required this.eventId,
    required this.eventName,
    required this.organizerName,
    required this.tagName,
    required this.startDateTime,
  });

  factory ListViewItem.fromJson(Map<String, dynamic> json) {
    return ListViewItem(
      eventId: json['eventId'],
      eventName: json['eventName'],
      organizerName: json['organizerName'],
      tagName: json['tagName'],
      startDateTime: DateTime.parse(json['startDateTime']),
    );
  }
}