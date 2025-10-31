import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/core/services/storage_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.storageService}) : super(const ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  final StorageService storageService;

  Future<void> _loadTheme() async {
    final themeMode = await storageService.getThemeMode();
    emit(ThemeState(themeMode));
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    await storageService.setThemeMode(themeMode);
    emit(ThemeState(themeMode));
  }
}
