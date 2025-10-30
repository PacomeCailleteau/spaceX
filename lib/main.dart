import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:space_x/core/services/storage_service.dart';
import 'package:space_x/features/favorites/data/favorite_service.dart';
import 'package:space_x/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:space_x/features/launches/data/launch_service.dart';
import 'package:space_x/features/launches/presentation/cubit/launches_cubit.dart';
import 'package:space_x/features/launches/presentation/pages/launches_page.dart';
import 'package:space_x/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:space_x/features/settings/presentation/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final storageService = StorageService();
  final showOnboarding = !(await storageService.isOnboardingCompleted());
  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    // Instantiate services once
    final launchService = LaunchService();
    final favoriteService = FavoriteService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) => LaunchesCubit(launchService: launchService),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(
            favoriteService: favoriteService,
            launchService: launchService,
          )..loadFavorites(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'SpaceX',
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              textTheme: GoogleFonts.exo2TextTheme(
                Theme.of(context).textTheme,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
                surface: const Color(0xFF000020),
              ),
              textTheme: GoogleFonts.exo2TextTheme(
                Theme.of(context).primaryTextTheme.apply(
                      bodyColor: Colors.white,
                      displayColor: Colors.white,
                    ),
              ),
              useMaterial3: true,
            ),
            home: showOnboarding ? const OnboardingPage() : const LaunchesPage(),
          );
        },
      ),
    );
  }
}
