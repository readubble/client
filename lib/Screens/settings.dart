import 'package:bwageul/Services/api_services.dart';
import 'package:bwageul/Services/storage.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 35,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '설정',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  bool logoutResult = await ApiService.logout();
                  if (logoutResult) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그아웃 성공'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그아웃 실패! 다시 시도하세요.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )), //로그아웃
          ],
        ),
      )),
    );
  }
}
