import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../../data/providers/user_api_provider.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApiProvider apiProvider;
  int limit = 10;
  int skip = 0;
  bool isFetching = false;

  UserBloc(this.apiProvider) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (event.isInitialLoad) {
        skip = 0;
        emit(UserLoading());
      }

      final users = await apiProvider.fetchUsers(limit, skip, event.query);

      if (state is UserLoaded && !event.isInitialLoad) {
        final currentUsers = (state as UserLoaded).users;
        emit(UserLoaded(currentUsers + users, users.isEmpty));
      } else {
        emit(UserLoaded(users, users.isEmpty));
      }

      skip += limit;
    } catch (e) {
      emit(UserError(e.toString()));
    }

    isFetching = false;
  }
}
