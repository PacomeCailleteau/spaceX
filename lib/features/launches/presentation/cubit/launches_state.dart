part of 'launches_cubit.dart';

sealed class LaunchesState extends Equatable {
  const LaunchesState();

  @override
  List<Object?> get props => [];
}

final class LaunchesInitial extends LaunchesState {}

final class LaunchesLoading extends LaunchesState {}

final class LaunchesLoadingMore extends LaunchesState {
  final List<Launch> launches;
  const LaunchesLoadingMore({required this.launches});

  @override
  List<Object?> get props => [launches];
}

final class LaunchesSuccess extends LaunchesState {
  final List<Launch> launches;
  final bool hasNextPage;

  const LaunchesSuccess({
    required this.launches,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [launches, hasNextPage];

  LaunchesSuccess copyWith({
    List<Launch>? launches,
    bool? hasNextPage,
  }) {
    return LaunchesSuccess(
      launches: launches ?? this.launches,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}

final class LaunchesFailure extends LaunchesState {
  final String error;
  final List<Launch> launches; // Keep existing launches on failure

  const LaunchesFailure({required this.error, this.launches = const []});

  @override
  List<Object?> get props => [error, launches];
}
