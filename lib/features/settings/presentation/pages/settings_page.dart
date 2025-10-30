import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text(
                      'Theme',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RadioListTile<ThemeMode>(
                    title: const Text('System'),
                    value: ThemeMode.system,
                    groupValue: state.themeMode,
                    onChanged: (value) => context.read<ThemeCubit>().setTheme(value!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: state.themeMode,
                    onChanged: (value) => context.read<ThemeCubit>().setTheme(value!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: state.themeMode,
                    onChanged: (value) => context.read<ThemeCubit>().setTheme(value!),
                  ),
                ],
              );
            },
          ),
          const Divider(indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'Credits',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const ListTile(
            title: Text('Developed with ❤️ by Pacôme'),
          ),
          ListTile(
            title: const Text('SpaceX API'),
            subtitle: const Text('All data provided by the unofficial SpaceX API.'),
            onTap: () => _launchUrl('https://github.com/r-spacex/SpaceX-API'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}
