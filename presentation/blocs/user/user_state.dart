import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  final bool hasReachedMax;

  UserLoaded(this.users, this.hasReachedMax);

  UserLoaded copyWith({
    List<UserModel>? users,
    bool? hasReachedMax,
  }) => UserLoaded(
    users ?? this.users,
    hasReachedMax ?? this.hasReachedMax,
  );

  @override
  List<Object?> get props => [users, hasReachedMax];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}
