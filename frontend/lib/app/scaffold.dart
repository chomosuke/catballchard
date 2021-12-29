import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/account.dart';
import 'forms/add_card.dart';
import 'forms/add_section.dart';
import 'forms/sign_in_up.dart';
import 'package:frontend/helpers/warning_dialog.dart';
import 'section.dart';
import 'package:frontend/http/url.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/states/state.dart' as state;

class MScaffold extends StatefulWidget {
  final state.State currentState;
  const MScaffold({
    Key? key,
    required this.currentState,
  }) : super(key: key);

  @override
  State<MScaffold> createState() => _MScaffoldState();
}

class _MScaffoldState extends State<MScaffold> {
  state.Section? selected;

  @override
  Widget build(BuildContext context) {
    final tabs = SizedBox(
      height: 56,
      child: MFutureBuilder<List<dynamic>>(
        future: Future.wait([
          widget.currentState.sections,
          widget.currentState.username,
        ]),
        builder: (context, data) {
          final scrollController = ScrollController();
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset - 200,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 100),
                  );
                },
                icon: const Icon(Icons.navigate_before),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  children: data[0]
                      .map<Widget>(
                        (section) => Container(
                          decoration: const BoxDecoration(
                            border: Border.symmetric(vertical: BorderSide()),
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selected = section;
                              });
                            },
                            child: MFutureBuilder<state.SectionData>(
                              future: section.data,
                              builder: (context, data) => Text(data.name),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              IconButton(
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset + 200,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 100),
                  );
                },
                icon: const Icon(Icons.navigate_next),
              ),
              if (data[1] != null)
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => const AddSection());
                  },
                  icon: const Icon(Icons.add),
                ),
            ],
          );
        },
      ),
    );

    return MFutureBuilder<String?>(
      future: widget.currentState.username,
      nullableBuilder: (context, data) {
        return Scaffold(
          appBar: AppBar(
            leading: Image.network(baseUrl.resolve('favicon.ico').toString()),
            title: const Text('CatBallChard'),
            leadingWidth: 56 / 210 * 240,
            actions: data != null
                ? [
                    Center(child: Text('Hello $data!')),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => WarningDialog(
                            title: 'Sign out',
                            description: 'Are you sure?',
                            callback: () {
                              StoreProvider.of<Future<state.State>>(context)
                                  .dispatch(Logout());
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ]
                : [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const SignInUp(),
                        );
                      },
                      child: const Text(
                        'Sign In / Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
          ),
          body: Column(
            children: [
              tabs,
              Expanded(
                child: selected == null
                    ? const Center(child: Text('no section selected'))
                    : Section(section: selected!),
              ),
            ],
          ),
          floatingActionButton:
              data != null && selected != null && selected!.owned
                  ? FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddCard(section: selected!),
                        );
                      },
                      tooltip: 'Add new card',
                      child: const Icon(Icons.add),
                    )
                  : null,
        );
      },
    );
  }
}
