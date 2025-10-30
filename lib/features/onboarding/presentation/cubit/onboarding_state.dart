part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.page = 0,
  });

  final int page;

  @override
  List<Object> get props => [page];

  OnboardingState copyWith({
    int? page,
  }) {
    return OnboardingState(
      page: page ?? this.page,
    );
  }
}
