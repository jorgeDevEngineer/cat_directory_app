import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'router.dart';
import '../core/di/injection.dart';
import '../features/breeds/presentation/bloc/breeds_bloc.dart';

class CatDirectoryApp extends StatelessWidget {
  const CatDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BreedsBloc>(
          create: (context) => BreedsBloc(repository: getIt()),
        ),
      ],
      child: MaterialApp.router(
        title: 'MiauPedia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
