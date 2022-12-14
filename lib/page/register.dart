import 'package:flutter/material.dart';
import 'package:quiz_flutter/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_flutter/page/home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMsg = "";

  _handleRegister() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (name.isNotEmpty || email.isNotEmpty || password.isNotEmpty) {
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

        UserApplication user = UserApplication(email, password);
        _registerAuthFirebase(user);
      }
    } else {
      setState(() {
        _errorMsg = "Preencha todos os campos";
      });
    }
  }

  _registerAuthFirebase(UserApplication user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false))
        .catchError((error) => {
              setState(() {
                _errorMsg =
                    "Erro ao cadastrar o usuário. Confirme os dados informados!";
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
          child: Column(children: <Widget>[
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 100,
            ),
            Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Nome Completo', border: OutlineInputBorder()),
                  controller: _nameController,
                )),
            Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
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
              padding: EdgeInsets.only(top: 40, left: 10, right: 10),
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue)),
                        child: const Text("Voltar"),
                      )),
                  SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () {
                          _handleRegister();
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue)),
                        child: const Text("Cadastrar"),
                      )),
                ],
              ),
            )
          ])),
    );
  }
}
