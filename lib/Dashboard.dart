import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'Account.dart';
import 'AccountCard.dart';

import 'Talent.dart';
import 'TalentCard.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<List<dynamic>>> futureAccounts;

  @override
  void initState() {
    super.initState();

    FutureGroup<List<dynamic>> futureGroup = FutureGroup();
    futureGroup.add(Account.fetchAccounts());
    futureGroup.add(Talent.fetchTalent());
    futureGroup.close();
    futureAccounts = futureGroup.future;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchBar(),
        gridView(),
      ],
    );
  }

  Expanded gridView() {
    return Expanded(
      child: FutureBuilder<List<List<dynamic>>>(
          future: futureAccounts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var accountCards = getAccountCards(snapshot.data![0].cast());
              var talentCards = getTalentCards(snapshot.data![1].cast());

              List<Widget> cards = List.of(accountCards);
              cards.addAll(talentCards);

              return GridView.extent(
                // primary: false,
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 300,
                // semanticChildCount: snapshot.data!.length,
                children: cards,
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  List<Widget> getAccountCards(List<Account> accounts) {
    return accounts
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
  }

  List<Widget> getTalentCards(List<Talent> talent) {
    return talent
        .map((a) => GestureDetector(
              onTap: () {
                print("onTap called.");
              },
              child: TalentCard(
                firstName: a.firstName,
                lastName: a.lastName,
              ),
            ))
        .toList();
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

    var filters = FilterBar();

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

class FilterBar extends StatefulWidget {
  FilterBar({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final isSelected = [true, true, true];

  select(int i) {
    setState(() {
      isSelected[i] = true;
    });
  }

  deselect(int i) {
    setState(() {
      isSelected[i] = false;
    });
  }

  toggle(int i) {
    setState(() {
      isSelected[i] = !isSelected[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: toggle,
      isSelected: isSelected,
      selectedBorderColor: Colors.blue,
      selectedColor: Colors.blue,
      borderWidth: 4,
      constraints: BoxConstraints.expand(width: 200, height: 50),
      children: [
        Text('Accounts'),
        Text('Talent'),
        Text('Engagements'),
      ],
    );
  }
}
