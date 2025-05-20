Map<String, dynamic> convertDatesToIsoStrings(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is DateTime) {
      return MapEntry(key, value.toIso8601String());
    }
    return MapEntry(key, value);
  });
}