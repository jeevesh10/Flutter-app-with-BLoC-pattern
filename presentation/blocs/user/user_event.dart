import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final bool isInitialLoad;
  final String? query;

  FetchUsers({this.isInitialLoad = false, this.query});
}
