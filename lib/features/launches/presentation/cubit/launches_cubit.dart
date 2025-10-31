import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/launches/data/launch_service.dart';
import 'package:space_x/features/launches/model/launch_model.dart';

part 'launches_state.dart';

class LaunchesCubit extends Cubit<LaunchesState> {
  LaunchesCubit({required this.launchService}) : super(LaunchesInitial());

  final LaunchService launchService;
  String _searchQuery = '';
  int _page = 1;

  Future<void> fetchLaunches({bool isRefresh = false}) async {
    if (isRefresh) {
      _page = 1;
      emit(LaunchesLoading());
    } else {
      if (state is! LaunchesSuccess) return;
      final successState = state as LaunchesSuccess;
      if (!successState.hasNextPage) return;
      emit(LaunchesLoadingMore(launches: successState.launches));
    }

    try {
      final result = await launchService.getLaunches(
        page: _page,
        query: _searchQuery,
      );

      List<Launch> currentLaunches = [];
      if (state is LaunchesSuccess) {
        currentLaunches = (state as LaunchesSuccess).launches;
      } else if (state is LaunchesLoadingMore) {
        currentLaunches = (state as LaunchesLoadingMore).launches;
      }

      final newLaunches = isRefresh ? result.launches : [...currentLaunches, ...result.launches];

      _page++;
      emit(LaunchesSuccess(launches: newLaunches, hasNextPage: result.hasNextPage));
    } catch (e) {
      emit(LaunchesFailure(error: e.toString()));
    }
  }

  Future<void> refresh() {
    _searchQuery = '';
    return fetchLaunches(isRefresh: true);
  }

  void search(String query) {
    _searchQuery = query;
    fetchLaunches(isRefresh: true);
  }
}
