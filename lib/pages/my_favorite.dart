import 'package:flutter/material.dart';
import 'package:untitled3/DatabaseHelper02.dart';

class MyFavorite extends StatefulWidget {
  @override
  myState createState() => myState();
}

class myState extends State<MyFavorite> {
  final DatabaseHelper02 _dbHelper02 = DatabaseHelper02();
  final TextEditingController txt01 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: <Widget>[
        Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),

              child: FutureBuilder<List<Item>> (
                  future: _dbHelper02.getFavoriteItem(),
                  builder: (context,snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }
                    else if(snapshot.hasError) {
                      return Text('error: ${snapshot.error}');
                    }
                    else if(!snapshot.hasData && snapshot.data!.isEmpty) {
                      return Text('no data');
                    }

                    List<Item> lst = snapshot.data!;
                    return ListView.builder(
                        itemCount: lst.length,
                        itemBuilder: (context,index) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: ListTile(
                              contentPadding: EdgeInsets.only(left: 22),
                              title: Text(lst[index].password),
                              leading: Icon(Icons.password_sharp),

                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  //SizedBox(width: 50,child: Container(color: Colors.amber,),),

                                  IconButton(
                                    onPressed: () async {
                                      await _dbHelper02.updateItem(Item(
                                        id: lst[index].id,
                                        password: lst[index].password,
                                        favorite: lst[index].favorite == 0 ? 1 : 0,
                                      ));

                                      setState(() {});
                                    },
                                    icon: lst[index].favorite == 0 ? Icon(Icons.favorite_border) : Icon(Icons.favorite),
                                  ),

                                  PopupMenuButton(
                                    itemBuilder: (context) {
                                      return const <PopupMenuEntry>[
                                        PopupMenuItem(
                                          child: const Text('修改'),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: const Text('刪除'),
                                          value: 2,
                                        ),
                                      ];
                                    },

                                    color: Colors.grey[300],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    offset: const Offset(100, 30),
                                    onSelected: (value) {
                                      if(value == 1) {
                                        _udItem(context,Item(
                                          id: lst[index].id,
                                          password: lst[index].password,
                                          favorite: lst[index].favorite,
                                        ));
                                      }
                                      else {
                                        _dtItem(lst[index].id);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
              ),
            )
        ),
      ],
    );
  }

  void _udItem(BuildContext context,Item item) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('修改密碼庫項目',style: TextStyle(fontWeight: FontWeight.bold),),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                const Text('將密碼修改為:'),
                Container(
                  height: 35,
                  width: 300,
                  alignment: Alignment.topLeft,
                  child: TextField(controller: txt01,),
                ),
              ],
            ),

            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    if(txt01 != ""){
                      item.password = txt01.text;
                      await _dbHelper02.updateItem(item);

                      showSnackBar(context, '修改成功', Colors.green);
                      Navigator.pop(context);

                      setState(() {});
                      txt01.text = "";
                    }
                    else{
                      showSnackBar(context, '修改失敗，內容不能為空', Colors.red);
                    }
                  },
                  child: const Text('修改')
              )
            ],
          );
        }
    );
  }

  void _dtItem(int? id) async {
    if(id == null) print('error delete');
    else{
      await _dbHelper02.deleteItem(id);
      setState(() {});
    }
  }

  void showSnackBar(BuildContext context,String str,var color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$str'),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }
}