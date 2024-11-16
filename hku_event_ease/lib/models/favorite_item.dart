class FavoriteItem {
  final String eventId;
  final bool isFavorite;

  FavoriteItem({required this.eventId, this.isFavorite = true});

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'isFavorite': isFavorite,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      eventId: json['eventId'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}