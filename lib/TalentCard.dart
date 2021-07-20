import 'package:flutter/material.dart';

class TalentCard extends StatelessWidget {
  final String firstName;
  final String lastName;

  const TalentCard({
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    // const EdgeInsets insets = EdgeInsets.only(left: 8.0, bottom: 8.0);
    const TextStyle nameStyle = TextStyle(fontWeight: FontWeight.bold);

    return Card(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                '$firstName $lastName',
                style: nameStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              horizontalTitleGap: 0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
