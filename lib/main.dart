import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:adwaita/adwaita.dart' as adwaita;
import 'package:http/http.dart' as http;

import 'dart:convert';

void main() {
  runApp(GetMaterialApp(
    home: Home(),
    theme: adwaita.lightTheme,
    darkTheme: adwaita.darkTheme,
    title: "Fact Cat",
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    Controller controller = Get.put(Controller());
    return Scaffold(
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.calculate),
                  label: 'Number Facts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shuffle),
                  label: 'Random Facts',
                ),
              ],
              currentIndex: controller.selectedIndex.value,
              selectedItemColor: Colors.amber[800],
              onTap: controller.onItemTapped,
            )),
        body: Center(
            child: SingleChildScrollView(
                child: Obx(
          () => Container(
            margin: const EdgeInsets.all(40.0),
            child: Visibility(
                visible: controller.factVisible.value,
                replacement: CircularProgressIndicator(
                  value: null,
                ),
                child: Text(
                  "${controller.fact}",
                  style: TextStyle(fontSize: 40),
                )),
          ),
        ))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.skip_next), onPressed: controller.fetchFact));
  }
}

class Controller extends GetxController {
  var fact = ''.obs;
  var selectedIndex = 0.obs;
  var factVisible = false.obs;
  var urls = [
    "http://numbersapi.com/random/trivia",
    "https://uselessfacts.jsph.pl/random.json?language=en"
  ];
  @override
  void onInit() {
    super.onInit();
    fetchFact();
  }

  fetchFact() async {
    factVisible.value = false;
    var response = await http.get(Uri.parse(urls[selectedIndex.value]));
    if (response.statusCode == 200) {
      if (selectedIndex == 1) {
        Map<String, dynamic> data = jsonDecode(response.body);
        fact.value = data["text"];
      } else {
        fact.value = response.body;
      }
    }
    factVisible.value = true;
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
    fetchFact();
  }
}
