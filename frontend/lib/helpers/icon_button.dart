import 'package:flutter/material.dart';

class MIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  const MIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(64, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: const EdgeInsets.all(0),
        iconSize: 32,
        icon: icon,
      ),
    );
  }
}
