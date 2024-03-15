import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

final todoList = [].obs;
final dio = Dio(); // Create a new Dio instance

void getTodos() async {
  try {
    final res = await dio.get('/todos');
    todoList.value = res.data;
  } catch (e) {
    print(e);
  }
}

createTodo(item, context) async {
  try {
    final res = await dio.post('/todos', data: {
      'name': item,
    });
    todoList.value = res.data;
    print(navigator);
    navigator?.pop(context);
  } catch (e) {
    print(e);
  }
}

updateTodo(name, id, context) async {
  try {
    final res = await dio.post('/todos/$id', data: {
      'name': name,
    });
    todoList.value = res.data;
    print(navigator);
    navigator?.pop(context);
  } catch (e) {
    print(e);
  }
}

deleteTodo(id) async {
  try {
    final res = await dio.delete('/todos/$id');
    todoList.value = res.data;
    print(navigator);
  } catch (e) {
    print(e);
  }
}
