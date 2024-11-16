class ListViewItem {
  final String eventId;
  final String eventName;
  final String organizerName;
  final String tagName;
  final DateTime startDateTime;
  final String coverPhotoLink;
  bool isFavorite;

ListViewItem({
    required this.eventId,
    required this.eventName,
    required this.organizerName,
    required this.tagName,
    required this.startDateTime,
    required this.coverPhotoLink,
    this.isFavorite = false, // default to not favorite
  });

    // Method to convert the object to JSON
  Map<String, dynamic> toFavoriteJson() {
    return {
      'eventId': eventId,
      'isFavorite': isFavorite,
    };
  }

  factory ListViewItem.fromJson(Map<String, dynamic> json) {
    return ListViewItem(
      eventId: json['eventId'],
      eventName: json['eventName'],
      organizerName: json['organizerName'],
      tagName: json['tagName'],
      startDateTime: DateTime.parse(json['startDateTime']),
      coverPhotoLink: json['coverPhotoLink'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
