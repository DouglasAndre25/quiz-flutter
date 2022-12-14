import 'package:quiz_flutter/storage.dart';

class StorageService {
  Future<void> clear() async {
    await storage.delete(key: 'questions');
  }

  Future<String?> getQuestions() async {
    String? questionString = await storage.read(key: 'questions');
    if (questionString != null) {
      return questionString;
    }

    return null;
  }

  Future<void> setQuestion(dynamic question) async {
    await storage.write(key: 'question', value: question);
  }
}
