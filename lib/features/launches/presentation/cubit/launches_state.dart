part of 'launches_cubit.dart';

enum LaunchStatus { initial, loading, loadingMore, success, failure }

enum LaunchViewMode { list, grid }

class LaunchesState extends Equatable {
  const LaunchesState({
    this.status = LaunchStatus.initial,
    this.launches = const [],
    this.viewMode = LaunchViewMode.list,
    this.isSearching = false,
    this.searchQuery = '',
    this.page = 1,
    this.hasNextPage = true,
    this.error,
  });

  final LaunchStatus status;
  final List<Launch> launches;
  final LaunchViewMode viewMode;
  final bool isSearching;
  final String searchQuery;
  final int page;
  final bool hasNextPage;
  final String? error;

  @override
  List<Object?> get props => [
        status,
        launches,
        viewMode,
        isSearching,
        searchQuery,
        page,
        hasNextPage,
        error,
      ];

  LaunchesState copyWith({
    LaunchStatus? status,
    List<Launch>? launches,
    LaunchViewMode? viewMode,
    bool? isSearching,
    String? searchQuery,
    int? page,
    bool? hasNextPage,
    String? error,
    // Helper to clear error message on new actions
    bool clearError = false,
  }) {
    return LaunchesState(
      status: status ?? this.status,
      launches: launches ?? this.launches,
      viewMode: viewMode ?? this.viewMode,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      error: clearError ? null : error ?? this.error,
    );
  }
}
