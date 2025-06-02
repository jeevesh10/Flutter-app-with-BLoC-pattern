import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            child: ListTile(
              leading: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Switch.adaptive(
                activeColor: theme.colorScheme.secondary,
                value: isDark,
                onChanged: (_) => context.read<ThemeBloc>().toggleTheme(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          _buildCard(
            child: ListTile(
              leading: Icon(
                Icons.notifications_active,
                color: theme.colorScheme.primary,
              ),
              title: const Text(
                'Enable Notifications',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Switch.adaptive(
                activeColor: theme.colorScheme.secondary,
                value: notificationsEnabled,
                onChanged:
                    (value) => setState(() => notificationsEnabled = value),
              ),
            ),
          ),

          const SizedBox(height: 12),

          _buildCard(
            child: ListTile(
              leading: Icon(Icons.language, color: theme.colorScheme.primary),
              title: const Text(
                'Language',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                  DropdownMenuItem(value: 'French', child: Text('French')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => selectedLanguage = value);
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          _buildCard(
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: theme.colorScheme.primary,
              ),
              title: const Text(
                'Account Info',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountInfoScreen(),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Info'),
        backgroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
      ),
      body: Center(
        child: Text(
          'User account details will be shown here.',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
