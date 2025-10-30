import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }
}
