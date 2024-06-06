import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:memorymate/generative/BardAIController.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BardAIController controller = Get.put(BardAIController());
    TextEditingController textField = TextEditingController();
    return Scaffold(
      backgroundColor: Color.fromARGB(210, 145, 149, 246),
      appBar: AppBar(
        centerTitle: true,
        leading: SvgPicture.asset(
          "assets/bard_logo.svg",
          width: 10,
        ),
        title: const Text(
          "MEMORYMATE",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        actions: [
          IconButton(
              onPressed: () {
                controller.sendPrompt("Hello what can you do for me ");
              },
              icon: Icon(Icons.security))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Welcome ask some thing  ❤️ "),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("😍  How can I assist you today?"),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Text(" 🧠 Let's work on some memory exercises!💡 "),
                    ),
                  ],
                ),
                Obx(() => Column(
                      children: controller.historyList
                          .map(
                            (e) => GestureDetector(
                              onLongPress: () {
                                controller.removeMessage(e);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text(e.system == "user" ? "👨‍💻" : "🤖"),
                                    SizedBox(width: 10),
                                    Flexible(child: Text(e.message)),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ))
              ],
            )),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 145, 149, 246),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 60,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: textField,
                    decoration: InputDecoration(
                        hintText: "You can ask what you want",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: () {
                            if (textField.text != "") {
                              controller.sendPrompt(textField.text);
                              textField.clear();
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                ),
                SizedBox(width: 10)
              ]),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
