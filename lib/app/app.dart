import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'router.dart';
import '../core/di/injection.dart';
import '../core/theme/theme_service.dart';
import '../features/breeds/presentation/bloc/breeds_bloc.dart';

class CatDirectoryApp extends StatelessWidget {
  const CatDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider<BreedsBloc>(
          create: (context) => BreedsBloc(repository: getIt()),
        ),
      ],
      child: ListenableBuilder(
        listenable: themeService,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'MiauPedia',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
