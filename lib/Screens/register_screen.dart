import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bwageul/Services/api_services.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool showSpinner = false;
  bool isPwVisible = false;
  bool isPwCheckVisible = false;
  final _formkey = GlobalKey<FormState>(); // Form 위젯을 쓸 땐 global key 를 넣어야 함
  TextEditingController nicknameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  // 닉네임
                  controller: nicknameController,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.sentiment_satisfied_alt,
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    labelText: '닉네임',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //아이디
                  controller: idController,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.people,
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    labelText: '아이디',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //비밀번호
                  controller: pwController,
                  style: const TextStyle(color: Colors.grey),
                  obscureText: !isPwVisible, // 입력시 ****** 처리
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.password,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: isPwVisible
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                      onPressed: () {
                        setState(() {
                          isPwVisible = !isPwVisible;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    labelText: '비밀번호',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //비밀번호 확인
                  controller: pwCheckController,
                  style: const TextStyle(color: Colors.grey),
                  obscureText: !isPwCheckVisible, // 입력시 ****** 처리
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.done_all,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: isPwCheckVisible
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                      onPressed: () {
                        setState(() {
                          isPwCheckVisible = !isPwCheckVisible;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    labelText: '비밀번호 확인',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColor.shade100,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (pwController.text != pwCheckController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('비밀번호를 다시 입력하세요.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else if (nicknameController.text == '' ||
                        idController.text == '' ||
                        pwController.text == '' ||
                        pwCheckController.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('입력하지 않은 값이 있습니다.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      // 정상 가입
                      ApiService.signUp(nicknameController.text,
                          idController.text, pwController.text);
                      nicknameController.clear();
                      idController.clear();
                      pwController.clear();
                      pwCheckController.clear();
                      Navigator.popUntil(
                          context, ModalRoute.withName('/login'));
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      '회원가입',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ) // 회원가입 버튼
              ],
            ),
          ),
        ),
      ),
    );
  }
}
