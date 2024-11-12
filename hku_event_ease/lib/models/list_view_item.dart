class ListViewItem {
  final String eventId;
  final String eventName;
  final String tagName;
  final DateTime startDateTime;

  const ListViewItem({
    required this.eventId,
    required this.eventName,
    required this.tagName,
    required this.startDateTime,
  });

  factory ListViewItem.fromJson(Map<String, dynamic> json) {
    return ListViewItem(
      eventId: json['eventId'],
      eventName: json['eventName'],
      tagName: json['tagName'],
      startDateTime: DateTime.parse(json['startDateTime']),
    );
  }
}