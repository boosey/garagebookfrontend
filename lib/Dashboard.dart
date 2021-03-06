import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'Account.dart';
import 'AccountCard.dart';

import 'Talent.dart';
import 'TalentCard.dart';
import 'package:split_view/split_view.dart';

typedef SelectionChangedCallback = void Function(List<bool> b);

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<List<dynamic>>> futureLists;
  List<bool> filters = [true, true, true];
  List<Widget> accountCards = List.empty();
  List<Widget> talentCards = List.empty();

  @override
  void initState() {
    super.initState();

    getDataFutures();
  }

  getDataFutures() {
    FutureGroup<List<dynamic>> futureGroup = FutureGroup();
    futureGroup.add(Account.fetchAccounts());
    futureGroup.add(Talent.fetchTalent());
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
        Expanded(
          child: SplitView(
            viewMode: SplitViewMode.Horizontal,
            indicator: SplitIndicator(viewMode: SplitViewMode.Horizontal),
            activeIndicator: SplitIndicator(
              viewMode: SplitViewMode.Horizontal,
              isActive: true,
            ),
            controller:
                SplitViewController(limits: [null, WeightLimit(max: 0.5)]),
            onWeightChanged: (w) => print("Vertical $w"),
            children: [
              gridView(),
              detailsView(),
            ],
          ),
        ),
      ],
    );
  }

  Column detailsView() {
    return Column(
      children: [
        Text("First Line"),
        Text("Second Line"),
      ],
    );
  }

  Widget gridView() {
    return FutureBuilder<List<List<dynamic>>>(
        future: futureLists,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> cards = List.empty(growable: true);

            if (filters[0]) {
              cards.addAll(getAccountCards(snapshot.data![0].cast()));
            }

            if (filters[1]) {
              cards.addAll(getTalentCards(snapshot.data![1].cast()));
            }

            return GridView.extent(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              maxCrossAxisExtent: 300,
              children: cards,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
              widthFactor: 1,
              heightFactor: 1,
            );
          }
        });
  }

  List<Widget> getAccountCards(List<Account> accounts) {
    if (accounts.length != accountCards.length) {
      accountCards = accounts
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

    return accountCards;
  }

  List<Widget> getTalentCards(List<Talent> talent) {
    if (talent.length != talentCards.length) {
      talentCards = talent
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
    return talentCards;
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
