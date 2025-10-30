import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/launches/data/launch_service.dart';
import 'package:space_x/features/launches/model/launch_model.dart';

part 'launches_state.dart';

class LaunchesCubit extends Cubit<LaunchesState> {
  LaunchesCubit({required this.launchService}) : super(const LaunchesState());

  final LaunchService launchService;

  Future<void> fetchLaunches({bool isRefresh = false}) async {
    if (state.status == LaunchStatus.loading || state.status == LaunchStatus.loadingMore) return;
    if (!state.hasNextPage && !isRefresh) return;

    final page = isRefresh ? 1 : state.page;

    if (isRefresh) {
      emit(state.copyWith(status: LaunchStatus.loading));
    } else {
      emit(state.copyWith(status: LaunchStatus.loadingMore));
    }

    try {
      final result = await launchService.getLaunches(
        page: page,
        query: state.searchQuery,
      );

      final newLaunches = (isRefresh || page == 1)
          ? result.launches
          : [ ...state.launches, ...result.launches ];

      emit(state.copyWith(
        status: LaunchStatus.success,
        launches: newLaunches,
        page: page + 1,
        hasNextPage: result.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(status: LaunchStatus.failure, error: e.toString()));
    }
  }

  Future<void> refresh() {
    emit(state.copyWith(isSearching: false, searchQuery: ''));
    return fetchLaunches(isRefresh: true);
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query, clearError: true));
    fetchLaunches(isRefresh: true);
  }

  void toggleSearch() {
    final isSearching = !state.isSearching;
    if (!isSearching && state.searchQuery.isNotEmpty) {
      refresh();
    } else {
      emit(state.copyWith(isSearching: isSearching));
    }
  }

  void toggleViewMode() {
    emit(state.copyWith(
      viewMode: state.viewMode == LaunchViewMode.list
          ? LaunchViewMode.grid
          : LaunchViewMode.list,
    ));
  }
}
