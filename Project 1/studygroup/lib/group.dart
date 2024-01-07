class Group {
  final String name;
  final String location;
  final String time;
  final int numberOfPeople;
  final String date;
  bool isExpanded;

  Group({
    required this.name,
    required this.location,
    required this.time,
    required this.numberOfPeople,
    required this.date,
    this.isExpanded = false,
  });
}
