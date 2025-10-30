import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/core/services/storage_service.dart';
import 'package:space_x/features/launches/presentation/pages/launches_page.dart';
import 'package:space_x/features/onboarding/presentation/cubit/onboarding_cubit.dart';
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
    final PageController pageController = PageController();

    final List<Widget> onboardingTabs = [
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
      body: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return PageView(
            controller: pageController,
            onPageChanged: (page) => context.read<OnboardingCubit>().changePage(page),
            children: onboardingTabs,
          );
        },
      ),
      floatingActionButton: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state.page < onboardingTabs.length - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else {
                final storageService = StorageService();
                storageService.setOnboardingCompleted();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LaunchesPage(),
                  ),
                );
              }
            },
            child: Icon(state.page < onboardingTabs.length - 1 ? Icons.arrow_forward : Icons.check),
          );
        },
      ),
    );
  }
}
