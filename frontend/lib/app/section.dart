import 'package:flutter/material.dart' hide Card;
import 'package:frontend/helpers/future_builder.dart';
import 'card.dart';
import 'package:frontend/states/state.dart' as state;

class Section extends StatelessWidget {
  final state.Section section;
  const Section({
    Key? key,
    required this.section,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder<state.SectionData>(
      future: section.data,
      builder: (context, data) => GridView.builder(
        itemCount: data.cards.length,
        padding: const EdgeInsets.all(30),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 182 * 2,
          // ^ should be double of the total width of buttons + all paddings
          childAspectRatio: 9 / 10,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
        ),
        itemBuilder: (context, index) => Card(card: data.cards[index]),
      ),
    );
  }
}
