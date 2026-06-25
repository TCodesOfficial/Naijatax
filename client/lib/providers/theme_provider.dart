import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    // Load synchronously from Hive (already initialized before runApp)
    return StorageService.getSetting<bool>('darkMode') ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    await StorageService.setSetting('darkMode', state);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);
