import 'package:flutter/material.dart';
import 'package:untitled3/DatabaseHelper01.dart';

class AccountManage extends StatefulWidget {
  @override
  myState createState() => myState();
}

class myState extends State<AccountManage> {
  final TextEditingController txt01 = TextEditingController();
  final TextEditingController txt02 = TextEditingController();
  final TextEditingController txt03 = TextEditingController();
  final TextEditingController txt04 = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: <Widget>[
        Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),

              child: FutureBuilder<List<User>> (
                  future: _dbHelper.getAllUser(),
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

                    List<User> lst = snapshot.data!;
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
                              title: Text(lst[index].name),
                              subtitle: Text(lst[index].password),
                              leading: Icon(Icons.password_sharp),

                              trailing: PopupMenuButton(
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
                                    txt01.text = lst[index].name;
                                    txt02.text = lst[index].birthday;
                                    txt03.text = lst[index].email;
                                    txt04.text = lst[index].password;

                                    _udItem(context,User(
                                        id: lst[index].id,
                                        name: lst[index].name,
                                        email: lst[index].email,
                                        birthday: lst[index].birthday,
                                        password: lst[index].password,
                                    ));
                                  }
                                  else {
                                    _dtItem(lst[index].id);
                                  }
                                },
                              )
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

  void _udItem(BuildContext context,User user) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('修改帳號',style: TextStyle(fontWeight: FontWeight.bold),),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  const Text('姓名:',),
                  Container(
                    height: 35,
                    width: 300,
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: txt01,
                    ),
                  ),

                  const SizedBox(height: 25,),
                  const Text('生日:',),
                  Container(
                    height: 35,
                    width: 300,
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: txt02,
                    ),
                  ),

                  const SizedBox(height: 25,),
                  const Text('Email:',),
                  Container(
                    height: 35,
                    width: 300,
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: txt03,
                    ),
                  ),

                  const SizedBox(height: 25,),
                  const Text('密碼:',),
                  Container(
                    height: 35,
                    width: 300,
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: txt04,
                    ),
                  ),
                ],
              ),
            ),

            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    if(txt01.text != "" && txt02.text != "" && txt03.text != "" && txt04.text != "") {
                      user.name = txt01.text;
                      user.birthday = txt02.text;
                      user.email = txt03.text;
                      user.password = txt04.text;

                      await _dbHelper.updateUser(User(
                        id: user.id,
                        name: user.name,
                        email: user.email,
                        birthday: user.birthday,
                        password: user.password,
                      ));

                      showSnackBar(context, "帳號修改成功", Colors.green);
                      Navigator.pop(context);

                      txt01.text = "";
                      txt02.text = "";
                      txt03.text = "";
                      txt04.text = "";

                      setState(() {});
                    }
                    else {
                      showSnackBar(context, "內容不能為空", Colors.red);
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
      await _dbHelper.deleteUser(id);
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

