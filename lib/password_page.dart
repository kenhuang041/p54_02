import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled3/DatabaseHelper02.dart';
import 'package:untitled3/pages/account_manage.dart';
import 'package:untitled3/pages/my_favorite.dart';
import 'package:untitled3/pages/password_manage.dart';

class PasswordPage extends StatefulWidget {
  final String nm,br;
  PasswordPage({Key? key,required this.nm,required this.br});

  @override
  MyState createState() => MyState();
}

class MyState extends State<PasswordPage> {
  final DatabaseHelper02 _dbHelper02 = DatabaseHelper02();
  final TextEditingController txt01 = TextEditingController();
  final TextEditingController txt02 = TextEditingController();
  final GlobalKey<PasswordManageState> _pskey = GlobalKey();
  int currentIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [PasswordManage(key: _pskey),AccountManage(),MyFavorite()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu,color: Colors.white,)
              );
            }
        )
      ),
      body: pages[currentIndex],

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text("${widget.nm}"),
                accountEmail: Text("${widget.br}"),
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/user-vector.jpg"),
                )
            ),

            ListTile(
              title: const Text("密碼管理"),
              leading: const Icon(Icons.password),
              onTap: () {
                _onItemClick(0);
              },
            ),
            ListTile(
              title: const Text("帳號管理"),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                _onItemClick(1);
              },
            ),
            ListTile(
              title: const Text("我的最愛"),
              leading: const Icon(Icons.favorite_border),
              onTap: () {
                _onItemClick(2);
              },
            ),
            ListTile(
              title: const Text("離開"),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      floatingActionButton: currentIndex == 0 ? FloatingActionButton(
          onPressed: () {
            showAddDialog(context);
          },
          child: Icon(Icons.add),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _onItemClick(int index) {
    Navigator.pop(context);
    setState(() {
      currentIndex = index;
    });
  }

  void showAddDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('新增密碼庫項目',style: TextStyle(fontWeight: FontWeight.bold),),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                const Text('輸入亂數生成字串需包含的字元集，以及生成字串的長度'),
                SizedBox(height: 20,),

                const Text('指定字元集:'),
                Container(
                  height: 35,
                  width: 300,
                  alignment: Alignment.topLeft,
                  child: TextField(
                    controller: txt01,
                    decoration: InputDecoration(
                      hintText: 'A1b2#3...',
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                const Text('字串長度:'),
                Container(
                  height: 35,
                  width: 300,
                  alignment: Alignment.topLeft,
                  child: TextField(
                    controller: txt02,
                    decoration: InputDecoration(
                      hintText: '10',
                    ),
                  ),
                ),
              ],
            ),

            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    if(txt01.text != "" && txt02.text != "") {
                      Random random = Random();
                      List<String> lst = [];
                      String s = txt01.text;
                      int r,n = int.parse(txt02.text);

                      for(int i=0; i<n; i++){
                        r = random.nextInt(s.length);
                        lst.add(s[r]);
                      }

                      await _dbHelper02.insertItem(Item(
                          password: lst.join(),
                          favorite: 0,
                      ));

                      print(lst.join());

                      showSnackBar(context, '密碼新增成功', Colors.green);
                      Navigator.pop(context);

                      _pskey.currentState?.reviewState();
                    }
                    else{
                      showSnackBar(context, '新增失敗，內容不能為空', Colors.red);
                    }
                  },
                  child: const Text('新憎')
              )
            ],
          );
        }
    );
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