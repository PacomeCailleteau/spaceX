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
        image: 'assets/icon/logo.png',
        title: 'Welcome to SpaceX Tracker',
        description: 'Track all past, present, and future SpaceX launches at your fingertips.',
      ),
      const OnboardingTab(
        image: 'assets/icon/details.png',
        title: 'In-Depth Details',
        description: 'Get detailed information about each launch, from rocket specs to mission outcomes.',
      ),
      const OnboardingTab(
        image: 'assets/icon/favorites.png',
        title: 'Track Your Favorites',
        description: 'Never miss a launch! Add upcoming missions to your favorites to keep them on your radar.',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
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
