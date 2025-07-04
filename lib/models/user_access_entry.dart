
class UserAccessEntry {
  final int accessId;
  final String locationName;
  final String dateEntry;
  final String result;
  final double? confidence;

  UserAccessEntry({
    required this.accessId,
    required this.locationName,
    required this.dateEntry,
    required this.result,
    this.confidence,
  });

  factory UserAccessEntry.fromJson(Map<String, dynamic> json) {

    int parsedId = 0;
    final dynamic rawId = json['access_id'];
    if (rawId is int) {
      parsedId = rawId;
    } else if (rawId is String) {
      parsedId = int.tryParse(rawId) ?? 0;
    }


    final String locationName = json['location_name'] as String;

    final String result = json['result'] as String;

    final String dateEntry = json['date_entry'] as String;

    double? parsedConfidence;
    final dynamic rawConfidence = json['confidence'];
    if (rawConfidence != null) {
      if (rawConfidence is String) {
        parsedConfidence = double.tryParse(rawConfidence);
      } else if (rawConfidence is num) {
        parsedConfidence = rawConfidence.toDouble();
      }
    }

    return UserAccessEntry(
      accessId: parsedId,
      locationName: locationName,
      dateEntry: dateEntry,
      result: result,
      confidence: parsedConfidence,
    );
  }

  @override
  String toString() {
    return 'UserAccessEntry(id: $accessId, locationName: $locationName, dateEntry: $dateEntry, result: $result, confidence: $confidence)';
  }
}