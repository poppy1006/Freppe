import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notes_app/TaskApp/constants/colors.dart';
import 'package:notes_app/TaskApp/widgets/todo_item.dart';

import '../../screens/note_list.dart';
import '../model/todo.dart';

class Home extends StatefulWidget {
   Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 final todosList = ToDo.todoList();
 List<ToDo>_foundToDo = [];
 final _todoController = TextEditingController();

 @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        color: Colors.black,
        items: [
        IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteList()));}, icon: Icon(Icons.book,color: Colors.white),),
        IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));}, icon: Icon(Icons.task,color: Colors.white))
      ]
      
      ),
      backgroundColor: tdBGColor,
      appBar: _buildAppbar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
               SearchBox(),

               Expanded(
                 child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, bottom: 20),
                      child: Text(
                        'All Tasks',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500
                          ),
                        ),  
                    ),
// Todo Item
                   for( ToDo todo in _foundToDo.reversed)
                   ToDoItem(
                    todo: todo,
                    onToDoChanged: _handleToDoChange,
                    onDeleteItem: _deleteToDoItem,
                    ),
                     
                  ],
                 ),
               )
                
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                   vertical: 5),
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                       BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0,0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),],
                    borderRadius: BorderRadius.circular(10),
                    ),
                    child:  TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Add new Task',
                        border: InputBorder.none,
                      ),
                    ), 
                ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    ),
                    child: ElevatedButton(
                      child: Text('+',
                      style: TextStyle(
                        fontSize: 40,
                      ),),
                      onPressed: () {
                        // print('add button pressed');
                        _addToDoItem(_todoController.text);
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tdBlue,
                        minimumSize: Size(60, 60),
                        elevation: 10,
                      ),
                    ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
// processes
  void _handleToDoChange(ToDo todo){
    setState(() {
       todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id){
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo){
    setState(() {
      todosList.add(
        ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo));
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword){
    List<ToDo> results = [];
    if( enteredKeyword.isEmpty ){
      results =  todosList;
    }else{
      results = todosList.where((item) => item.todoText.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

// Search
  Widget SearchBox(){
    return  Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const  InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: tdBlack,
                    size: 20,
                    ),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 20,
                    minWidth: 25
                    ),
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: tdGrey,
                  )
                  )
                ),
              );
  }

// Appbar
  AppBar _buildAppbar() {
    return AppBar(
      // title: Text('ToDO'),
      backgroundColor: tdBGColor,
      elevation: 0,
    );
  }
}