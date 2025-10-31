import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/core/user/local_user_cubit.dart';
import 'package:space_x/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:space_x/features/onboarding/enum/onboarding_step.dart';
import 'package:space_x/features/onboarding/presentation/widgets/onboarding_tab.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    final onboardingTabs = [
      const OnboardingTab(
        title: 'Welcome to SpaceX',
        description: 'Explore the world of SpaceX and keep track of all the latest launches.',
      ),
      const OnboardingTab(
        title: 'Launch Details',
        description: 'Get detailed information about each launch, including the rocket, payload, and mission outcome.',
      ),
      const OnboardingTab(
        title: 'Favorites',
        description: 'Add your favorite launches to a special list for quick and easy access.',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000020),
      body: PageView(
        controller: pageController,
        onPageChanged: (pageIndex) => context.read<OnboardingCubit>().changePage(pageIndex),
        children: onboardingTabs,
      ),
      floatingActionButton: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final isLastStep = state.step == OnboardingStep.favorites;
          return FloatingActionButton(
            onPressed: () {
              if (!isLastStep) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else {
                context.read<LocalUserCubit>().completeOnboarding();
              }
            },
            child: Icon(isLastStep ? Icons.check : Icons.arrow_forward),
          );
        },
      ),
    );
  }
}
