class AccessEntry {
  final String userName;
  final String locationName;
  final String? dateEntry;
  final String result;
  final double? confidence;

  AccessEntry({
    required this.userName,
    required this.locationName,
    required this.dateEntry,
    required this.result,
    this.confidence,
  });

  factory AccessEntry.fromJson(Map<String, dynamic> json) {
    try {
      double? parsedConfidence;
      if (json['confidence'] != null) {
        if (json['confidence'] is String) {
          parsedConfidence = double.tryParse(json['confidence']);
        } else if (json['confidence'] is num) {
          parsedConfidence = (json['confidence'] as num).toDouble();
        }
      }

      return AccessEntry(
        userName: json['user_name']! as String,
        locationName: json['location_name'] as String,
        dateEntry: json['date_entry'],
        result: json['result'],
        confidence: parsedConfidence,
      );
    } catch (e) {
      rethrow;
    }

  }

  @override
  String toString() {
    return 'AccessEntry( userName: $userName, locationName: $locationName, dateEntry: $dateEntry, result: $result, confidence: $confidence)';
  }
}