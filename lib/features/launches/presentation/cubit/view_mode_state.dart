part of 'view_mode_cubit.dart';

class ViewModeState extends Equatable {
  const ViewModeState({this.viewMode = LaunchViewMode.list});

  final LaunchViewMode viewMode;

  @override
  List<Object> get props => [viewMode];

  ViewModeState copyWith({LaunchViewMode? viewMode}) {
    return ViewModeState(
      viewMode: viewMode ?? this.viewMode,
    );
  }
}
