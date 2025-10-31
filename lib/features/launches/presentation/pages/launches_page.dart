import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/launches/model/launch_model.dart';
import 'package:space_x/features/launches/presentation/cubit/launches_cubit.dart';
import 'package:space_x/features/launches/presentation/cubit/view_mode_cubit.dart';
import 'package:space_x/features/launches/enum/launch_view_mode.dart';
import 'package:space_x/features/launches/presentation/pages/launch_detail_page.dart';
import 'package:space_x/features/launches/presentation/widgets/launch_grid_item.dart';
import 'package:space_x/features/launches/presentation/widgets/launch_list_item.dart';
import 'package:space_x/features/launches/presentation/widgets/options_menu.dart';

class LaunchesPage extends StatefulWidget {
  const LaunchesPage({super.key});

  @override
  State<LaunchesPage> createState() => _LaunchesPageState();
}

class _LaunchesPageState extends State<LaunchesPage> {
  final _scrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isSearching = false;

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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _isSearching
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.more_vert),
              onPressed: () => _showOptionsModal(context),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: !_isSearching
          ? GestureDetector(
              onTap: () => _refreshIndicatorKey.currentState?.show(),
              child: const Text('SpaceX Launches'),
            )
          : TextField(
              autofocus: true,
              style: Theme.of(context).appBarTheme.titleTextStyle,
              decoration: const InputDecoration(hintText: 'Search by name...', border: InputBorder.none),
              onSubmitted: (query) => context.read<LaunchesCubit>().search(query),
            ),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() => _isSearching = !_isSearching);
            if (!_isSearching) {
              context.read<LaunchesCubit>().refresh();
            }
          },
        ),
      ],
    );
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<ViewModeCubit>(context)),
          BlocProvider.value(value: BlocProvider.of<LaunchesCubit>(context)),
        ],
        child: const OptionsMenu(),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => context.read<LaunchesCubit>().refresh(),
      child: BlocBuilder<LaunchesCubit, LaunchesState>(
        builder: (context, state) {
          return switch (state) {
            LaunchesInitial() || LaunchesLoading() => const Center(child: CircularProgressIndicator()),
            LaunchesFailure(error: final error, launches: final launches) when launches.isEmpty => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: () => context.read<LaunchesCubit>().refresh(), child: const Text('Retry'))
                  ],
                ),
              ),
            LaunchesSuccess(launches: final launches) || LaunchesLoadingMore(launches: final launches) || LaunchesFailure(launches: final launches) =>
              (launches.isEmpty)
                  ? LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: const Center(child: Text('No launches found.')),
                        ),
                      ))
                  : BlocBuilder<ViewModeCubit, ViewModeState>(
                      builder: (context, viewModeState) {
                        return viewModeState.viewMode == LaunchViewMode.list
                            ? _buildListView(launches, state is LaunchesLoadingMore)
                            : _buildGridView(launches, state is LaunchesLoadingMore);
                      },
                    ),
          };
        },
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
