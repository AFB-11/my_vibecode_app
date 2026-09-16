import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeStarted extends HomeEvent {
  const HomeStarted(this.userName);

  final String userName;

  @override
  List<Object?> get props => [userName];
}

final class ToggleTaskCompletion extends HomeEvent {
  const ToggleTaskCompletion(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class AddTask extends HomeEvent {
  const AddTask({required this.title, required this.category});

  final String title;
  final String category;

  @override
  List<Object?> get props => [title, category];
}
