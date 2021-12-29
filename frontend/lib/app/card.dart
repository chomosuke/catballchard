import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/reducer.dart' as action;
import 'package:frontend/app/forms/edit_card.dart';
import 'package:frontend/helpers/card_container.dart';
import 'package:frontend/helpers/icon_button.dart';
import 'package:frontend/helpers/warning_dialog.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/states/state.dart' as state;

class Card extends StatelessWidget {
  final state.Card card;
  const Card({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteButton = MIconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => WarningDialog(
            title: 'Delete Card',
            description:
                'This will remove the card \npermanantely from this website.',
            callback: () => StoreProvider.of<Future<state.State>>(context)
                .dispatch(action.DeleteCard(card)),
          ),
        );
      },
      icon: const Icon(Icons.delete_forever_outlined),
    );

    final editButton = MIconButton(
      onPressed: () {
        showDialog(
            context: context, builder: (context) => EditCard(card: card));
      },
      icon: const Icon(Icons.edit),
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
                  if (owned)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        deleteButton,
                        editButton,
                      ],
                    ),
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
