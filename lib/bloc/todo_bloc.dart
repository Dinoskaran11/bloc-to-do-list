import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../model/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late Box<TodoModel> _todoBox;

  TodoBloc() : super(TodoInitial()) {
    _initializeHive();

    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _initializeHive() async {
    _todoBox = await Hive.openBox<TodoModel>('todos');
    add(LoadTodos());
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) {
    emit(TodoLoaded(_todoBox.values.toList()));
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    final todo = TodoModel(title: event.title);
    _todoBox.add(todo);
    emit(TodoLoaded(_todoBox.values.toList()));
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) {
    final todo = _todoBox.getAt(event.index);
    if (todo != null) {
      todo.title = event.newTitle;
      todo.save();
      emit(TodoInitial());
      emit(TodoLoaded(_todoBox.values.toList()));
    }
  }

  void _onToggleTodoStatus(ToggleTodoStatus event, Emitter<TodoState> emit) {
    final todo = _todoBox.getAt(event.index);
    if (todo != null) {
      todo.isCompleted = !todo.isCompleted;
      todo.save();

      emit(TodoInitial());
      emit(TodoLoaded(_todoBox.values.toList()));
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    _todoBox.deleteAt(event.index);
    emit(TodoLoaded(_todoBox.values.toList()));
  }
}
