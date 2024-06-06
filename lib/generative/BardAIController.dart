import 'dart:convert';
import 'package:memorymate/generative/BardModel.dart';
import 'package:memorymate/generative/data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BardAIController extends GetxController {
  RxList historyList = RxList<BardModel>([
    BardModel(system: "user", message: "What can you do for me"),
    BardModel(system: "bard", message: "What can you do for me"),
  ]);

  RxBool isLoading = false.obs;

  void sendPrompt(String prompt) async {
    isLoading.value = true;
    var newHistory = BardModel(system: "user", message: prompt);      //creating instance 
    historyList.add(newHistory);
    final body = {
      'prompt': {
        'text': prompt,
      },
    };

    final request = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=$APIKEY'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final response = jsonDecode(request.body);
    final bardReplay = response["candidates"][0]["output"];
    var newHistory2 = BardModel(system: "bard", message: bardReplay);
    historyList.add(newHistory2);
    print(bardReplay.toString());
    isLoading.value = false;
  }

  void removeMessage(BardModel message) {
    historyList.remove(message);
  }
}
