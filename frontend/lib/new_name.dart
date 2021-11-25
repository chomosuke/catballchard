import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lifecycle.dart' as lifecycle;

class NewName extends StatefulWidget {
  const NewName({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewNameState();
}

class _NewNameContent {
  String? imageUrl;
  String name;
  _NewNameContent(this.imageUrl, this.name);
}

class _NewNameState extends State<NewName> {
  _NewNameContent? _content;

  @override
  Widget build(BuildContext context) {
    final add = Provider.of<lifecycle.All>(context, listen: false).add;
    return Container(
      padding: _content == null ? null : const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: _content == null
          ? IconButton(
              onPressed: () {
                setState(() {
                  _content = _NewNameContent('', '');
                });
              },
              tooltip: 'Add new ComboName',
              icon: const Icon(Icons.add, size: 100),
            )
          : Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'imageUrl'),
                  onChanged: (value) {
                    _content!.imageUrl = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Combo Name'),
                  onChanged: (value) {
                    _content!.name = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _content = null;
                          });
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () {
                          Provider.of<lifecycle.All>(context, listen: false)
                              .add(lifecycle.NewName(
                                  _content!.imageUrl ?? '', _content!.name));
                          setState(() {
                            _content = null;
                          });
                        },
                        child: const Text('Confirm'))
                  ],
                )
              ],
            ),
    );
  }
}