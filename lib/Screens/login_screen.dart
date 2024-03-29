import 'package:bwageul/Services/api_services.dart';
import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showSpinner = false;
  final _formkey = GlobalKey<FormState>();
  bool isPwVisible = false;
  bool _autoLogin = true;
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/bubble1.gif'),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.bubble_chart_outlined,
                          size: 60,
                        ),
                        Text(
                          '봐글봐글',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
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
                        labelText: '아이디를 입력해주세요.',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
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
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
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
                        labelText: '비밀번호를 입력해주세요.',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ), //비밀번호
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: myColor.shade100,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        if (idController.text == '' ||
                            pwController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('입력하지 않은 값이 있습니다.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          bool loginComplete = await ApiService.login(
                              idController.text, pwController.text, _autoLogin);
                          if (loginComplete) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('로그인 성공!'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            idController.clear();
                            pwController.clear();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/main', // 첫 페이지로 설정할 경로
                              (route) => false, // 모든 이전 페이지를 제거
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('자동 로그인'),
                      value: _autoLogin,
                      activeColor: myColor.shade100,
                      onChanged: (bool? value) {
                        setState(() {
                          _autoLogin = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1.0,
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          color: Colors.black,
                        ),
                        Container(
                          width: 45,
                          child: const Text(
                            '  또는  ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          height: 1.0,
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                          color: Colors.black,
                        ),
                      ],
                    )), //수평선
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black, width: 3),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text(
                          '회원가입',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
