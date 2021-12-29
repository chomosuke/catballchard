import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:frontend/helpers/icon_button.dart';
import 'package:frontend/helpers/pick_image.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:frontend/actions/reducer.dart' as action;

class EditCard extends StatefulWidget {
  final state.Card card;
  const EditCard({Key? key, required this.card}) : super(key: key);

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  Future<String>? imageUrl;
  TextEditingController? descriptionController;

  @override
  Widget build(BuildContext context) {
    return MFutureBuilder<state.CardData>(
      future: widget.card.data,
      builder: _build,
    );
  }

  Widget _build(BuildContext context, state.CardData cardData) {
    // lazy init descriptionController
    descriptionController ??= TextEditingController.fromValue(
      TextEditingValue(text: cardData.description),
    );

    const double padding = 25;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Container(
        height: 600,
        width: 500,
        margin: const EdgeInsets.all(padding),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: MFutureBuilder<String>(
                      alwaysShowLoading: true,
                      future: imageUrl != null
                          ? imageUrl!
                          : (() async => (await widget.card.data).imageUrl)(),
                      builder: (context, data) => Image.network(
                        data,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                  MIconButton(
                    onPressed: () async {
                      final img = await pickImage();
                      if (img != null) {
                        setState(() {
                          imageUrl = img;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'description'),
              controller: descriptionController,
            ),
            SizedBox.fromSize(size: const Size(0, 25)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    StoreProvider.of<Future<state.State>>(context).dispatch(
                      action.EditCard(
                        widget.card,
                        imageUrl: await imageUrl,
                        description: descriptionController!.text,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirm'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
