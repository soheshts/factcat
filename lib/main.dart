import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import 'dart:convert';

void main() {
  runApp(GetMaterialApp(
    home: Home(),
    title: "Fact Cat",
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    Controller controller = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "FactCat",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            tooltip: 'Menu',
            onPressed: () {
              showModalBottomSheet<void>(
                // context and builder are
                // required properties in this widget
                context: context,
                builder: (BuildContext context) {
                  // we set up a container inside which
                  // we create center column and display text
                  return Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Categories',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ListTile(
                            title: Text("Number"),
                            onTap: () => {
                              controller.selectedIndex.value = 0,
                              Navigator.pop(context),
                              controller.fetchFact()
                            },
                          ),
                          ListTile(
                              title: Text("Random"),
                              onTap: () => {
                                    controller.selectedIndex.value = 1,
                                    Navigator.pop(context),
                                    controller.fetchFact()
                                  })
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.black,
              ),
              tooltip: 'Info',
              onPressed: () {
                showModalBottomSheet<void>(
                  // context and builder are
                  // required properties in this widget
                  context: context,
                  builder: (BuildContext context) {
                    // we set up a container inside which
                    // we create center column and display text
                    return Container(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('API Used',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text('http://numbersapi.com/random/trivia'),
                            const Text(
                                'https://uselessfacts.jsph.pl/random.json?language=en'),
                            const Text('Logo',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(
                                'Made by Freepik (https://www.freepik.com)'),
                            const Text(
                                'from Flaticon (https://www.flaticon.com/)'),
                            const Text('Source',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(
                                'Github (https://github.com/soheshts/factcat)'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
        ),
        // extendBody: true,

        backgroundColor: Colors.white,
        bottomNavigationBar: Obx(() => Container(
            margin: EdgeInsets.all(30),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  backgroundColor: Colors.purple[100],
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.share),
                      label: 'Share',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.skip_next),
                      label: 'Next',
                    ),
                  ],
                  currentIndex: controller.selectedIndex.value,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black,
                  onTap: controller.onItemTapped,
                )))),
        body: Center(
            child: SingleChildScrollView(
                child: Obx(() => Container(
                      margin: const EdgeInsets.all(40.0),
                      child: Visibility(
                        visible: controller.factVisible.value,
                        replacement: CircularProgressIndicator(
                          value: null,
                        ),
                        child: Text(
                          "${controller.fact}",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    )))));
    /* floatingActionButton: FloatingActionButton(
            child: Icon(Icons.skip_next), onPressed: controller.fetchFact)*/
  }
}

class Controller extends GetxController {
  var fact = ''.obs;
  var selectedIndex = 1.obs;
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
    //selectedIndex.value = index;
    if (index == 0) {
      Share.share('"' + fact.value + '" - FactCat');
    } else {
      fetchFact();
    }
  }
}
