import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todo_app/todo_list/todo_controller.dart';

void main() {
  dio.options.baseUrl = 'http://localhost:8000/api';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: TodoList(),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});
  @override
  Widget build(BuildContext context) {
    getTodos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(todoList[index]['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // start click edit action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoForm(item: todoList[index]),
                        ),
                      );
                      // end click edit action
                    },
                    splashRadius: 18,
                    icon: Icon(Icons.edit),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () {
                      // start click delete action
                      deleteTodo(todoList[index]['id']);
                      // end click delete action
                    },
                    splashRadius: 18,
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoForm(item: null)),
          );
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => TodoForm(),
          //     ),
          //   );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoForm extends StatelessWidget {
  TodoForm({super.key, required this.item});
  final item;

  final TextEditingController todoName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Form'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: todoName,
              // onChanged: ,
            ),
            Container(
              padding: EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: () async {
                  if (item) {
                    await updateTodo(
                      todoName.text,
                      item['id'],
                      context,
                    );
                  } else {
                    await createTodo(todoName.text, context);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
