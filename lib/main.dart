import 'package:flutter/material.dart';
import 'package:untitled3/DatabaseHelper01.dart';
import 'package:untitled3/password_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  startState createState() => startState();
}

class startState extends State<StartPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.lock,size: 60,),
              const SizedBox(height: 10,),
              const Text('密碼庫',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 45),)
            ],
          )
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final TextEditingController txt01 = TextEditingController();
  final TextEditingController txt02 = TextEditingController();
  final TextEditingController txt03 = TextEditingController();
  final TextEditingController txt04 = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),

        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[
              const Text('姓名:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt01,
                  decoration: InputDecoration(
                    //hintText: '黃冠豪',
                  ),
                ),
              ),

              const SizedBox(height: 25,),
              const Text('生日:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt02,
                  decoration: InputDecoration(
                    //hintText: '2001/01/01',
                  ),
                ),
              ),

              const SizedBox(height: 25,),
              const Text('Email:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt03,
                  decoration: InputDecoration(
                    //hintText: '...@gmail.com',
                  ),
                ),
              ),

              const SizedBox(height: 25,),
              const Text('密碼:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt04,
                  decoration: InputDecoration(
                    //hintText: '123...',
                  ),
                ),
              ),

              const SizedBox(height: 170,),
              Container(
                margin: const EdgeInsets.only(left: 107),
                child: ElevatedButton(
                  onPressed: () async {
                    String str = "登入成功";
                    var color = Colors.green;

                    if(txt01.text != "" && txt02.text != "" && txt03.text != "" && txt04.text != "") {
                      User user = await _dbHelper.getUser(User(
                        name: txt01.text,
                        email: txt02.text,
                        birthday: txt03.text,
                        password: txt04.text,
                      ));

                      if((user.name == user.email) && (user.email == user.birthday) && (user.birthday == user.password)){
                        str = "登入失敗，可能不存在此帳號";
                        color = Colors.red;
                      }
                      else{
                        print(user.name + "\n" + user.email + "\n" + user.birthday + "\n" + user.password);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage()));
                      }
                      /*I/flutter ( 5842): ken 2008/04/01 kenhuang0401@gmail.com 12345
E/flutter ( 5842): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: Bad state: No element
E/flutter ( 5842): #0      List.first (dart:core-patch/growable_array.dart:344:5)
E/flutter ( 5842): #1      DatabaseHelper.getUser (package:untitled3/DatabaseHelper01.dart:81:55)
E/flutter ( 5842): <asynchronous suspension>
E/flutter ( 5842): #2      LoginState.build.<anonymous closure> (package:untitled3/main.dart:147:35)
E/flutter ( 5842): <asynchronous suspension>
E/flutter ( 5842): */
                      showSnackBar(context, str, color);
                      //clearText();
                    }
                  },
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                ),
              ),

              Container(
                  margin: const EdgeInsets.only(left: 105),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[
                      const Text('沒有帳號？',style: TextStyle(fontSize: 12),),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SigninPage()));
                        },

                        child: const Text('註冊',style: TextStyle(fontSize: 12,),),
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          //overlayColor: MaterialStateProperty.all(Colors.transparent),

                          padding: EdgeInsets.zero,
                          alignment: AlignmentDirectional.centerStart,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),

      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            List<User> lst = await _dbHelper.getAllUser();
            print(lst);
          },
          child: Icon(Icons.print),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

  void clearText(){
    txt01.text = "";
    txt02.text = "";
    txt03.text = "";
    txt04.text = "";
  }
}



class SigninPage extends StatelessWidget {
  final TextEditingController txt01 = TextEditingController();
  final TextEditingController txt02 = TextEditingController();
  final TextEditingController txt03 = TextEditingController();
  final TextEditingController txt04 = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sign in',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back,color: Colors.white,),
          ),
        ),

        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[
              const Text('姓名:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt01,
                  decoration: InputDecoration(
                    hintText: '黃冠豪',
                  ),
                ),
              ),

              const SizedBox(height: 25,),
              const Text('生日:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt02,
                  decoration: InputDecoration(
                    hintText: '2001/01/01',
                  ),
                ),
              ),

              const SizedBox(height: 25,),
              const Text('Email:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt03,
                  decoration: InputDecoration(
                    hintText: 'name123@gmail.com',
                  ),
                ),
              ),

              const SizedBox(height: 25,),
              const Text('密碼:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
              Container(
                height: 35,
                width: 300,
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: txt04,
                  decoration: InputDecoration(
                    hintText: '123...',
                  ),
                ),
              ),

              const SizedBox(height: 170,),
              Container(
                margin: const EdgeInsets.only(left: 107),
                child: ElevatedButton(
                  onPressed: () async {
                    String str = "註冊成功";
                    var color = Colors.green;

                    if(txt01.text != "" && txt02.text != "" && txt03.text != "" && txt04.text != "") {
                      await _dbHelper.insertUser(User(
                        name: txt01.text,
                        email: txt02.text,
                        birthday: txt03.text,
                        password: txt04.text,
                      ));

                      Navigator.pop(context);
                    }
                    else {
                      str = "內容不能為空";
                      color = Colors.red;
                    }

                    showSnackBar(context, str, color);
                  },

                  child: const Text('註冊'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                ),
              ),
            ],
          ),
        )
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
