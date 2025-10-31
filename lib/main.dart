import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:space_x/core/services/storage_service.dart';
import 'package:space_x/core/user/local_user_cubit.dart';
import 'package:space_x/features/favorites/data/favorite_service.dart';
import 'package:space_x/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:space_x/features/launches/data/launch_service.dart';
import 'package:space_x/features/launches/presentation/cubit/launches_cubit.dart';
import 'package:space_x/features/launches/presentation/cubit/view_mode_cubit.dart';
import 'package:space_x/features/launches/presentation/pages/launches_page.dart';
import 'package:space_x/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:space_x/features/settings/presentation/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await initializeDateFormatting('en_US', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();
    final launchService = LaunchService();
    final favoriteService = FavoriteService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit(storageService: storageService)),
        BlocProvider(create: (context) => LocalUserCubit(storageService: storageService)..loadUser()),
        BlocProvider(create: (context) => LaunchesCubit(launchService: launchService)),
        BlocProvider(create: (context) => ViewModeCubit(storageService: storageService)),
        BlocProvider(
          create: (context) => FavoritesCubit(
            favoriteService: favoriteService,
            launchService: launchService,
          )..loadFavorites(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'SpaceX',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
              textTheme: GoogleFonts.exo2TextTheme(Theme.of(context).textTheme),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark, surface: const Color(0xFF000020)),
              textTheme: GoogleFonts.exo2TextTheme(Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white, displayColor: Colors.white)),
              useMaterial3: true,
            ),
            home: const RootPage(),
          );
        },
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalUserCubit, LocalUserState>(
      builder: (context, state) {
        return switch (state) {
          LocalUserInitial() || LocalUserLoading() => const Scaffold(body: Center(child: CircularProgressIndicator())),
          LocalUserSuccess(showOnboarding: final showOnboarding) =>
            showOnboarding ? const OnboardingPage() : const LaunchesPage(),
        };
      },
    );
  }
}
