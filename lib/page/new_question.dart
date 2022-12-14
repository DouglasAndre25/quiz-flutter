import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewQuestion extends StatefulWidget {
  const NewQuestion({super.key});

  @override
  NewQuestionState createState() => NewQuestionState();
}

class NewQuestionState extends State<NewQuestion> {
  List<String> dropdownOptions = <String>[
    'Opção n° 1',
    'Opção n° 2',
    'Opção n° 3',
    'Opção n° 4'
  ];

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  String dropdownValue = 'Opção n° 1';

  String _errorMsg = '';

  FirebaseFirestore db = FirebaseFirestore.instance;

  void _handleSubmit() {
    String description = _descriptionController.text;
    String option1 = _option1Controller.text;
    String option2 = _option2Controller.text;
    String option3 = _option3Controller.text;
    String option4 = _option4Controller.text;

    if (description.isNotEmpty ||
        option1.isNotEmpty ||
        option2.isNotEmpty ||
        option3.isNotEmpty ||
        option4.isNotEmpty) {
      setState(() {
        _errorMsg = '';
      });

      db.collection('question').add({
        'name': description,
        'status': 'Não respondido',
        'choices': [
          {'description': option1, 'isCorrect': dropdownValue == 'Opção n° 1'},
          {'description': option2, 'isCorrect': dropdownValue == 'Opção n° 2'},
          {'description': option3, 'isCorrect': dropdownValue == 'Opção n° 3'},
          {'description': option4, 'isCorrect': dropdownValue == 'Opção n° 4'},
        ]
      }).then((value) => Navigator.of(context).pop());
    } else {
      setState(() {
        _errorMsg = 'Preencha todos os campos';
      });
    }
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
      child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: 'Descrição da pergunta',
                  border: OutlineInputBorder()),
            )),
        Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              controller: _option1Controller,
              decoration: InputDecoration(
                  hintText: 'Opção n° 1', border: OutlineInputBorder()),
            )),
        Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              controller: _option2Controller,
              decoration: InputDecoration(
                  hintText: 'Opção n° 2', border: OutlineInputBorder()),
            )),
        Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              controller: _option3Controller,
              decoration: InputDecoration(
                  hintText: 'Opção n° 3', border: OutlineInputBorder()),
            )),
        Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              controller: _option4Controller,
              decoration: InputDecoration(
                  hintText: 'Opção n° 4', border: OutlineInputBorder()),
            )),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Text('Selecione a opção que é a correta'),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: DropdownButton(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value ?? '';
                  });
                },
                items: dropdownOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList())),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
          child: Text(
            _errorMsg,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: _body(),
      appBar: AppBar(
        title: Text('Nova pergunta'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleSubmit();
        },
        tooltip: 'Cadastrar pergunta',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
