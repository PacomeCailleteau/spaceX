import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_x/features/launches/enum/launch_view_mode.dart';

class StorageService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _themeKey = 'theme';
  static const String _viewModeKey = 'view_mode';

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    return ThemeMode.values[themeIndex];
  }

  Future<void> setViewMode(LaunchViewMode viewMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_viewModeKey, viewMode.index);
  }

  Future<LaunchViewMode> getViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final viewModeIndex = prefs.getInt(_viewModeKey) ?? 0;
    return LaunchViewMode.values[viewModeIndex];
  }
}
