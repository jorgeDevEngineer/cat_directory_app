import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme/app_colors.dart';
import '../bloc/breeds_bloc.dart';
import '../bloc/breeds_event.dart';
import '../bloc/breeds_state.dart';
import '../widgets/breed_card.dart';
import '../widgets/breed_shimmer.dart';
import '../widgets/search_bar.dart';
import 'package:go_router/go_router.dart';

class BreedsPage extends StatefulWidget {
  const BreedsPage({super.key});

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BreedsBloc>().add(const BreedsLoadStarted());
  }

  @override
  void dispose() {
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_logo.jpg',
              height: 28,
              width: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            const Text('PurrfectPedia'),
          ],
        ),
      ),
      body: BlocConsumer<BreedsBloc, BreedsState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.breeds.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: 'Reintentar',
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
              if (state.isFromCache) _buildCacheBanner(state.lastUpdated),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
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
  }

  Widget _buildCacheBanner(DateTime? lastUpdated) {
    String timeText = '';
    if (lastUpdated != null) {
      final diff = DateTime.now().difference(lastUpdated).inMinutes;
      timeText = diff > 0 ? ' (actualizado hace $diff min)' : '';
    }

    return Container(
      width: double.infinity,
      color: AppColors.primaryLight.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.offline_bolt_rounded, size: 16, color: AppColors.primaryDark),
          const SizedBox(width: 6),
          Text(
            'Modo sin conexión — mostrando caché$timeText',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BreedsState state) {
    if (state.isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (_, __) => const BreedShimmer(),
        ),
      );
    }

    if (state.errorMessage != null && state.breeds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BreedsBloc>().add(const BreedsLoadStarted(forceRefresh: true));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.filteredBreeds.isEmpty) {
      return const Center(
        child: Text('No se encontraron razas de gato.'),
      );
    }

    return ListView.builder(
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
          breed: breed,
          onTap: () {
            context.push('/breed/${Uri.encodeComponent(breed.breed)}', extra: breed);
          },
        );
      },
    );
  }
}
