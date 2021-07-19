import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String name;
  final String squadManager;
  final String designManager;
  final String btcManager;
  final String ctl;

  const AccountCard({
    required this.name,
    required this.squadManager,
    required this.designManager,
    required this.btcManager,
    required this.ctl,
  });

  @override
  Widget build(BuildContext context) {
    const EdgeInsets insets = EdgeInsets.only(left: 8.0, bottom: 8.0);
    const TextStyle nameStyle = TextStyle(fontWeight: FontWeight.bold);

    return Card(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.apartment),
              title: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              horizontalTitleGap: 0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Squad Manager',
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: insets,
                    child: Text(
                      this.squadManager,
                      style: nameStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text(
                    'Design Manager',
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: insets,
                    child: Text(
                      this.designManager,
                      style: nameStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text(
                    'BTC Manager',
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: insets,
                    child: Text(
                      this.btcManager,
                      style: nameStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text(
                    'CTL',
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: insets,
                    child: Text(
                      this.ctl,
                      style: nameStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
