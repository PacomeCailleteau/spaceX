import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/presentation/pages/favorites_page.dart';
import 'package:space_x/features/launches/model/launch_model.dart';
import 'package:space_x/features/launches/presentation/cubit/launches_cubit.dart';
import 'package:space_x/features/launches/presentation/pages/launch_detail_page.dart';
import 'package:space_x/features/launches/presentation/widgets/launch_grid_item.dart';
import 'package:space_x/features/launches/presentation/widgets/launch_list_item.dart';
import 'package:space_x/features/settings/presentation/pages/settings_page.dart';

class LaunchesPage extends StatefulWidget {
  const LaunchesPage({super.key});

  @override
  State<LaunchesPage> createState() => _LaunchesPageState();
}

class _LaunchesPageState extends State<LaunchesPage> {
  final _scrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<LaunchesCubit>().fetchLaunches(isRefresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<LaunchesCubit>().fetchLaunches();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaunchesCubit, LaunchesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(state),
          body: _buildBody(state),
          floatingActionButton: state.isSearching
              ? null
              : FloatingActionButton(
                  child: const Icon(Icons.more_vert),
                  onPressed: () => _showOptionsModal(context),
                ),
        );
      },
    );
  }

  AppBar _buildAppBar(LaunchesState state) {
    return AppBar(
      title: !state.isSearching
          ? GestureDetector(
              onTap: () => _refreshIndicatorKey.currentState?.show(),
              child: const Text('SpaceX Launches'),
            )
          : TextField(
              autofocus: true,
              style: Theme.of(context).appBarTheme.titleTextStyle,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                border: InputBorder.none,
              ),
              onSubmitted: (query) => context.read<LaunchesCubit>().search(query),
            ),
      actions: [
        IconButton(
          icon: Icon(state.isSearching ? Icons.close : Icons.search),
          onPressed: () => context.read<LaunchesCubit>().toggleSearch(),
        ),
      ],
    );
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<LaunchesCubit>(context),
        child: const OptionsMenu(),
      ),
    );
  }

  Widget _buildBody(LaunchesState state) {
    final status = state.status;
    final launches = state.launches;

    if (status == LaunchStatus.loading && launches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (status == LaunchStatus.failure && launches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error ?? 'Failed to fetch launches'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.read<LaunchesCubit>().refresh(), child: const Text('Retry'))
          ],
        ),
      );
    }

    return BlocListener<LaunchesCubit, LaunchesState>(
      listener: (context, listenState) {
        if (listenState.status == LaunchStatus.failure && listenState.launches.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(listenState.error ?? 'Failed to load more launches.')),
            );
        }
      },
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => context.read<LaunchesCubit>().refresh(),
        child: (launches.isEmpty && status != LaunchStatus.loading)
            ? LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Center(child: Text('No launches found.')),
                  ),
                );
              })
            : state.viewMode == LaunchViewMode.list
                ? _buildListView(launches, status == LaunchStatus.loadingMore)
                : _buildGridView(launches, status == LaunchStatus.loadingMore),
      ),
    );
  }

  Widget _buildListView(List<Launch> launches, bool isLoadingMore) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: launches.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= launches.length) {
          return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
        }
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LaunchDetailPage(launch: launches[index]))),
          child: LaunchListItem(launch: launches[index]),
        );
      },
    );
  }

  Widget _buildGridView(List<Launch> launches, bool isLoadingMore) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
      itemCount: launches.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= launches.length) {
          // For GridView, a simple centered loader is fine, it will take one grid cell.
          return const Center(child: CircularProgressIndicator());
        }
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LaunchDetailPage(launch: launches[index]))),
          child: LaunchGridItem(launch: launches[index]),
        );
      },
    );
  }
}

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaunchesCubit, LaunchesState>(
      builder: (context, state) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(state.viewMode == LaunchViewMode.list ? Icons.grid_view : Icons.view_list),
              title: Text(state.viewMode == LaunchViewMode.list ? 'Grid View' : 'List View'),
              onTap: () {
                context.read<LaunchesCubit>().toggleViewMode();
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
