import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/settings/presentation/cubit/theme_cubit.dart';

class ThemeRadioTile extends StatelessWidget {
  const ThemeRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
  });

  final String title;
  final ThemeMode value;
  final ThemeMode groupValue;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return ListTile(
      title: Text(title),
      onTap: () => context.read<ThemeCubit>().setTheme(value),
      trailing: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }
}
