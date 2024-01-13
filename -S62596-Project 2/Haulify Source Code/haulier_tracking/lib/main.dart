/*
Author: Nuha Nordin
Project: Haulify
File: main.dart
*/
import 'package:flutter/material.dart';
import '../screens/login_register.dart';
import '../utils/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).getCurrentTheme(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int currentIndex = 0;
  final PageController _controllerPage = PageController(initialPage: 0);

  List<Content> contents = [
    Content(
      'https://lottie.host/5cb165a0-897a-42d7-963c-78dea76f16a5/fcLfEsjhQV.json',
      'Haulify',
      'Welcome to Haulify - your solution to efficient truck tracking. Manage your truck, set routes, and ensure timely deliveries with our user-friendly platform.',
    ),
    Content(
      'https://lottie.host/286a3c72-fb35-4181-a514-828bbee89ce0/8NZ2FNcl43.json',
      'Truck Scheduling',
      'Effortlessly schedule your trucks with Haulify. Set dates, times, origins, and destinations to streamline your logistics operations.',
    ),
    Content(
      'https://lottie.host/ac311c71-5adb-45b6-a9a0-f284c22d41aa/x3nnLqhCDd.json',
      'Utilization',
      'Gain insights into your truck fleet utilization with Haulify. Visualize usage patterns through interactive pie charts for optimized operations.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 206, 200, 180),
            Color.fromARGB(255, 87, 172, 123),
            Color.fromARGB(255, 206, 200, 180)
          ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            // reference: Flutter Onboarding Screen | Onboarding tutorial Beginners, https://www.youtube.com/watch?v=k3l3WRTv-Zk
            child: PageView.builder(
              controller: _controllerPage,
              itemCount: 3,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Column(
                    children: [
                      Lottie.network(
                        contents[i].image,
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..repeat();
                        },
                        width: 400,
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              contents[i].title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              contents[i].description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => buildDot(index, context),
            ),
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.all(40),
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                if (currentIndex == 3 - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginRegisterScreen(),
                    ),
                  );
                }
                _controllerPage.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 131, 170, 120)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: Text(
                currentIndex == 3 - 1 ? "Start Tracking" : "Next",
                style: const TextStyle(
                    color: Color.fromARGB(255, 226, 218, 187), fontSize: 15),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 226, 218, 187)),
    );
  }
}

class Content {
  final String image;
  final String title;
  final String description;

  Content(this.image, this.title, this.description);
}
