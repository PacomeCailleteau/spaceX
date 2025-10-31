import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/core/utils/date_formatter.dart';
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
        title: Text(launch.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(DateFormatter.formatLaunchDate(launch.dateUtc)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                final isFavorite =
                    state is FavoritesSuccess && state.favoriteIds.contains(launch.id);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () => context.read<FavoritesCubit>().toggleFavorite(launch.id),
                );
              },
            ),
            _buildStatusIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (launch.success == null) {
      return const Icon(Icons.schedule, color: Colors.grey);
    } else if (launch.success!) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else {
      return const Icon(Icons.cancel, color: Colors.red);
    }
  }
}
