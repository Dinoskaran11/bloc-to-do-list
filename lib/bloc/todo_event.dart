import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);

  @override
  List<Object> get props => [title];
}

class UpdateTodo extends TodoEvent {
  final int index;
  final String newTitle;
  UpdateTodo(this.index, this.newTitle);

  @override
  List<Object> get props => [index, newTitle];
}

class ToggleTodoStatus extends TodoEvent {
  final int index;
  ToggleTodoStatus(this.index);

  @override
  List<Object> get props => [index];
}

class DeleteTodo extends TodoEvent {
  final int index;
  DeleteTodo(this.index);

  @override
  List<Object> get props => [index];
}
