import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/presentation/pages/favorites_page.dart';
import 'package:space_x/features/launches/presentation/cubit/view_mode_cubit.dart';
import 'package:space_x/features/launches/enum/launch_view_mode.dart';
import 'package:space_x/features/settings/presentation/pages/settings_page.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewModeCubit, ViewModeState>(
      builder: (context, state) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(state.viewMode == LaunchViewMode.list ? Icons.grid_view : Icons.view_list),
              title: Text(state.viewMode == LaunchViewMode.list ? 'Grid View' : 'List View'),
              onTap: () {
                context.read<ViewModeCubit>().toggleViewMode();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
              },
            ),
          ],
        );
      },
    );
  }
}
