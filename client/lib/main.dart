import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setUrlStrategy(PathUrlStrategy());

  // Initialize Offline Caching
  await StorageService.init();

  // Initialize Supabase Auth & DB client
  try {
    const url = AppConstants.supabaseUrl;
    const key = AppConstants.supabaseAnonKey;

    if (url.isEmpty || key.isEmpty) {
      debugPrint(
          '⚠️ Supabase credentials not provided via --dart-define. Running in offline/demo mode.');
    } else {
      await Supabase.initialize(url: url, publishableKey: key);
    }
  } catch (e) {
    debugPrint(
        '⚠️ Supabase initialization failed: $e. Running in offline/demo mode.');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppConstants.appShortName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
    );
  }
}
