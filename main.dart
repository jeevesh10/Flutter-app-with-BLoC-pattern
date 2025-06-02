// 🎯 main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/screens/user_list/user_list_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'data/providers/user_api_provider.dart';
import 'presentation/blocs/user/user_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

void main() {
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => UserApiProvider())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(context.read<UserApiProvider>()),
          ),
          BlocProvider(create: (_) => ThemeBloc()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'User Management App',
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              routes: {'/settings': (_) => const SettingsScreen()},
              home: const UserListScreen(),
            );
          },
        ),
      ),
    );
  }
}
