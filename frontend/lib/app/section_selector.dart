import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/app/forms/add_section.dart';
import 'package:frontend/app/forms/rename_section.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/helpers/warning_dialog.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;

class SectionSelector extends StatelessWidget {
  final Future<List<state.Section>> sections;
  final Future<String?> username;
  final void Function(state.Section section) onSelect;
  const SectionSelector({
    Key? key,
    required this.sections,
    required this.username,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: MFutureBuilder<List<dynamic>>(
        future: Future.wait([sections, username]),
        builder: (context, data) {
          final scrollController = ScrollController();
          final List<state.Section> sections = data[0];
          final String? username = data[1];
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
                  children: sections
                      .map<Widget>(
                        (section) => Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: () => onSelect(section),
                              child: MFutureBuilder<state.SectionData>(
                                future: section.data,
                                builder: (context, data) => Container(
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    data.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (section.owned)
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        RenameSection(section: section),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            if (section.owned)
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => WarningDialog(
                                        title: 'Delete Section',
                                        description:
                                            'This will remove the section and all the cards belonging to it permanantely',
                                        callback: () {
                                          StoreProvider.of<Future<state.State>>(
                                                  context)
                                              .dispatch(
                                            action.DeleteSection(section),
                                          );
                                        }),
                                  );
                                },
                                icon: const Icon(Icons.delete_forever_outlined),
                              ),
                          ],
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
              if (username != null)
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
  }
}
