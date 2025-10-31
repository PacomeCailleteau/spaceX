import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/onboarding/enum/onboarding_step.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void changePage(int pageIndex) {
    if (pageIndex < 0 || pageIndex >= OnboardingStep.values.length) return;
    final newStep = OnboardingStep.values[pageIndex];
    emit(state.copyWith(step: newStep));
  }
}
