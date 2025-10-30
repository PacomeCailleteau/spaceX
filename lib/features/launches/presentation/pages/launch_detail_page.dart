import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:space_x/features/launches/model/launch_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDetailPage extends StatelessWidget {
  const LaunchDetailPage({super.key, required this.launch});

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(launch.name),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state.favoriteLaunches.contains(launch.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<FavoritesCubit>().toggleFavorite(launch.id);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (launch.patch?.large != null)
              Center(
                child: CachedNetworkImage(
                  imageUrl: launch.patch!.large!,
                  height: 200,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.rocket_launch, size: 200),
                ),
              ),
            const SizedBox(height: 16),
            Text('Launch Details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(launch.details ?? 'No details available.'),
            const SizedBox(height: 16),
            Text('Date', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(launch.dateUtc.toLocal().toString()),
            const SizedBox(height: 16),
            Text('Mission Outcome', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(launch.success == true ? 'Success' : 'Failure'),
            if (launch.failures != null && launch.failures!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Reason: ${launch.failures!.first.reason}'),
              ),
            const SizedBox(height: 16),
            if (launch.rocket != null) ...[
              Text('Rocket Information', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Name: ${launch.rocket!.name}'),
              const SizedBox(height: 8),
              Text(launch.rocket!.description),
              const SizedBox(height: 16),
              if (launch.rocket!.flickrImages.isNotEmpty)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: launch.rocket!.flickrImages.length,
                    itemBuilder: (context, index) {
                      final imageUrl = launch.rocket!.flickrImages[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
            ],
            if (launch.article != null)
              Center(
                child: ElevatedButton(
                  onPressed: () => _launchUrl(launch.article!),
                  child: const Text('Read Article'),
                ),
              ),
          ],
        ),
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
