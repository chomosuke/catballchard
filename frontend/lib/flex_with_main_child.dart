import 'package:flutter/cupertino.dart';

class FlexWithMainChild extends StatefulWidget {
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final Clip clipBehavior;
  final Widget mainChild;
  final List<Widget> childrenBefore;
  final List<Widget> childrenAfter;

  const FlexWithMainChild({
    Key? key,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    this.childrenBefore = const <Widget>[],
    this.childrenAfter = const <Widget>[],
    required this.mainChild,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FlexWithMainChildState();
}

class _FlexWithMainChildState extends State<FlexWithMainChild> {
  final GlobalKey _key = GlobalKey();
  Size? _mainChildSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _mainChildSize =
            (_key.currentContext!.findRenderObject()! as RenderBox).size;
        debugPrint('${_mainChildSize!.width}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mainChildSize == null
        ? Offstage(
            // wrap in center to mitigate the situation when parent does not
            // permit FlexWithMainChild to have a different size (e.g. if parent
            // is the screen)
            child: Center(
              child: getFlex(),
            ),
          )
        : Center(
            child: SizedBox(
              width: widget.direction == Axis.vertical
                  ? _mainChildSize!.width
                  : null,
              height: widget.direction == Axis.horizontal
                  ? _mainChildSize!.height
                  : null,
              child: getFlex(),
            ),
          );
  }

  Widget getFlex() => Flex(
        key: _key,
        direction: widget.direction,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        // this is to combat CrossAxisAlignment.stretch
        // which forces child to take up all the space
        crossAxisAlignment: _mainChildSize == null
            ? CrossAxisAlignment.center
            : widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        clipBehavior: widget.clipBehavior,
        children: _mainChildSize == null
            ? [
                widget.mainChild,
              ]
            : [
                ...widget.childrenBefore,
                widget.mainChild,
                ...widget.childrenAfter,
              ],
      );
}
