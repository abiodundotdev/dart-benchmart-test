import 'package:flutter/material.dart';
import 'package:moniepoint/core/core.dart';

enum _LayoutSlot {
  body,
  appBar,
  background,
}

//TODO: Assert when cleaning up
class AppScaffold extends StatefulWidget {
  const AppScaffold({
    Key? key,
    required this.body,
    this.backgroundColor,
    this.background,
    this.shouldAnimate = false,
    this.animationDuration = const Duration(seconds: 1),
    this.appBar,
    this.padding,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;
  final Widget? background;
  final bool shouldAnimate;
  final EdgeInsets? padding;
  final Duration animationDuration;

  @override
  AppScaffoldState createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    if (widget.shouldAnimate) {
      animationController.forward();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    final padding = widget.padding;
    final systemPadding = queryData.padding;
    final appBarHeight = widget.appBar != null
        ? (widget.appBar!.preferredSize.height + systemPadding.top)
        : 0.0;
    final theme = context.theme;

    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            color: theme.scaffoldBackgroundColor,
            child: CustomMultiChildLayout(
              delegate: _AppScaffoldDelegate(
                viewInsets: queryData.viewInsets,
                animation: animationController,
              ),
              children: <Widget>[
                if (widget.appBar != null)
                  LayoutId(
                    id: _LayoutSlot.appBar,
                    child: SlideTransition(
                      position: animationController.drive(
                        Tween(
                          begin: widget.shouldAnimate
                              ? const Offset(0, -1)
                              : Offset.zero,
                          end: Offset.zero,
                        ),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: appBarHeight),
                        child: FlexibleSpaceBar.createSettings(
                          currentExtent: appBarHeight,
                          child: MediaQuery(
                            data: queryData.removePadding(removeBottom: true),
                            child: widget.appBar!,
                          ),
                        ),
                      ),
                    ),
                  ),
                LayoutId(
                  id: _LayoutSlot.body,
                  child: SlideTransition(
                    position: animationController.drive(
                      Tween(
                        begin: widget.shouldAnimate
                            ? const Offset(0, 1)
                            : Offset.zero,
                        end: Offset.zero,
                      ),
                    ),
                    child: MediaQuery(
                      data: queryData.removePadding(
                          removeTop: widget.appBar != null),
                      child: Padding(
                        padding: widget.padding ??
                            EdgeInsets.fromLTRB(
                                15.0, 0, 15.0, systemPadding.bottom),
                        child: widget.body,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _AppScaffoldDelegate extends MultiChildLayoutDelegate {
  _AppScaffoldDelegate({this.viewInsets, required this.animation});

  final EdgeInsets? viewInsets;
  final Animation animation;

  @override
  void performLayout(Size size) {
    final looseConstraints = BoxConstraints.loose(size);
    final fullWidthConstraints = looseConstraints.tighten(width: size.width);

    if (hasChild(_LayoutSlot.background)) {
      layoutChild(_LayoutSlot.background, fullWidthConstraints);
      positionChild(_LayoutSlot.background, Offset.zero);
    }

    double appBarHeight = 0.0;
    if (hasChild(_LayoutSlot.appBar)) {
      appBarHeight =
          layoutChild(_LayoutSlot.appBar, fullWidthConstraints).height;
      positionChild(
        _LayoutSlot.appBar,
        Offset.zero,
      );
    }

    final bodyConstraints = fullWidthConstraints.copyWith(
      maxHeight:
          fullWidthConstraints.maxHeight - appBarHeight - viewInsets!.bottom,
    );
    layoutChild(_LayoutSlot.body, bodyConstraints);
    positionChild(
      _LayoutSlot.body,
      Offset(0, appBarHeight),
    );
  }

  @override
  bool shouldRelayout(_AppScaffoldDelegate oldDelegate) =>
      viewInsets != oldDelegate.viewInsets;
}
