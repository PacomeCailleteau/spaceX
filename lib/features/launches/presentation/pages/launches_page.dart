import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/presentation/pages/favorites_page.dart';
import 'package:space_x/features/launches/presentation/cubit/launches_cubit.dart';
import 'package:space_x/features/launches/presentation/pages/launch_detail_page.dart';
import 'package:space_x/features/launches/presentation/widgets/launch_grid_item.dart';
import 'package:space_x/features/launches/presentation/widgets/launch_list_item.dart';
import 'package:space_x/features/settings/presentation/pages/settings_page.dart';

class LaunchesPage extends StatelessWidget {
  const LaunchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LaunchesView();
  }
}

class LaunchesView extends StatelessWidget {
  const LaunchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => context.read<LaunchesCubit>().fetchLaunches(),
          child: const Text('SpaceX Launches'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
          ),
          BlocBuilder<LaunchesCubit, LaunchesState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => context.read<LaunchesCubit>().toggleViewMode(),
                icon: Icon(state.viewMode == LaunchViewMode.list ? Icons.grid_view : Icons.view_list),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<LaunchesCubit, LaunchesState>(
        builder: (context, state) {
          switch (state.status) {
            case LaunchStatus.initial:
            case LaunchStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LaunchStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error ?? 'Failed to fetch launches'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<LaunchesCubit>().fetchLaunches(),
                      child: const Text('Retry'),
                    )
                  ],
                ),
              );
            case LaunchStatus.success:
              if (state.launches.isEmpty) {
                return const Center(child: Text('No launches found.'));
              }
              if (state.viewMode == LaunchViewMode.list) {
                return ListView.builder(
                  itemCount: state.launches.length,
                  itemBuilder: (context, index) {
                    final launch = state.launches[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LaunchDetailPage(launch: launch),
                        ),
                      ),
                      child: LaunchListItem(launch: launch),
                    );
                  },
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.launches.length,
                  itemBuilder: (context, index) {
                    final launch = state.launches[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LaunchDetailPage(launch: launch),
                        ),
                      ),
                      child: LaunchGridItem(launch: launch),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
