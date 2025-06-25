class AccessEntry {
  final String? userName;
  final String? locationName;
  final String? dateEntry;
  final String result;
  final double? confidence;

  AccessEntry({
    this.userName,
    this.locationName,
    required this.dateEntry,
    required this.result,
    this.confidence,
  });

  factory AccessEntry.fromJson(Map<String, dynamic> json) {
    return AccessEntry(
      userName: json['user_name'] as String?,
      locationName: json['location_name'] as String?,
      dateEntry: json['date_entry'],
      result: json['result'],
      confidence: json['confidence'] != null ? (json['confidence'] as num).toDouble() : null,
    );
  }

  @override
  String toString() {
    return 'AccessEntry( userName: $userName, locationName: $locationName, dateEntry: $dateEntry, result: $result, confidence: $confidence)';
  }
}