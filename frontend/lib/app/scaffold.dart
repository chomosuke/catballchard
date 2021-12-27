import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/account.dart';
import 'package:frontend/app/forms/sign_in_up.dart';
import 'package:frontend/helpers/as_non_null.dart';
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
      child: MFutureBuilder<List<state.Section>>(
        future: widget.currentState.sections,
        builder: (context, data) => ListView(
          scrollDirection: Axis.horizontal,
          children: data
              .map<Widget>(
                (section) => TextButton(
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
              )
              .toList(),
        ),
      ),
    );

    return MFutureBuilder<AsNonNull<String>>(
      future: (() async => AsNonNull(await widget.currentState.username))(),
      builder: (context, data) {
        return Scaffold(
          appBar: AppBar(
            leading: Image.network(baseUrl.resolve('favicon.ico').toString()),
            title: const Text('CatBallChard'),
            leadingWidth: 56 / 210 * 240,
            actions: data.nullable != null
                ? [
                    Center(child: Text('Hello ${data.nullable!}!')),
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
        );
      },
    );
  }
}
