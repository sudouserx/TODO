import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // form controller
  final TextEditingController _formController = TextEditingController();

  // keep track of the todos
  final List _todos = [];

  // keep track if todos are checked
  final List _isChecked = [];

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO DO"), // TODO : center it
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: Scaffold(
        backgroundColor: Colors.yellow[200],
        body: ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: () {
                  // popup the modal with the previous todo value to be edited
                  // _formController.value = _todos[index];
                  _formController.value = TextEditingValue(text: _todos[index]);
                  showDialog(
                      context: context,
                      builder: (BuildContext) {
                        return AlertDialog(
                          title: Text("Edit TODO"),
                          content: Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _formController,
                                  decoration:
                                      InputDecoration(labelText: 'todo'),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _formController
                                      .clear(); // empty the form controller

                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  // perform submission
                                  setState(() {
                                    _todos[index] = _formController.text;
                                  });
                                  _formController
                                      .clear(); // empty the from controller
                                  Navigator.of(context).pop();
                                },
                                child: Text("Submit"))
                          ],
                        );
                      });
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Checkbox(
                          value: _isChecked[index],
                          onChanged: (bool? newValue) {
                            setState(() {
                              _isChecked[index] = newValue!;
                            });
                          }),
                      Expanded(
                        child: Text(
                          _todos[index],
                          softWrap: true,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              decoration: _isChecked[index]
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            // remove from todo list and the checked list
                            setState(() {
                              _todos.removeAt(index);
                              _isChecked.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // poppup the 'enter todo' modal
          showDialog(
              context: context,
              builder: (BuildContext) {
                return AlertDialog(
                  title: Text("Add TODO"),
                  content: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _formController,
                          decoration: InputDecoration(labelText: 'todo'),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _formController.clear(); // empty the form controller

                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          // perform submission
                          setState(() {
                            _todos.add(_formController.text);
                            _isChecked.add(false);
                          });
                          _formController.clear(); // empty the from controller
                          Navigator.of(context).pop();
                        },
                        child: Text("Submit"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.yellow,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
