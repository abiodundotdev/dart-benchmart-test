import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      shouldAnimate: true,
      animationDuration: const Duration(seconds: 1),
      appBar: const CustomAppBar(),
      body: SizedBox(
        child: Container(
          color: Colors.red,
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Animation<double>? animation;
  const CustomAppBar({super.key, this.animation});

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    Widget appBar = AnnotatedRegion(
      value: const SystemUiOverlayStyle(),
      child: LayoutBuilder(builder: (context, cons) {
        return AnimatedContainer(
          height: cons.maxHeight,
          duration: const Duration(milliseconds: 1),
          color: appBarTheme.backgroundColor ?? Colors.green,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: const [Text("data")],
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        );
      }),
    );
    if (animation != null) {
      return SlideTransition(
        position: animation!.drive(
          Tween(begin: const Offset(0, -2), end: Offset.zero),
        ),
        child: appBar,
      );
    }
    return appBar;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PreferredSizeExampleApp extends StatelessWidget {
  const PreferredSizeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PreferredSizeExample(),
    );
  }
}

class AppBarContent extends StatelessWidget {
  const AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Text("data"),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class PreferredSizeExample extends StatelessWidget {
  const PreferredSizeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Colors.blue, Colors.pink],
            ),
          ),
          child: const AppBarContent(),
        ),
      ),
      body: const Center(
        child: Text(''),
      ),
    );
  }
}

enum _LayoutSlot {
  body,
  appBar,
  background,
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    Key? key,
    required this.body,
    this.backgroundColor,
    this.shouldAnimate = false,
    this.animationDuration = const Duration(seconds: 1),
    this.appBar,
    this.padding,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;
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

    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
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
                              ? const Offset(0, -2)
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
                            ? const Offset(0, 3)
                            : Offset.zero,
                        end: Offset.zero,
                      ),
                    ),
                    child: MediaQuery(
                      data: queryData.removePadding(
                          removeTop: widget.appBar != null),
                      child: Padding(
                        padding: widget.padding ??
                            EdgeInsets.fromLTRB((padding?.left ?? 0), 0,
                                (padding?.right ?? 0), systemPadding.bottom),
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

class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key});

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;
  final List<IconData> menuItems = <IconData>[
    Icons.home,
    Icons.new_releases,
    Icons.notifications,
    Icons.settings,
    Icons.menu,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.menu) {
      setState(() => lastTapped = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter =
        MediaQuery.of(context).size.width / menuItems.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RawMaterialButton(
        fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
        splashColor: Colors.amber[100],
        shape: const CircleBorder(),
        constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
        onPressed: () {
          _updateMenu(icon);
          menuAnimation.status == AnimationStatus.completed
              ? menuAnimation.reverse()
              : menuAnimation.forward();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
      children:
          menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx * menuAnimation.value,
          0,
          0,
        ),
      );
    }
  }
}
