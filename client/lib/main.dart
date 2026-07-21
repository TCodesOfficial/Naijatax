import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'widgets/app_logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  setUrlStrategy(PathUrlStrategy());

  // Show branded loading screen immediately
  runApp(const ProviderScope(child: LoadingApp()));

  // Initialize Hive (fast, local) and Supabase (network) in parallel
  await Future.wait([
    StorageService.init(),
    _initSupabase(),
  ]);

  // Re-run with the real app after initialization
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initSupabase() async {
  try {
    const url = AppConstants.supabaseUrl;
    const key = AppConstants.supabaseAnonKey;

    if (url.isEmpty || key.isEmpty) {
      debugPrint('Supabase credentials not provided. Running in offline mode.');
    } else {
      await Supabase.initialize(url: url, publishableKey: key);
    }
  } catch (e) {
    debugPrint('Supabase init failed: $e');
  }
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00288E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        backgroundColor: Color(0xFFF9F9FF),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo(radius: 48, iconSize: 52),
              SizedBox(height: 32),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF00288E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
    );
  }
}
