/// Nama rute resmi aplikasi. Semua tombol dashboard memakai tabIndex,
/// sementara named route tetap disediakan agar tautan/rute tidak pernah putus.
abstract final class AppRoutes {
  static const String dashboard = '/';
  static const String prayer = '/jadwal-sholat';
  static const String doa = '/doa';
  static const String kajian = '/video-kajian';
  static const String zakat = '/zakat';

  static int tabIndexFor(String? route) {
    switch (route) {
      case prayer:
        return 1;
      case doa:
        return 2;
      case kajian:
        return 3;
      case zakat:
        return 4;
      default:
        return 0;
    }
  }
}
