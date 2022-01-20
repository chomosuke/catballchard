import 'package:flutter/material.dart' hide Card;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/reducer.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
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
      builder: (context, data) {
        final itemCount = data.cards.length;
        const padding = EdgeInsets.all(30);
        const gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 182 * 2,
          // ^ should be double of the total width of buttons + all paddings
          childAspectRatio: 9 / 10,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
        );
        Widget itemBuilder(context, index) => Card(
              key: ValueKey(data.cards[index].id),
              card: data.cards[index],
            );
        if (section.owned) {
          return ReorderableGridView.builder(
            onReorder: (oldIndex, newIndex) {
              StoreProvider.of<Future<state.State>>(context)
                  .dispatch(ReorderCards(section, oldIndex, newIndex));
            },
            padding: padding,
            gridDelegate: gridDelegate,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          );
        } else {
          return GridView.builder(
            padding: padding,
            gridDelegate: gridDelegate,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          );
        }
      },
    );
  }
}
