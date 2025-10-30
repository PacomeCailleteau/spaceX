import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:space_x/features/launches/model/launch_model.dart';

class LaunchListItem extends StatelessWidget {
  const LaunchListItem({super.key, required this.launch});

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: CachedNetworkImage(
            imageUrl: launch.patch?.small ?? '',
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.rocket_launch),
          ),
        ),
        title: Text(launch.name),
        subtitle: Text(launch.dateUtc.toLocal().toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                final isFavorite = state.favoriteLaunches.contains(launch.id);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => context.read<FavoritesCubit>().toggleFavorite(launch.id),
                );
              },
            ),
            launch.success == true
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
