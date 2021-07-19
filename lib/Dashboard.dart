import 'package:flutter/material.dart';

import 'Account.dart';
import 'AccountCard.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Account>> futureAccounts;

  @override
  void initState() {
    super.initState();
    futureAccounts = Account.fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchBar(),
        gridView(futureAccounts),
      ],
    );
  }

  Expanded gridView(Future<List<Account>> accounts) {
    return Expanded(
      child: FutureBuilder<List<Account>>(
          future: futureAccounts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var accountCards = snapshot.data!
                  .map((a) => GestureDetector(
                        onTap: () {
                          print("onTap called.");
                        },
                        child: AccountCard(
                          name: a.name,
                          squadManager: a.squadManager,
                          designManager: a.designManager,
                          btcManager: a.btcManager,
                          ctl: a.ctl,
                        ),
                      ))
                  .toList();

              return GridView.extent(
                // primary: false,
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 300,
                // semanticChildCount: snapshot.data!.length,
                children: accountCards,
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  ConstrainedBox searchBar() {
    var searchField = Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            size: 30.0,
          ),
        ),
      ),
    );

    var filters = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => null,
          child: Text("Accounts"),
        ),
        OutlinedButton(
          onPressed: () => null,
          child: Text("Talent"),
        ),
        OutlinedButton(
          onPressed: () => null,
          child: Text("Engagement"),
        ),
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 300, maxWidth: 800),
      child: Column(
        children: [
          searchField,
          filters,
        ],
      ),
    );
  }
}
