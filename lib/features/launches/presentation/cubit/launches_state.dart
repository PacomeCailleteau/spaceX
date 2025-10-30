part of 'launches_cubit.dart';

enum LaunchStatus { initial, loading, success, failure }

enum LaunchViewMode { list, grid }

class LaunchesState extends Equatable {
  const LaunchesState({
    this.status = LaunchStatus.initial,
    this.launches = const [],
    this.viewMode = LaunchViewMode.list,
    this.error,
  });

  final LaunchStatus status;
  final List<Launch> launches;
  final LaunchViewMode viewMode;
  final String? error;

  @override
  List<Object?> get props => [status, launches, viewMode, error];

  LaunchesState copyWith({
    LaunchStatus? status,
    List<Launch>? launches,
    LaunchViewMode? viewMode,
    String? error,
  }) {
    return LaunchesState(
      status: status ?? this.status,
      launches: launches ?? this.launches,
      viewMode: viewMode ?? this.viewMode,
      error: error ?? this.error,
    );
  }
}
