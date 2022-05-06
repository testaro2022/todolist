import 'package:flutter/material.dart';
import 'package:myapp/todolist_manage.dart';

List<String> todoList = [];

// リスト一覧画面用Widget
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Todoリストのデータ
  int _index = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        centerTitle: true,
        title: Text('リスト一覧',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
            )),
        actions: [IconButton(onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context){
                return TodoDonePage();
              }));
        }, icon: Icon(Icons.playlist_add_check_rounded))],
      ),
      // データを元にListViewを作成
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(todoList[index]),
              leading: Icon(Icons.delete),
              selected: _index == index,
              onTap: () async {
                _index = index;
                final nextEditText = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TodoEditPage(
                    id : _index,
                    text : todoList[_index],
                  ),
                  ),
                );
                if(nextEditText=="delete_thistile"){
                  setState(() {
                    todoList.removeAt(_index);
                  });
                }
                else if(nextEditText != null){
                  setState(() {
                    todoList[_index]=nextEditText;
                  });
                }
                _index = -1;
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          // リスト追加画面から渡される値を受け取る
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return TodoAddPage();
            }),
          );
          if (newListText != null) {
            // キャンセルした場合は newListText が null となるので注意
            setState(() {
              // リスト追加
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
