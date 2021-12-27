import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/reducer.dart';
import 'package:frontend/helpers/card_container.dart';
import 'package:frontend/helpers/warning_dialog.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/states/state.dart' as state;

class Card extends StatelessWidget {
  final state.Card card;
  const Card({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void showDelete() {
      showDialog(
        context: context,
        builder: (context) => WarningDialog(
          title: 'Delete Card',
          description:
              'This will remove the card \npermanantely from this website.',
          callback: () => StoreProvider.of<Future<state.State>>(context)
              .dispatch(DeleteCard(card)),
        ),
      );
    }

    final deleteButton = Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(64, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: IconButton(
        onPressed: showDelete,
        padding: const EdgeInsets.all(0),
        iconSize: 32,
        icon: const Icon(Icons.delete_forever_outlined),
      ),
    );

    final owned = card.section.owned;

    return MFutureBuilder<state.CardData>(
      future: card.data,
      builder: (context, data) => CardContainer(
        padding: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                      data.imageUrl,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  if (owned) deleteButton,
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: SelectableText(
                data.description,
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
