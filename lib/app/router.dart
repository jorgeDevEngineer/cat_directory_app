import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/breeds/presentation/pages/breeds_page.dart';
import '../features/breed_detail/presentation/pages/breed_detail_page.dart';
import '../features/breeds/domain/entities/breed.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/breeds',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const BreedsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/breed/:name',
      pageBuilder: (context, state) {
        final name = Uri.decodeComponent(state.pathParameters['name'] ?? '');
        final breed = state.extra as Breed?;

        return CustomTransitionPage(
          key: state.pageKey,
          child: BreedDetailPage(breedName: name, breed: breed),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
