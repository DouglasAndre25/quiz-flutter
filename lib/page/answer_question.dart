import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_flutter/model/question.dart';

class AnswerQuestion extends StatefulWidget {
  const AnswerQuestion({super.key});

  @override
  AnswerQuestionState createState() => AnswerQuestionState();
}

class AnswerQuestionState extends State<AnswerQuestion> {
  String? choice = '';
  String errorMsg = '';

  FirebaseFirestore db = FirebaseFirestore.instance;

  void _handleSend(Question question) async {
    if (choice != '') {
      List<dynamic> choiceResponse = question.choices
          .where((element) => element['description'] == choice)
          .toList();

      db
          .collection('question')
          .where('name', isEqualTo: question.name)
          .get()
          .then((value) => value.docs.forEach((element) {
                element.reference.update({
                  'status': choiceResponse.first['isCorrect']
                      ? 'Acertou essa pergunta'
                      : 'Errou essa pergunta',
                });
              }))
          .then((value) => Navigator.of(context).pop());
    } else {
      setState(() {
        errorMsg = 'Selecione uma resposta';
      });
    }
  }

  Widget _body(Question question) {
    List<Widget> options = [];

    for (var choiceResponse in question.choices) {
      options.add(ListTile(
        title: Text(choiceResponse['description']),
        leading: Radio<String>(
          value: choiceResponse['description'].toString(),
          groupValue: choice,
          onChanged: (String? value) {
            setState(() {
              choice = value;
            });
          },
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Text(question.name, style: TextStyle(fontSize: 30)),
          ),
          Column(
            children: options,
          ),
          Text(errorMsg),
          ButtonBar(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _handleSend(question);
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                child: const Text("Enviar"),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    Question question = arguments['question'];

    return Scaffold(
      backgroundColor: Colors.purple,
      body: _body(question),
      appBar: AppBar(
        title: Text('Responder a pergunta'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
