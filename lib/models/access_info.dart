class AccessEntry {
  final String? locationName;
  final String? dateEntry;
  final String? result;
  final double? confidence;

  AccessEntry({this.locationName, this.dateEntry, this.result, this.confidence});

  factory AccessEntry.fromJson(Map<String, dynamic> json) {
    return AccessEntry(
      locationName: json['location_name'],
      dateEntry: json['date_entry'],
      result: json['result'],
      confidence: double.tryParse(json['confidence'].toString()),
    );
  }
}