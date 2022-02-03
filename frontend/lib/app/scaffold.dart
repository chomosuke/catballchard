import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/account.dart';
import 'package:frontend/app/forms/change_password.dart';
import 'package:frontend/app/forms/change_username.dart';
import 'package:frontend/app/section_selector.dart';
import 'forms/add_card.dart';
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
  Future<String>? selectedId;

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder<List<dynamic>>(
      future: Future.wait([
        widget.currentState.username,
        (() async {
          final sections = await widget.currentState.sections;
          selectedId ??= sections.isEmpty ? null : sections[0].id;
          for (final section in sections) {
            if (await section.id == await selectedId) {
              return section;
            }
          }
        })(),
      ]),
      builder: (context, data) {
        final String? username = data[0];
        final state.Section? selected = data[1];

        return Scaffold(
          appBar: AppBar(
            leading: Image.network(baseUrl.resolve('favicon.ico').toString()),
            title: const Text('CatBallChard'),
            leadingWidth: 56 / 210 * 240,
            actions: username != null
                ? [
                    Center(child: Text('Hello $username!')),
                    popupAccountMenu(context),
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
              SectionSelector(
                sections: widget.currentState.sections,
                username: widget.currentState.username,
                onSelect: (section) {
                  setState(() {
                    selectedId = section.id;
                  });
                },
              ),
              Expanded(
                child: selected == null
                    ? const Center(child: Text('no section selected'))
                    : Section(section: selected),
              ),
            ],
          ),
          floatingActionButton:
              username != null && selected != null && selected.owned
                  ? FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddCard(section: selected),
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

  Widget popupAccountMenu(BuildContext context) {
    const changeUsername = 1;
    const changePassword = 2;
    const signOut = 3;
    return PopupMenuButton<int>(
      onSelected: (value) {
        switch (value) {
          case changeUsername:
            showDialog(
              context: context,
              builder: (context) => const ChangeUsername(),
            );
            break;
          case changePassword:
            showDialog(
              context: context,
              builder: (context) => const ChangePassword(),
            );
            break;
          case signOut:
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
            break;
          default:
            throw Error();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text('Change username'),
          value: changeUsername,
        ),
        const PopupMenuItem(
          child: Text('Change password'),
          value: changePassword,
        ),
        const PopupMenuItem(
          child: Text('Sign out'),
          value: signOut,
        ),
      ],
    );
  }
}
