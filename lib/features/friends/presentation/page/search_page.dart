import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/friends/presentation/bloc/friends_cubit.dart';
import 'package:pulse/features/friends/presentation/bloc/search_cubit.dart';
import 'package:pulse/features/friends/presentation/widgets/suggested_user_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PulseColors.background,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: PulseTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Search by name...',
            hintStyle: PulseTextStyles.bodyMedium.copyWith(
              color: PulseColors.textHint,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
          onChanged: (query) => context.read<SearchCubit>().searchUsers(query),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<SearchCubit>().clearSearch();
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return Center(
              child: Text(
                'Search for friends by name',
                style: PulseTextStyles.bodyMedium.copyWith(
                  color: PulseColors.textHint,
                ),
              ),
            );
          }

          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(color: PulseColors.primary),
            );
          }

          if (state is SearchError) {
            return Center(
              child: Text(state.message, style: PulseTextStyles.bodyMedium),
            );
          }

          if (state is SearchLoaded) {
            if (state.results.isEmpty) {
              return Center(
                child: Text(
                  'No users found',
                  style: PulseTextStyles.bodyMedium.copyWith(
                    color: PulseColors.textHint,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final user = state.results[index];
                return SuggestedUserTile(
                  user: user,
                  onAdd: () => context.read<FriendsCubit>().addFriend(
                        currentUserId: _currentUserId,
                        targetUserId: user.uid,
                      ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
