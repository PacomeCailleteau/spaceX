part of 'local_user_cubit.dart';

sealed class LocalUserState extends Equatable {
  const LocalUserState();

  @override
  List<Object> get props => [];
}

final class LocalUserInitial extends LocalUserState {}

final class LocalUserLoading extends LocalUserState {}

final class LocalUserSuccess extends LocalUserState {
  final bool showOnboarding;

  const LocalUserSuccess(this.showOnboarding);

  @override
  List<Object> get props => [showOnboarding];
}
