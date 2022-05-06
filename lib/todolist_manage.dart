import 'package:flutter/material.dart';

List<String> doneList = [];


enum Answers{
  YES,
  NO
}

class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  // 入力されたテキストをデータとして持つ
  String _text = '';

  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト追加'),
      ),
      body: Container(
        // 余白を付ける
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 入力されたテキストを表示
            Text(_text, style: TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            // テキスト入力
            TextField(
              // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
              onChanged: (String value) {
                // データが変更したことを知らせる（画面を更新する）
                setState(() {
                  // データを変更
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // リスト追加ボタン
              child: ElevatedButton(
                onPressed: () {
                  // "pop"で前の画面に戻る
                  // "pop"の引数から前の画面にデータを渡す
                  Navigator.of(context).pop(_text);
                },
                child: Text('リスト追加', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // キャンセルボタン
              child: TextButton(
                // ボタンをクリックした時の処理
                onPressed: () {
                  // "pop"で前の画面に戻る
                  Navigator.of(context).pop();
                },
                child: Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoEditPage extends StatefulWidget {
  int? id=-1;
  String? text="";
  TodoEditPage({
    this.id,
    this.text,
  });

  @override
  _TodoEditPageState createState() => _TodoEditPageState(
  );
}

class _TodoEditPageState extends State<TodoEditPage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("リスト編集,削除"),
        ),
        body: Container(
          padding: EdgeInsets.all(64),
          child:Column(
              children: <Widget>[
                TextFormField(
                  initialValue: widget.text,
                  // _text=widget.text,
                  onChanged: (String value){
                    setState(() {
                      _text = value;
                    });
                  },
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:<Widget>[
                      OutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('キャンセル')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(_text);
                          },
                          child: Text('OK')
                      )
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("delete_thistile");
                      },
                      child: Text('このTodoを削除する'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        alignment: Alignment.center,
                      ),
                    )
                  ],

                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    child: Text('完了'),
                    onPressed: () async {
                      String? text = widget.text;
                      if(text != null) {
                        setState(() {
                          doneList.add(text);
                        });
                      }
                      Navigator.of(context).pop("delete_thistile");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                    ),
                  ),
                )

              ]
          ),
        )
    );
  }
}

class TodoDonePage extends StatefulWidget{
  @override
  _TodoDonePageState createState() => _TodoDonePageState();
}

class _TodoDonePageState extends State<TodoDonePage> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("完了済みリスト一覧"),
      ),
      body: ListView.builder(
          itemCount: doneList.length,
          itemBuilder: (context,index){
            return Card(
              child: ListTile(
                title:Text(doneList[index]),
              ),
            );
          }
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          openDialog(context);
        },
        child: Icon(Icons.delete),

    ),
    );

  }
  void openDialog(BuildContext context) {
    showDialog<Answers>(
      context: context,
      builder: (BuildContext context) => new SimpleDialog(
        title: new Text('完了済みリストを空にします。'),
        children: <Widget>[
          createDialogOption(context, Answers.YES, 'Yes'),
          createDialogOption(context, Answers.NO, 'No')
        ],
      ),
    ).then((value) {
      switch(value) {
        case Answers.YES:
          setState(() {
            doneList.clear();
          });
          break;
        case Answers.NO:
          break;
      }
    });
  }
  createDialogOption(BuildContext context, Answers answer, String str) {
    return new SimpleDialogOption(child: new Text(str),onPressed: (){Navigator.pop(context, answer);},);
  }
}