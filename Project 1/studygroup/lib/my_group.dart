import 'package:flutter/material.dart';
import 'group.dart';

class MyGroupScreen extends StatelessWidget {
  final List<Group> joinedGroups;

  //constructor to receive list of joined groups
  const MyGroupScreen({Key? key, required this.joinedGroups}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Group'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //check if user has joined any groups
                  joinedGroups.isEmpty
                      ? const Text(
                          'You haven\'t joined any groups yet. Join or create one!')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //display each groups is Card
                            for (Group group in joinedGroups)
                              _buildGroupCard(group),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(Group group) {
    return Column(
      children: [
        _buildExpansionTile(group),
        const SizedBox(height: 3),
      ],
    );
  }

  Widget _buildExpansionTile(Group group) {
    return Card(
      child: ExpansionTile(
        title: Text(
          group.name,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        children: [
          _buildDetailTile(Icons.location_on, group.location),
          _buildDetailTile(Icons.access_time, group.time),
          _buildDetailTile(Icons.people, '${group.numberOfPeople}'),
          _buildDetailTile(Icons.calendar_today, group.date),
        ],
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(value),
    );
  }
}
