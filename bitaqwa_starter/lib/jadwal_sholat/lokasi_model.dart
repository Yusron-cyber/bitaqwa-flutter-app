/// Model lokasi pengguna.
class LocationModel {
  final double latitude;
  final double longitude;
  final String city;
  final String district;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.district,
  });

  String get displayName {
    final cleanDistrict = district.trim();
    final cleanCity = city.trim();
    if (cleanDistrict.isEmpty || cleanDistrict == cleanCity) return cleanCity;
    return '$cleanDistrict, $cleanCity';
  }
}
