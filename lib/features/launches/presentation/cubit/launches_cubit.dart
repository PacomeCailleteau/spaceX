import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/launches/data/launch_service.dart';
import 'package:space_x/features/launches/model/launch_model.dart';

part 'launches_state.dart';

class LaunchesCubit extends Cubit<LaunchesState> {
  LaunchesCubit({required this.launchService}) : super(const LaunchesState());

  final LaunchService launchService;

  Future<void> fetchLaunches() async {
    emit(state.copyWith(status: LaunchStatus.loading));
    try {
      final launches = await launchService.getLatestLaunches();
      emit(state.copyWith(status: LaunchStatus.success, launches: launches));
    } catch (e) {
      emit(state.copyWith(status: LaunchStatus.failure, error: e.toString()));
    }
  }

  void toggleViewMode() {
    emit(state.copyWith(
        viewMode: state.viewMode == LaunchViewMode.list
            ? LaunchViewMode.grid
            : LaunchViewMode.list));
  }
}
