part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.step = OnboardingStep.welcome,
  });

  final OnboardingStep step;

  @override
  List<Object> get props => [step];

  OnboardingState copyWith({
    OnboardingStep? step,
  }) {
    return OnboardingState(
      step: step ?? this.step,
    );
  }
}
