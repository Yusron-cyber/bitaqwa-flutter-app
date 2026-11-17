import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan doa favorit pengguna secara lokal.
///
/// Memakai judul doa sebagai identitas stabil karena seluruh judul doa unik.
class BookmarkStore extends ChangeNotifier {
  BookmarkStore._();

  static final BookmarkStore instance = BookmarkStore._();

  static const String _storageKey = 'bitaqwa.bookmarked_doa';

  SharedPreferences? _preferences;
  Set<String> _bookmarks = <String>{};

  Set<String> get bookmarks => Set.unmodifiable(_bookmarks);
  int get count => _bookmarks.length;

  bool contains(String doaTitle) => _bookmarks.contains(doaTitle);

  Future<void> load() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      _bookmarks = (_preferences?.getStringList(_storageKey) ?? <String>[])
          .toSet();
      notifyListeners();
    } catch (error) {
      debugPrint('BookmarkStore: gagal memuat data ($error)');
    }
  }

  Future<void> toggle(String doaTitle) async {
    if (_bookmarks.contains(doaTitle)) {
      _bookmarks.remove(doaTitle);
    } else {
      _bookmarks.add(doaTitle);
    }
    notifyListeners();

    try {
      await _preferences?.setStringList(_storageKey, _bookmarks.toList());
    } catch (error) {
      debugPrint('BookmarkStore: gagal menyimpan data ($error)');
    }
  }
}
