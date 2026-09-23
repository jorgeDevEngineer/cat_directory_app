import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/lifecycle/app_lifecycle_observer.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../core/widgets/connectivity_banner.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../bloc/breeds_bloc.dart';
import '../bloc/breeds_event.dart';
import '../bloc/breeds_state.dart';
import '../widgets/breed_card.dart';
import '../widgets/breed_shimmer.dart';
import '../widgets/search_bar.dart';

class BreedsPage extends StatefulWidget {
  const BreedsPage({super.key});

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  final ScrollController _scrollController = ScrollController();
  late AppLifecycleObserver _lifecycleObserver;
  final loc = LocalizationService.instance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _lifecycleObserver = AppLifecycleObserver(
      onResumeRevalidate: () {
        context.read<BreedsBloc>().add(const BreedsLoadStarted(forceRefresh: true, isRevalidation: true));
      },
    );
    WidgetsBinding.instance.addObserver(_lifecycleObserver);

    context.read<BreedsBloc>().add(const BreedsLoadStarted());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BreedsBloc>().add(const BreedsNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: loc,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/app_logo.jpg',
                    height: 28,
                    width: 28,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.pets, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(loc.appTitle),
              ],
            ),
            actions: const [
              ThemeToggleButton(),
              SizedBox(width: 8),
            ],
          ),
          body: BlocConsumer<BreedsBloc, BreedsState>(
            listener: (context, state) {
              if (state.errorMessage != null && state.breeds.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    action: SnackBarAction(
                      label: loc.retry,
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<BreedsBloc>().add(const BreedsNextPageRequested());
                      },
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  CustomSearchBar(
                    query: state.searchQuery,
                    onChanged: (value) {
                      context.read<BreedsBloc>().add(BreedsSearchQueryChanged(value));
                    },
                    onClear: () {
                      context.read<BreedsBloc>().add(const BreedsSearchQueryChanged(''));
                    },
                  ),
                  ConnectivityBanner(isOffline: state.isFromCache),
                  if (state.isFromCache && state.lastUpdated != null)
                    _buildLastUpdatedHeader(state.lastUpdated!),
                  Expanded(
                    child: RefreshIndicator(
                      color: Theme.of(context).colorScheme.primary,
                      onRefresh: () async {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                        context.read<BreedsBloc>().add(const BreedsRefreshRequested());
                      },
                      child: _buildBody(state),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLastUpdatedHeader(DateTime lastUpdated) {
    final diff = DateTime.now().difference(lastUpdated).inMinutes;
    final timeText = diff > 0 ? loc.agoMin.replaceAll('{min}', '$diff') : loc.justNow;

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        '${loc.lastUpdated}: $timeText',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
      ),
    );
  }

  Widget _buildBody(BreedsState state) {
    if (state.isLoading) {
      return Semantics(
        label: loc.isSpanish ? 'Cargando razas de gato' : 'Loading cat breeds',
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (_, __) => const BreedShimmer(),
          ),
        ),
      );
    }

    if (state.errorMessage != null && state.breeds.isEmpty) {
      return Semantics(
        label: loc.isSpanish ? 'Error al cargar razas de gato' : 'Error loading cat breeds',
        child: ErrorView(
          message: state.errorMessage!,
          type: ErrorType.noConnection,
          onRetry: () {
            context.read<BreedsBloc>().add(const BreedsLoadStarted(forceRefresh: true));
          },
        ),
      );
    }

    if (state.filteredBreeds.isEmpty) {
      return Center(
        child: Text(loc.noResults),
      );
    }

    return Semantics(
      label: 'Lista de razas, ${state.filteredBreeds.length} resultados cargados',
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.filteredBreeds.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.filteredBreeds.length) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: const BreedShimmer(),
            );
          }

          final breed = state.filteredBreeds[index];
          return BreedCard(
            breedName: breed.breed,
            country: breed.country,
            coat: breed.coat,
            pattern: breed.pattern,
            onTap: () {
              context.push('/breed/${Uri.encodeComponent(breed.breed)}', extra: breed);
            },
          );
        },
      ),
    );
  }
}
