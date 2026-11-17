import 'package:bitaqwa/core/navigation/app_routes.dart';
import 'package:bitaqwa/core/navigation/main_shell.dart';
import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/data/bookmark_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await BookmarkStore.instance.load();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(const BitaqwaApp());
}

class BitaqwaApp extends StatelessWidget {
  const BitaqwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitaqwa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      scrollBehavior: const AppScrollBehavior(),
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.dashboard,
      onGenerateRoute: (settings) {
        final name = settings.name ?? AppRoutes.dashboard;
        if (_knownRoutes.contains(name)) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => MainShell(initialIndex: AppRoutes.tabIndexFor(name)),
          );
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => NotFoundScreen(route: name),
        );
      },
    );
  }

  static const Set<String> _knownRoutes = {
    AppRoutes.dashboard,
    AppRoutes.prayer,
    AppRoutes.doa,
    AppRoutes.kajian,
    AppRoutes.zakat,
  };
}

/// Halaman pengaman jika ada rute yang tidak dikenal.
///
/// Tidak pernah menampilkan layar kosong dan selalu menyediakan jalan kembali.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.explore_off_rounded,
                  size: 48,
                  color: AppColors.sage500,
                ),
                const SizedBox(height: 16),
                Text('Halaman tidak ditemukan', style: AppText.h2),
                const SizedBox(height: 8),
                Text(
                  'Rute "$route" tidak tersedia. Silakan kembali ke beranda.',
                  textAlign: TextAlign.center,
                  style: AppText.body,
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.dashboard,
                      (route) => false,
                    );
                  },
                  child: const Text('Kembali ke Beranda'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
