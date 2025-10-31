import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/core/services/storage_service.dart';
import 'package:space_x/features/launches/enum/launch_view_mode.dart';

part 'view_mode_state.dart';

class ViewModeCubit extends Cubit<ViewModeState> {
  ViewModeCubit({required this.storageService}) : super(const ViewModeState()) {
    _loadViewMode();
  }

  final StorageService storageService;

  Future<void> _loadViewMode() async {
    final viewMode = await storageService.getViewMode();
    emit(state.copyWith(viewMode: viewMode));
  }

  void toggleViewMode() {
    final newMode =
        state.viewMode == LaunchViewMode.list ? LaunchViewMode.grid : LaunchViewMode.list;
    storageService.setViewMode(newMode);
    emit(state.copyWith(viewMode: newMode));
  }
}
