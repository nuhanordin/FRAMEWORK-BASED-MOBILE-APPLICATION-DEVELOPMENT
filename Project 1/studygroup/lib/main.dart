import 'package:flutter/material.dart';
import 'create_group.dart';
import 'group.dart';
import 'my_group.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Group',
      debugShowCheckedModeBanner: false,
      //set default theme
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 45, 43, 43),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 45, 43, 43),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 124, 126, 125),
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //list to keep track of joined group
  List<Group> joinedGroups = [];
  //initialize groups available
  List<Group> availableGroups = [
    Group(
      name: 'Mathematics',
      location: 'Library',
      time: '6:00 PM',
      numberOfPeople: 3,
      date: '2024-2-15',
    ),
    Group(
      name: 'Accounting',
      location: 'Kopi Mesin',
      time: '2:00 PM',
      numberOfPeople: 2,
      date: '2024-2-18',
    ),
    Group(
      name: 'Halal Management',
      location: 'KKSAM',
      time: '9:00 PM',
      numberOfPeople: 4,
      date: '2024-1-20',
    ),
  ];

  //to handle joining a group
  void joinGroup(Group group) {
    setState(() {
      joinedGroups.add(group);
      availableGroups.remove(group);
    });
  }

  //to handle creating a group
  void createGroup(Group group) {
    setState(() {
      joinedGroups.add(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Group Finder'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 43, 43),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Study Group Finder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome, peeps!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Groups'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyGroupScreen(joinedGroups: joinedGroups),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Create Group'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateGroupScreen(onGroupCreated: createGroup),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            //display user's joined groups
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 124, 126, 125),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'My Groups',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //display joined groups or text if none
                  joinedGroups.isEmpty
                      ? const Text(
                          'You haven\'t joined any groups yet. Join or create one!')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //display each joined groups in Card
                            for (Group group in joinedGroups)
                              Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(children: [
                                  ListTile(
                                    title: Text(group.name,
                                        style: const TextStyle(fontSize: 18)),
                                    subtitle: Text(
                                        'Date: ${group.date} | Time: ${group.time}'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyGroupScreen(
                                              joinedGroups: joinedGroups),
                                        ),
                                      );
                                    },
                                  ),
                                ]),
                              )
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 124, 126, 125),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Available Groups',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //display each available group in Card
                  for (Group group in availableGroups)
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(group.name,
                                    style: const TextStyle(fontSize: 18)),
                                Icon(
                                  group.isExpanded
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                ),
                              ],
                            ),
                            subtitle: Text(
                                'Date: ${group.date} | Time: ${group.time}'),
                            onTap: () {
                              setState(() {
                                group.isExpanded = !group.isExpanded;
                              });
                            },
                          ),
                          //details for expanded group
                          if (group.isExpanded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.black),
                                          const SizedBox(width: 4),
                                          Text('Location: ${group.location}'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              color: Colors.black),
                                          const SizedBox(width: 4),
                                          Text('Time: ${group.time}'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.people,
                                              color: Colors.black),
                                          const SizedBox(width: 4),
                                          Text(
                                              'Number: ${group.numberOfPeople}'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              color: Colors.black),
                                          const SizedBox(width: 4),
                                          Text('Date: ${group.date}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                //button to join the group
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        joinGroup(group);
                                      },
                                      child: const Text('Join'),
                                    )),
                                const SizedBox(height: 12),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateGroupScreen(onGroupCreated: createGroup),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 124, 126, 125),
        child: const Icon(Icons.add),
      ),
    );
  }
}
