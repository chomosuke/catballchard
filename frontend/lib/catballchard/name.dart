import 'package:flutter/material.dart';
import 'package:frontend/flex_with_main_child.dart';
import '../card_container.dart';
import 'package:provider/provider.dart';
import '../lifecycle.dart' as lifecycle;

class Name extends StatefulWidget {
  final lifecycle.Name _name;
  const Name({Key? key, required lifecycle.Name name})
      : _name = name,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _NameState();
}

class _NameState extends State<Name> {
  void markNeedsBuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget._name.addListener(markNeedsBuild);
  }

  @override
  void dispose() {
    super.dispose();
    widget._name.removeListener(markNeedsBuild);
  }

  @override
  Widget build(BuildContext context) {
    void onDelete() {
      Provider.of<lifecycle.All>(context, listen: false).delete(widget._name);
    }

    final deleteDialog = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: const Text('Delete Card'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('This will remove the card \npermanantely from this website.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Confirm',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: onDelete,
        ),
      ],
    );

    final card = CardContainer(
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
                    widget._name.imageUrl,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(64, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => deleteDialog,
                    ),
                    padding: const EdgeInsets.all(0),
                    iconSize: 32,
                    icon: const Icon(Icons.delete_forever_outlined),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: SelectableText(
              widget._name.name,
              style: const TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );

    final dialog = GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Center(
        child: FlexWithMainChild(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          mainChild: Flexible(
            child: Image.network(
              widget._name.imageUrl,
              filterQuality: FilterQuality.medium,
            ),
          ),
          childrenAfter: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              color: const Color.fromARGB(64, 255, 255, 255),
              child: SelectableText(
                widget._name.name,
                style: const TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => dialog,
        );
      },
      child: card,
    );
  }
}
