/// Model satu bacaan doa.
class Doa {
  /// Lokasi gambar ikon doa.
  final String image;

  /// Judul nama doa.
  final String title;

  /// Teks bacaan tulisan Arab.
  final String arabicText;

  /// Transliterasi Latin untuk membantu pengguna yang belum lancar Arab.
  final String latin;

  /// Arti / terjemahan bahasa Indonesia.
  final String translation;

  /// Riwayat hadits / sumber rujukan doa.
  final String reference;

  const Doa({
    required this.image,
    required this.title,
    required this.arabicText,
    required this.latin,
    required this.translation,
    required this.reference,
  });
}
