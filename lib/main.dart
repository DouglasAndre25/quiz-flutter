import 'package:flutter/material.dart';
import 'package:quiz_flutter/page/answer_question.dart';
import 'package:quiz_flutter/page/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      theme: ThemeData.from(colorScheme: ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      routes: <String, WidgetBuilder>{
        '/answer': (BuildContext context) => const AnswerQuestion(),
      }));
}
