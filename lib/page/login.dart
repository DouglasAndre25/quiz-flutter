import 'package:flutter/material.dart';
import 'package:quiz_flutter/model/user.dart';
import 'package:quiz_flutter/page/home.dart';
import 'package:quiz_flutter/page/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMsg = "";

  _handleLogin() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty || password.isNotEmpty) {
      if (!email.contains("@")) {
        setState(() {
          _errorMsg = "Informe um e-mail válido!";
        });
      } else if (!(password.length > 6)) {
        setState(() {
          _errorMsg = "Senha deve ter mais de 6 caracteres!";
        });
      } else {
        setState(() {
          _errorMsg = "";
        });

        UserApplication usuario = UserApplication(email, password);

        _loginAuthFirebase(usuario);
      }
    } else {
      setState(() {
        _errorMsg = "Preencha todos os campos!";
      });
    }
  }

  _loginAuthFirebase(UserApplication user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false))
        .catchError((error) => {
              setState(() {
                _errorMsg =
                    "Erro ao logar o usuário. Confirme os dados informados!";
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding:
              const EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 40),
          child: Column(children: <Widget>[
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 100,
            ),
            Padding(
                padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Email', border: OutlineInputBorder()),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                )),
            Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Senha', border: OutlineInputBorder()),
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                )),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Text(
                _errorMsg,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue)),
                        child: const Text("Cadastrar"),
                      )),
                  SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () {
                          _handleLogin();
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue)),
                        child: const Text("Entrar"),
                      )),
                ],
              ),
            )
          ]),
        ));
  }
}
