import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_flutter/model/question.dart';
import 'package:quiz_flutter/page/answer_question.dart';
import 'package:quiz_flutter/page/new_question.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  dynamic _body() {
    return StreamBuilder(
      stream: db.collection('question').snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.done:

          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando Perguntas..."),
                ],
              ),
            );

          case ConnectionState.active:
            if (snapshot.hasError) {
              return Container(
                child: Text("Ocorreram erros ao carregar os dados!"),
              );
            } else {
              QuerySnapshot<Map<String, dynamic>>? querySnapshot =
                  snapshot.data;
              return Container(
                child: ListView.builder(
                  itemCount: querySnapshot?.docs.length,
                  itemBuilder: (context, index) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>?
                        questions = querySnapshot?.docs.toList();
                    DocumentSnapshot dados = questions![index];

                    Question question = Question(
                        dados['name'], dados['choices'], dados['status']);

                    return Card(
                      child: Column(children: <Widget>[
                        ListTile(
                          title: Text(question.name),
                          subtitle: Text(question.status),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/answer',
                                    arguments: {'question': question});
                              },
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue)),
                              child: const Text("Responder"),
                            )
                          ],
                        )
                      ]),
                    );
                  },
                ),
              );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: Text("Perguntas cadastradas"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewQuestion()));
        },
        tooltip: 'Nova Pergunta',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
