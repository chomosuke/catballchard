import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: Image.network(baseUrl.resolve('favicon.ico').toString()),
        title: const Text('CatBallChard'),
        leadingWidth: 56 / 210 * 240,
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
  }
}
