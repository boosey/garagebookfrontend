import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'Account.dart';
import 'AccountCard.dart';

import 'Talent.dart';
import 'TalentCard.dart';

typedef SelectionChangedCallback = void Function(List<bool> b);

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<List<dynamic>>> futureLists;
  List<bool> filters = [true, true, true];

  @override
  void initState() {
    super.initState();

    // getDataFutures();
  }

  getDataFutures() {
    FutureGroup<List<dynamic>> futureGroup = FutureGroup();

    if (filters[0]) {
      futureGroup.add(Account.fetchAccounts());
    } else {
      futureGroup.add(Future.value(List.empty()));
    }

    if (filters[1]) {
      futureGroup.add(Talent.fetchTalent());
    } else {
      futureGroup.add(Future.value(List.empty()));
    }

    futureGroup.close();
    futureLists = futureGroup.future;
  }

  setFilters(List<bool> f) {
    setState(() {
      filters = f;
    });
  }

  @override
  Widget build(BuildContext context) {
    getDataFutures();

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300, maxWidth: 800),
          child: Column(
            children: [
              searchBar(),
              FilterBar(onChange: (boolList) => setFilters(boolList)),
            ],
          ),
        ),
        gridView(),
      ],
    );
  }

  Expanded gridView() {
    return Expanded(
      child: FutureBuilder<List<List<dynamic>>>(
          future: futureLists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> cards = List.empty(growable: true);

              cards.addAll(getAccountCards(snapshot.data![0].cast()));
              cards.addAll(getTalentCards(snapshot.data![1].cast()));

              return GridView.extent(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 300,
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

  Widget searchBar() {
    return Container(
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
  }
}

class FilterBar extends StatefulWidget {
  final SelectionChangedCallback onChange;

  FilterBar({
    required this.onChange,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final isSelected = [true, true, true];

  toggle(int i) {
    setState(() {
      isSelected[i] = !isSelected[i];
    });
    widget.onChange(isSelected);
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
