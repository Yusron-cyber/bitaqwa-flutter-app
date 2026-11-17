import 'package:bitaqwa/jadwal_sholat/lokasi_model.dart';
import 'package:bitaqwa/jadwal_sholat/lokasi_service.dart';
import 'package:bitaqwa/jadwal_sholat/sholat_service.dart';
import 'package:bitaqwa/jadwal_sholat/waktu_sholat_model.dart';
import 'package:flutter/foundation.dart';

enum PrayerLoadStatus { idle, loading, ready, error }

enum PrayerErrorType { location, permission, network, unknown }

/// Sumber data tunggal untuk jadwal sholat.
///
/// Dashboard dan halaman jadwal sholat berbagi controller ini sehingga lokasi
/// dan jadwal hanya diambil sekali, serta status loading/error selalu sama.
class PrayerTimesController extends ChangeNotifier {
  PrayerTimesController._();

  static final PrayerTimesController instance = PrayerTimesController._();

  final LocationService _locationService = LocationService();
  final PrayerService _prayerService = PrayerService();

  PrayerLoadStatus _status = PrayerLoadStatus.idle;
  LocationModel? _location;
  PrayerTimeModel? _times;
  DateTime? _lastUpdated;
  String? _errorMessage;
  PrayerErrorType _errorType = PrayerErrorType.unknown;

  PrayerLoadStatus get status => _status;
  LocationModel? get location => _location;
  PrayerTimeModel? get times => _times;
  DateTime? get lastUpdated => _lastUpdated;
  String? get errorMessage => _errorMessage;
  PrayerErrorType get errorType => _errorType;

  bool get isLoading => _status == PrayerLoadStatus.loading;
  bool get isReady => _status == PrayerLoadStatus.ready && _times != null;
  bool get hasError => _status == PrayerLoadStatus.error;

  bool get canOpenLocationSettings =>
      _errorType == PrayerErrorType.location ||
      _errorType == PrayerErrorType.permission;

  /// Memuat data jika belum pernah dimuat pada hari ini.
  Future<void> ensureLoaded() async {
    if (_status == PrayerLoadStatus.loading) return;
    if (_status == PrayerLoadStatus.ready &&
        _lastUpdated != null &&
        _isSameDay(_lastUpdated!, DateTime.now())) {
      return;
    }
    await load();
  }

  Future<void> load({bool force = false}) async {
    if (_status == PrayerLoadStatus.loading) return;
    if (!force &&
        _status == PrayerLoadStatus.ready &&
        _lastUpdated != null &&
        _isSameDay(_lastUpdated!, DateTime.now())) {
      return;
    }

    _status = PrayerLoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final resolvedLocation = await _locationService.getCurrentLocation();
      final prayerTimes = await _prayerService.getPrayerTimes(
        latitude: resolvedLocation.latitude,
        longitude: resolvedLocation.longitude,
      );

      if (prayerTimes == null) {
        _status = PrayerLoadStatus.error;
        _errorType = PrayerErrorType.network;
        _errorMessage =
            'Jadwal sholat tidak dapat diambil. Periksa koneksi internet '
            'Anda lalu coba lagi.';
        notifyListeners();
        return;
      }

      _location = resolvedLocation;
      _times = prayerTimes;
      _lastUpdated = DateTime.now();
      _status = PrayerLoadStatus.ready;
      _errorType = PrayerErrorType.unknown;
      _errorMessage = null;
      notifyListeners();
    } on LocationException catch (error) {
      _status = PrayerLoadStatus.error;
      _errorType = error.kind == LocationErrorKind.serviceDisabled
          ? PrayerErrorType.location
          : PrayerErrorType.permission;
      _errorMessage = error.message;
      notifyListeners();
    } catch (error) {
      debugPrint('PrayerTimesController: $error');
      _status = PrayerLoadStatus.error;
      _errorType = PrayerErrorType.unknown;
      _errorMessage =
          'Terjadi kesalahan saat memuat jadwal sholat. Silakan coba lagi.';
      notifyListeners();
    }
  }

  Future<void> refresh() => load(force: true);

  Future<void> openSettings() async {
    if (_errorType == PrayerErrorType.location) {
      await _locationService.openLocationSettings();
    } else {
      await _locationService.openAppSettings();
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
