import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/user/user_bloc.dart';
import '../../../presentation/blocs/user/user_event.dart';
import '../../../presentation/blocs/user/user_state.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/screens/CreatePostScreen.dart'; // import your CreatePostScreen here

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  void setupScrollController(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<UserBloc>().add(FetchUsers());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<UserBloc>();
    bloc.add(FetchUsers(isInitialLoad: true));
    setupScrollController(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: theme.colorScheme.onPrimary,
        elevation: 6,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar with padding, rounded corners & shadow
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<UserBloc>().add(
                    FetchUsers(isInitialLoad: true, query: value),
                  );
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Users',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading && state is! UserLoaded) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  );
                } else if (state is UserLoaded) {
                  final users = state.users;
                  if (users.isEmpty) {
                    return Center(
                      child: Text(
                        'No users found.',
                        style: theme.textTheme.titleMedium,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<UserBloc>().add(
                        FetchUsers(isInitialLoad: true),
                      );
                      // Wait for the new data to load - listen to state change or delay a bit
                      await Future.delayed(const Duration(milliseconds: 800));
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      itemCount: users.length + (state.hasReachedMax ? 0 : 1),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index < users.length) {
                          final user = users[index];
                          return _buildUserCard(user, theme);
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => CreatePostScreen(
                    onPostCreated: (post) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Post created: ${post.title}')),
                      );
                      // TODO: Handle the created post, e.g. add to list or send to backend
                    },
                  ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Post'),
      ),
    );
  }

  Widget _buildUserCard(UserModel user, ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(user.image),
          backgroundColor: Colors.grey[200],
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(user.email),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
        onTap: () {
          // Optional: Navigate to user detail page
        },
      ),
    );
  }
}
